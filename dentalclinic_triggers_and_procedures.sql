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
