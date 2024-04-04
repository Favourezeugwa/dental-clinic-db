-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 04, 2024 at 04:30 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dentalclinic`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--

CREATE TABLE `appointment` (
  `AppointmentID` int(11) NOT NULL,
  `PatientID` int(11) NOT NULL,
  `ServiceName` varchar(20) NOT NULL,
  `ServiceType` char(3) NOT NULL,
  `ServiceProviderID` int(11) NOT NULL,
  `AppointmentDate` date NOT NULL,
  `Cost` decimal(10,2) NOT NULL,
  `PaymentID` int(11) NOT NULL,
  `AppointmentStatus` varchar(10) NOT NULL,
  `PaymentStatus` char(4) NOT NULL,
  `AppointmentReport` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `card`
--

CREATE TABLE `card` (
  `CardNumber` int(11) NOT NULL,
  `CardType` varchar(6) NOT NULL,
  `CardSponsor` varchar(8) NOT NULL,
  `NameonCard` varchar(40) NOT NULL,
  `ExpDate` date NOT NULL,
  `ZipCode` char(5) NOT NULL,
  `CVV` char(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patient`
--

CREATE TABLE `patient` (
  `PatientID` int(11) NOT NULL,
  `FirstName` varchar(30) NOT NULL,
  `LastName` varchar(30) NOT NULL,
  `DOB` date NOT NULL,
  `PhoneNum` char(10) NOT NULL,
  `Email` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patientcard`
--

CREATE TABLE `patientcard` (
  `PatientID` int(11) DEFAULT NULL,
  `CardNumber` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `PaymentID` int(11) NOT NULL,
  `Amount` decimal(18,2) NOT NULL,
  `PatientID` int(11) NOT NULL,
  `CardNumber` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `provider`
--

CREATE TABLE `provider` (
  `ProviderID` int(11) NOT NULL,
  `Specialty` varchar(20) NOT NULL,
  `FirsName` varchar(30) NOT NULL,
  `LastName` varchar(30) NOT NULL,
  `BirthDate` date NOT NULL,
  `ContactNumber` char(10) NOT NULL,
  `Email` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `provider`
--

INSERT INTO `provider` (`ProviderID`, `Specialty`, `FirsName`, `LastName`, `BirthDate`, `ContactNumber`, `Email`) VALUES
(10000, 'Dentistry', 'Andre', 'smith', '1979-04-23', '9794567890', 'asmith@dentalclinic.com'),
(10001, 'Dentistry', 'Marta', 'Diaz', '1990-09-13', '9794578930', 'mdiaz@dentalclinic.com'),
(10002, 'Orthodontology', 'Michael', 'Hoffman', '1990-09-13', '9794678320', 'mhoffman@dentalclinic.com');

-- --------------------------------------------------------

--
-- Table structure for table `service`
--

CREATE TABLE `service` (
  `ServiceType` char(3) NOT NULL,
  `ServiceName` varchar(20) NOT NULL,
  `cost` decimal(18,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `service`
--

INSERT INTO `service` (`ServiceType`, `ServiceName`, `cost`) VALUES
('CON', 'Consultation', 90.00),
('DBG', 'Dental Bone Grafts', 1525.00),
('PSU', 'Periodontal Surgery', 5000.00),
('TEX', 'Tooth Extraction', 150.00);

-- --------------------------------------------------------

--
-- Table structure for table `servicebyprovider`
--

CREATE TABLE `servicebyprovider` (
  `ServiceName` varchar(20) NOT NULL,
  `serviceType` char(3) NOT NULL,
  `ServiceProviderID` int(11) NOT NULL,
  `ServiceCost` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`AppointmentID`),
  ADD KEY `PatientID` (`PatientID`),
  ADD KEY `ServiceProviderID` (`ServiceProviderID`),
  ADD KEY `PaymentID` (`PaymentID`);

--
-- Indexes for table `card`
--
ALTER TABLE `card`
  ADD PRIMARY KEY (`CardNumber`);

--
-- Indexes for table `patient`
--
ALTER TABLE `patient`
  ADD PRIMARY KEY (`PatientID`);

--
-- Indexes for table `patientcard`
--
ALTER TABLE `patientcard`
  ADD KEY `PatientID` (`PatientID`),
  ADD KEY `CardNumber` (`CardNumber`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`PaymentID`),
  ADD KEY `PatientID` (`PatientID`),
  ADD KEY `CardNumber` (`CardNumber`);

--
-- Indexes for table `provider`
--
ALTER TABLE `provider`
  ADD PRIMARY KEY (`ProviderID`);

--
-- Indexes for table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`ServiceType`,`ServiceName`);

--
-- Indexes for table `servicebyprovider`
--
ALTER TABLE `servicebyprovider`
  ADD KEY `serviceType` (`serviceType`,`ServiceName`),
  ADD KEY `ServiceProviderID` (`ServiceProviderID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `AppointmentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70000;

--
-- AUTO_INCREMENT for table `card`
--
ALTER TABLE `card`
  MODIFY `CardNumber` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3000000;

--
-- AUTO_INCREMENT for table `patient`
--
ALTER TABLE `patient`
  MODIFY `PatientID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20000;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `PaymentID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `provider`
--
ALTER TABLE `provider`
  MODIFY `ProviderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9223372036854775807;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`),
  ADD CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`ServiceProviderID`) REFERENCES `provider` (`ProviderID`),
  ADD CONSTRAINT `appointment_ibfk_3` FOREIGN KEY (`PaymentID`) REFERENCES `payment` (`PaymentID`);

--
-- Constraints for table `patientcard`
--
ALTER TABLE `patientcard`
  ADD CONSTRAINT `patientcard_ibfk_1` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`),
  ADD CONSTRAINT `patientcard_ibfk_2` FOREIGN KEY (`CardNumber`) REFERENCES `card` (`CardNumber`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`),
  ADD CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`CardNumber`) REFERENCES `card` (`CardNumber`);

--
-- Constraints for table `servicebyprovider`
--
ALTER TABLE `servicebyprovider`
  ADD CONSTRAINT `servicebyprovider_ibfk_1` FOREIGN KEY (`serviceType`,`ServiceName`) REFERENCES `service` (`ServiceType`, `ServiceName`),
  ADD CONSTRAINT `servicebyprovider_ibfk_2` FOREIGN KEY (`ServiceProviderID`) REFERENCES `provider` (`ProviderID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
