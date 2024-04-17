-- Check appointment date is a current or future date
CREATE TRIGGER CheckAppointmentDate
BEFORE INSERT ON `appointment`
FOR EACH ROW
BEGIN
    IF NEW.AppointmentDate < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment date must be today or a future date';
    END IF;
END;

--Prevent overbooking/appointment overlapping trigger
CREATE TRIGGER PreventOverbooking
BEFORE INSERT ON `appointment`
FOR EACH ROW
BEGIN
    DECLARE overlap INT;
    SELECT COUNT(*) INTO overlap
    FROM `appointment`
    WHERE `DentistID` = NEW.DentistID
    AND (`AppointmentTime` = NEW.AppointmentTime 
            OR (`AppointmentTime` BETWEEN ADDTIME(NEW.AppointmentTime, '-2:00')
                AND ADDTIME(NEW.AppointmentTime, '2:00'))
        );
    IF overlap > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment overlaps with another appointment for the dentist';
    END IF;
END;

--Log appointment cancellations trigger
CREATE TRIGGER Log_Missed_And_Cancelled_Appointments
AFTER UPDATE ON `appointment`
FOR EACH ROW
BEGIN
    IF OLD.AppointmentStatus <> 'Cancelled' AND NEW.AppointmentStatus = 'Cancelled' THEN
        -- Log cancelled appointment
        INSERT INTO `appointmentlog` (`ID`, `Action`, `ActionDateTime`)
        VALUES (NEW.AppointmentID, 'Cancelled', NOW());
    ELSEIF OLD.AppointmentStatus <> 'Missed' AND NEW.AppointmentStatus = 'Missed' THEN
        -- Log missed appointment
        INSERT INTO `appointmentlog` (`ID`, `Action`, `ActionDateTime`)
        VALUES (NEW.AppointmentID, 'Missed', NOW());
    END IF;
END;

--prevent duplicate inserts into appointment table
CREATE TRIGGER prevent_duplicate_appointment
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
    DECLARE duplicate_found INT;
    SELECT COUNT(*) INTO duplicate_found
    FROM appointment
    WHERE PatientID = NEW.PatientID
      AND DentistID = NEW.DentistID
      AND AppointmentDate = NEW.AppointmentDate
      AND AppointmentTime = NEW.AppointmentTime
      AND ServiceCode = NEW.ServiceCode;
    
    IF duplicate_found > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate appointment found';
    END IF;
END

--prevent duplicate inserts into dentist table
CREATE TRIGGER prevent_duplicate_dentist
BEFORE INSERT ON dentist
FOR EACH ROW
BEGIN
    DECLARE duplicate_found INT;
    SELECT COUNT(*) INTO duplicate_found
    FROM dentist
    WHERE FirstName = NEW.FirstName
      AND LastName = NEW.LastName
      AND ContactNumber = NEW.ContactNumber;
    
    IF duplicate_found > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate dentist found';
    END IF;
END;

--prevent duplicate inserts into patient table
CREATE TRIGGER prevent_duplicate_patient
BEFORE INSERT ON patient
FOR EACH ROW
BEGIN
    DECLARE duplicate_found INT;
    SELECT COUNT(*) INTO duplicate_found
    FROM patient
    WHERE FirstName = NEW.FirstName
      AND LastName = NEW.LastName
      AND DOB = NEW.DOB;
    
    IF duplicate_found > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate patient found';
    END IF;
END;

--prevent duplicate inserts into Services table
CREATE TRIGGER prevent_duplicate_service
BEFORE INSERT ON `service`
FOR EACH ROW
BEGIN
    DECLARE duplicate_found INT;
    SELECT COUNT(*) INTO duplicate_found
    FROM service
    WHERE ServiceCode = NEW.ServiceCode
    OR ServiceName = NEW.ServiceName;
    
    IF duplicate_found > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate service found';
    END IF;
END

--prevent duplicate inserts into ServicesByDentist table
CREATE TRIGGER prevent_duplicate_servicesByDentist
BEFORE INSERT ON servicesByDentist
FOR EACH ROW
BEGIN
    DECLARE duplicate_found INT;
    SELECT COUNT(*) INTO duplicate_found
    FROM servicesByDentist
    WHERE ServiceCode = NEW.ServiceCode AND
     DentistID = NEW.DentistID;
    
    IF duplicate_found > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate service by Dentist found';
    END IF;
END;

--Record patient feedback after appointment procedure
CREATE PROCEDURE Record_Patient_Feedback(
    IN appointment_id INT,
    IN feedback TEXT
)
BEGIN
    UPDATE `appointment`
    SET `PatientFeedback` = feedback
    WHERE `AppointmentID` = appointment_id;
END;

--Record dentist report after appointment procedure
CREATE PROCEDURE Record_Dentist_Report(
    IN appointment_id INT,
    IN report TEXT
)
BEGIN
    UPDATE `appointment`
    SET `DentistReport` = report
    WHERE `AppointmentID` = appointment_id;
END;

--Record dentist prescription after appointment procedure
CREATE PROCEDURE Record_Prescription(
    IN appointment_id INT,
    IN presc TEXT
)
BEGIN
    UPDATE `appointment`
    SET `Prescription` = presc
    WHERE `AppointmentID` = appointment_id;
END;

--Cancel appointment procedure
CREATE PROCEDURE Cancel_Appointment(
    IN app_id INT
)
BEGIN
    UPDATE `appointment`
    SET `AppointmentStatus` = 'Cancelled'
    WHERE `AppointmentID` = appointment_id;
END;

--schedule appointment procedure
CREATE PROCEDURE Schedule_Appointment(
    IN dentist_id,
    IN patient_id,
    IN service_code,
    IN app_date,
    IN app_time,
)
BEGIN
    INSERT INTO `appointment` (`PatientID`, `DentistID`, `ServiceCode`, `AppointmentDate`, `AppointmentTime`)
    VALUES (patient_id, dentist_id, service_code, app_date,  app_time);
END;


--Get Patient Medical/Appointment History Procedure
DELIMITER //

CREATE PROCEDURE GetPatientAppointmentHistory(
    IN fullName VARCHAR(60)  -- Input parameter for the patient's full name
)
BEGIN
    DECLARE firstName VARCHAR(30);
    DECLARE lastName VARCHAR(30);
    DECLARE patientID INT;

    -- Split the full name into first and last names
    SET firstName = SUBSTRING_INDEX(fullName, ' ', 1);
    SET lastName = SUBSTRING(fullName, CHAR_LENGTH(firstName) + 2);

    -- Find the patient's ID based on the provided full name
    SELECT PatientID INTO patientID
    FROM patient
    WHERE (FirstName = firstName AND LastName = lastName)
    OR (FirstName = lastName AND LastName = firstName);

    -- If the patient ID was found, query the appointment history
    IF patientID IS NOT NULL THEN
        SELECT
            A.AppointmentID,
            A.AppointmentDate,
            A.ServiceCode,
            A.AppointmentStatus,
            A.DentistReport,
            A.Prescription,
            A.PatientFeedback
        FROM appointment A
        WHERE A.PatientID = patientID
        ORDER BY A.AppointmentDate;
    ELSE
        -- If no patient ID is found, print a message
        SELECT 'No patient found with the provided full name.' AS Message;
    END IF;
END //

DELIMITER ;

