--Set default appointment status to 'upcoming' on insert into appointment table trigger
CREATE TRIGGER SetDefaultAppointmentStatus
BEFORE INSERT ON `appointment`
FOR EACH ROW
BEGIN
    IF NEW.AppointmentStatus IS NULL THEN
        SET NEW.AppointmentStatus = 'Upcoming';
    END IF;
END;

--Check appointment date range for new appointment trigger
CREATE TRIGGER CheckAppointmentDate
BEFORE INSERT ON `appointment`
FOR EACH ROW
BEGIN
    DECLARE min_appointment_date DATE;
    SET min_appointment_date = DATE_ADD(CURDATE(), INTERVAL 3 MONTH);
    IF NEW.AppointmentDate NOT BETWEEN CURDATE() AND min_appointment_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment date must be at least 3 months from the current date';
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
    AND NEW.AppointmentDate = `AppointmentDate`
    AND ((NEW.StartTime BETWEEN `StartTime` AND `EndTime`) OR (NEW.EndTime BETWEEN `StartTime` AND `EndTime`));
    
    IF overlap > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment overlaps with another appointment for the dentist';
    END IF;
END;

--Log appointment cancellations trigger
CREATE TRIGGER LogAppointmentCancellation
AFTER UPDATE ON `appointment`
FOR EACH ROW
BEGIN
    IF OLD.AppointmentStatus <> 'Cancelled' AND NEW.AppointmentStatus = 'Cancelled' THEN
        INSERT INTO `appointmentLog` (`ID`, `Action`, `ActionDateTime`)
        VALUES (NEW.AppointmentID, 'Cancelled', NOW());
    END IF;
END;

-- Apply 10% missed apointment charge trigger
CREATE TRIGGER ApplyMissedAppointmentCharge
AFTER UPDATE ON `appointment`
FOR EACH ROW
BEGIN
    -- Check if the appointment status changed to "Missed"
    IF OLD.AppointmentStatus <> 'Missed' AND NEW.AppointmentStatus = 'Missed' THEN
        -- Calculate the 10% charge on the appointment cost
        DECLARE charge DECIMAL(10, 2);
        SET charge = NEW.Cost * 0.10;
        
        -- Update the payment status to "Unpaid" since the patient needs to pay the charge
        SET NEW.PaymentStatus = 'Unpaid';
        
        -- Apply the 10% charge to the appointment cost
        SET NEW.Cost = NEW.Cost + charge;
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
    WHERE `AppointmentID` = app_id;
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


