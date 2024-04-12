-- patient with the most visits
select A.patientID, count(*) as `totalVisits` from `appointment` A
inner join patient P on A.PatientID = P.PatientID where A.AppointmentStatus = 'Completed'
group by A.PatientID order by `totalVisits` desc;


--Highest paying Customers/patient spending
SELECT A.PatientID, P.FirstName, P.Email, SUM(S.Cost) AS `totalSpent`
FROM `appointment` A
LEFT JOIN `service` S ON A.ServiceCode = S.ServiceCode
LEFT JOIN `patient` P ON A.PatientID = P.PatientID
WHERE A.AppointmentStatus = 'Completed' OR A.AppointmentStatus = 'Missed'
GROUP BY A.PatientID
ORDER BY `totalSpent` DESC;

--most visited dentist/Dentist with most appointments
select A.DentistID, count(*) as `Appointments` from appointment A inner join 
dentist D on D.DentistID = A.DentistID group by A.DentistID order by `Appointments` desc;

--Most requested dental service
CREATE VIEW `MostRequestedService` AS
SELECT A.ServiceCode AS ServiceID, S.ServiceName AS `Service`, MAX(`ServiceRequests`) AS `MaxServiceRequests`
FROM (
    SELECT A.ServiceCode, S.ServiceName, COUNT(*) AS `ServiceRequests`
    FROM `appointment` A
    INNER JOIN `service` S ON A.ServiceCode = S.ServiceCode
    GROUP BY A.ServiceCode, S.ServiceName
    ORDER BY `ServiceRequests` DESC
) AS Services
GROUP BY Services.ServiceCode, Services.ServiceName;

--Least requested dental service
CREATE VIEW `LeastRequestedService` AS
SELECT A.ServiceCode AS ServiceID, S.ServiceName AS `Service`, MIN(`ServiceRequests`) AS `MinServiceRequests`
FROM (
    SELECT A.ServiceCode, S.ServiceName, COUNT(*) AS `ServiceRequests`
    FROM `appointment` A
    INNER JOIN `service` S ON A.ServiceCode = S.ServiceCode
    GROUP BY A.ServiceCode, S.ServiceName
    ORDER BY `ServiceRequests` DESC
) AS Services
GROUP BY Services.ServiceCode, Services.ServiceName;


--Service specific max count
SELECT A.ServiceCode AS ServiceID, S.ServiceName AS `Service`, COUNT(*) AS MaxCount
FROM appointment A
INNER JOIN `Service` S ON A.ServiceCode = S.ServiceCode
GROUP BY A.ServiceCode, S.ServiceName
HAVING COUNT(*) = (
    SELECT MAX(Count)
    FROM (
        SELECT COUNT(*) AS Count
        FROM appointment
        GROUP BY ServiceCode
    ) AS MaxCounts
);

--Service specific min count
SELECT A.ServiceCode AS ServiceID, S.ServiceName AS `Service`, COUNT(*) AS MinCount
FROM appointment A
INNER JOIN `Service` S ON A.ServiceCode = S.ServiceCode
GROUP BY A.ServiceCode, S.ServiceName
HAVING COUNT(*) = (
    SELECT MIN(Count)
    FROM (
        SELECT COUNT(*) AS Count
        FROM appointment
        GROUP BY ServiceCode
    ) AS MinCounts
);

--Most Canceled service appointment
SELECT A.ServiceCode AS ServiceID, S.ServiceName AS `Service`, COUNT(*) AS CancelledAppointments
FROM appointment A
INNER JOIN Service S ON A.ServiceCode = S.ServiceCode
WHERE A.AppointmentStatus = 'Cancelled'
GROUP BY A.ServiceCode, S.ServiceName
ORDER BY CancelledAppointments DESC
LIMIT 1;

--patient age distribution
-- Create a view for Patient Age Distribution and Appointment Count
CREATE VIEW PatientAgeAndAppointmentCount AS
SELECT 
    CASE
        WHEN TIMESTAMPDIFF(YEAR, P.DOB, CURDATE()) BETWEEN 0 AND 20 THEN '0-20'
        WHEN TIMESTAMPDIFF(YEAR, P.DOB, CURDATE()) BETWEEN 21 AND 40 THEN '21-40'
        WHEN TIMESTAMPDIFF(YEAR, P.DOB, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '61+'
    END AS AgeGroup,
    COUNT(*) AS PatientCount,
    COUNT(A.AppointmentID) AS AppointmentCount
FROM patient P
LEFT JOIN appointment A ON P.PatientID = A.PatientID
GROUP BY AgeGroup;

SELECT * FROM PatientAgeAndAppointmentCount;

-- Dentists with most positive appointment feedbacks
SELECT 
    A.AppointmentID,
    A.DentistID,
    D.FirstName,
    D.LastName,
    Count(CASE WHEN A.PatientFeedback LIKE '%positive%' AND A.PatientFeedback LIKE '%dentist%' THEN 1 ELSE NULL END) AS `PositiveFeedbacks`
FROM appointment A
INNER JOIN Dentist D ON A.DentistID = D.DentistID
GROUP BY D.DentistID, D.FirstName, D.LastName
ORDER BY PositiveFeedbacks DESC
LIMIT 1;

--Dentist with most negative appointment feedbacks
SELECT 
    A.DentistID,
    D.FirstName,
    D.LastName,
    COUNT(CASE WHEN A.PatientFeedback LIKE '%negative%' AND A.PatientFeedback LIKE '%dentist%' THEN 1 ELSE NULL END) AS `NegativeFeedbacks`
FROM `appointment` A
INNER JOIN `dentist` D ON A.DentistID = D.DentistID
GROUP BY D.DentistID, D.FirstName, D.LastName
ORDER BY `NegativeFeedbacks` DESC
LIMIT 1;


