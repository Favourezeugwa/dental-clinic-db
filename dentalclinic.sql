CREATE DATABASE IF NOT EXISTS dentalclinic;
USE dentalclinic;

-- Table structure for table `patient`
CREATE TABLE `patient` (
    `PatientID` INT PRIMARY KEY AUTO_INCREMENT,
    `FirstName` VARCHAR(30) NOT NULL,
    `LastName` VARCHAR(30) NOT NULL,
    `DOB` DATE NOT NULL,
    `Gender` VARCHAR(6) CHECK (`Gender` IN ('male', 'female')),
    `Email` VARCHAR(30) NOT NULL,
    `PhoneNumber` CHAR(10) NOT NULL,
    `Address` VARCHAR(50) NOT NULL,
    `City` VARCHAR(30) NOT NULL,
    `ZipCode` CHAR(5) NOT NULL
);

-- Dumping data for table `patient`
INSERT INTO `patient` (`FirstName`, `LastName`, `DOB`, `Gender`, `PhoneNumber`, `Email`, `Address`, `City`, `ZipCode`) VALUES
('Stephen', 'Anidi', '2001-04-23', 'male', '8324567866', 'stephena@yahoo.com', '702 Santee st', 'Prairie View', '77446'),
('Mark', 'James', '1998-05-05', 'male', '8324667866', 'marko@yahoo.com', '702 Santee st', 'Prairie View', '77446'),
('Luke', 'Waters', '2001-12-18', 'male', '8324567800', 'lukewat@gmail.com', '702 Santee st', 'Prairie View', '77446'),
('Jack', 'Reese', '1981-03-18', 'male', '2814597166', 'jackreese@outlook.com', '702 Santee st', 'Prairie View', '77446'),
('Sarah', 'Truce', '1991-03-20', 'female', '8320007113', 'sarahtruce98@yahoo.com', '702 Santee st', 'Prairie View', '77446'),
('Bill', 'Kent', '1983-06-14', 'male', '8321567866', 'founderbill@yahoo.com', '702 Santee st', 'Prairie View', '77446'),
('Tracy', 'Rogers', '1999-04-18', 'female', '8323261966', 'trayrogers@gmail.com', '702 Santee st', 'Prairie View', '77446');

-- Table structure for table `dentist`
CREATE TABLE `dentist` (
    `DentistID` INT PRIMARY KEY AUTO_INCREMENT,
    `FirstName` VARCHAR(30) NOT NULL,
    `LastName` VARCHAR(30) NOT NULL,
    `Specialty` VARCHAR(30) NOT NULL,
    `ContactNumber` CHAR(10) NOT NULL,
    `Email` VARCHAR(30) NOT NULL
);

-- Dumping data for table `dentist`
INSERT INTO `dentist` (`FirstName`, `LastName`, `Specialty`, `ContactNumber`, `Email`) VALUES
('Andre', 'Smith', 'Dentistry', '9794567890', 'asmith@dentalclinic.com'),
('Marta', 'Diaz', 'Dentistry', '9794578930', 'mdiaz@dentalclinic.com'),
('Michael', 'Hoffman', 'Orthodontology', '9794678320', 'mhoffman@dentalclinic.com'),
('Emily', 'Johnson', 'Pediatric Dentistry', '9876543210', 'ejohnson@dentalclinic.com'),
('Daniel', 'Lee', 'Orthodontics', '9876543211', 'dlee@dentalclinic.com'),
('Samantha', 'Wilson', 'Oral Surgery', '9876543212', 'swilson@dentalclinic.com'),
('Kevin', 'Garcia', 'Periodontics', '9876543213', 'kgarcia@dentalclinic.com'),
('Jessica', 'Martinez', 'Endodontics', '9876543214', 'jmartinez@dentalclinic.com'),
('Brian', 'Wong', 'Cosmetic Dentistry', '9876543215', 'bwong@dentalclinic.com');

-- Table structure for table `service`
CREATE TABLE `service` (
    `ServiceCode` CHAR(3) PRIMARY KEY,
    `ServiceName` VARCHAR(30) NOT NULL,
    `Cost` DECIMAL(10,2) NOT NULL
);

-- Dumping data for table `service`
INSERT INTO `service` (`ServiceCode`, `ServiceName`, `Cost`) VALUES
('CON', 'Consultation', 90.00),
('DBG', 'Dental Bone Grafts', 1525.00),
('PSU', 'Periodontal Surgery', 5000.00),
('TEX', 'Tooth Extraction', 150.00),
('FIL', 'Dental Filling', 200.00),
('RCT', 'Root Canal Treatment', 1000.00),
('DEC', 'Dental Cleaning', 120.00),
('IMP', 'Dental Implant', 3000.00),
('BRI', 'Dental Bridge', 2500.00),
('BRA', 'Braces', 4000.00),
('CSU', 'Cosmetic Surgery', 6000.00),
('OMS', 'Oral and Maxillofacial Surgery', 6000.00);

-- Table structure for table `servicesByDentist`
CREATE TABLE `servicesByDentist` (
  `ServiceCode` CHAR(3) NOT NULL,
  `DentistID` INT NOT NULL,
  PRIMARY KEY (`ServiceCode`, `DentistID`),
  CONSTRAINT `fk_serviceCode` FOREIGN KEY (`ServiceCode`) REFERENCES `service` (`ServiceCode`) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_dentistID` FOREIGN KEY (`DentistID`) REFERENCES `dentist` (`DentistID`) ON DELETE RESTRICT
);

INSERT INTO `servicesByDentist` (`ServiceCode`, `DentistID`)
VALUES 
    ('CON', 1), ('DBG', 1), ('PSU', 1),
    ('TEX', 2), ('FIL', 2), ('RCT', 2),
    ('DEC', 3), ('IMP', 3), ('BRI', 3),
    ('BRA', 4), ('CSU', 4), ('OMS', 4),
    ('CON', 5), ('TEX', 5), ('FIL', 5),
    ('DEC', 6), ('IMP', 6), ('BRI', 7),
    ('BRA', 7), ('CSU', 7), ('OMS', 8),
    ('CON', 8), ('TEX', 9), ('FIL', 9);

-- Table structure for table `appointment`
CREATE TABLE `appointment` (
    `AppointmentID` INT PRIMARY KEY AUTO_INCREMENT,
    `PatientID` INT NOT NULL,
    `ServiceCode` CHAR(3) NOT NULL,
    `DentistID` INT NOT NULL,
    `AppointmentDate` DATE NOT NULL,
    `AppointmentTime` TIME NOT NULL CHECK (`AppointmentTime` BETWEEN '09:00:00' AND '16:00:00'),
    `AppointmentStatus` VARCHAR(10) DEFAULT 'Upcoming' CHECK (`AppointmentStatus` IN ('Upcoming', 'Completed', 'Missed', 'Cancelled')),
    `DentistReport` TEXT DEFAULT NULL,
    `Prescription` TEXT DEFAULT NULL,
    `PatientFeedback` TEXT DEFAULT NULL,
    CONSTRAINT `fk_PatientID` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`),
    CONSTRAINT `fk_DentistID_ServiceCode` FOREIGN KEY (`DentistID`,`ServiceCode`) REFERENCES `servicesByDentist` (`DentistID`,`ServiceCode`) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `chk_appointment_time_format` CHECK (TIME_FORMAT(`AppointmentTime`, '%H:%i:%s') = CONCAT(TIME_FORMAT(`AppointmentTime`, '%H:%i'), ':00'))
);

INSERT INTO `appointment` (`PatientID`, `ServiceCode`, `DentistID`, `AppointmentDate`, `AppointmentTime`, `AppointmentStatus`, `DentistReport`, `Prescription`, `PatientFeedback`)
VALUES
(1, 'CON', 1, '2024-03-15', '10:00:00', 'Completed', 'No report', 'Prescription for medication X', 'Positive feedback: Excellent service and care'),
(2, 'TEX', 2, '2024-03-15', '11:00:00', 'Completed', 'Needs rescheduling', 'Prescription for pain relief', 'Negative feedback: Long waiting time'),
(3, 'PSU', 1, '2024-03-15', '12:00:00', 'Completed', 'Preparation required', NULL, 'Positive feedback: Professional and friendly staff'),
(4, 'FIL', 2, '2024-03-16', '13:00:00', 'Cancelled', NULL, NULL, NULL),
(5, 'DEC', 3, '2024-03-16', '12:00:00', 'Completed', 'No issues reported', NULL, 'Negative feedback: Uncomfortable during treatment'),
(6, 'CON', 1, '2024-03-17', '10:00:00', 'Completed', 'Needs rescheduling', 'Prescription for mouthwash', 'Positive feedback: Dentist was very informative'),
(1, 'TEX', 5, '2024-03-17', '11:00:00', 'Cancelled', NULL, NULL, NULL),
(4, 'DEC', 3, '2024-04-01', '13:00:00', 'Completed', 'Needs rescheduling','Prescription for oral hygiene', 'Positive feedback: Staff was helpful and courteous'),
(7, 'FIL', 5, '2024-04-02', '14:00:00', 'Completed', 'No issues reported', NULL, 'Negative feedback: Facilities were not clean'),
(2, 'RCT', 2, '2024-04-03', '15:00:00', 'Completed', 'Needs rescheduling', 'Prescription for dental floss', 'Positive feedback: Easy booking process'),
(1, 'BRA', 4, '2024-04-04', '11:00:00', 'Completed', 'Preparation required', NULL, 'Negative feedback: Dentist seemed rushed'),
(3, 'OMS', 4, '2024-04-04', '09:00:00', 'Completed', 'Preparation required','Prescription for pain relief', 'Positive feedback: Painless procedure'),
(6, 'FIL', 2, '2024-04-20', '10:00:00', 'Upcoming', NULL, NULL, NULL),
(1, 'CON', 1, '2024-04-21', '11:00:00', 'Upcoming', NULL, NULL, NULL),
(7, 'IMP', 3, '2024-04-21', '12:00:00', 'Upcoming', NULL, NULL, NULL);

-- Table structure for table `appointmentLog`
CREATE TABLE `appointmentLog`
(`ID` INT NOT NULL PRIMARY KEY,
`Action` VARCHAR(10) NOT NULL,
`ActionDateTime` DATETIME NOT NULL,
CONSTRAINT `fk_dentistID_appointmentLog` FOREIGN KEY (`ID`) REFERENCES `appointment` (`AppointmentID`));
