<?php
// Establish a connection to the database
$servername = "localhost";
$username = "root";
$password = ""; // Use your MySQL password here
$database = "dentalclinic"; // Replace with your database name

// Create a connection
$conn = new mysqli($servername, $username, $password, $database);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the topic from the POST request
$topic = isset($_POST['topic']) ? $_POST['topic'] : '';

// Initialize a variable to hold the query
$query = '';
$response = '';

// Define queries based on the topic
switch ($topic) {
    case 'patient_most_visits':
        $query = "SELECT P.FirstName, P.LastName, COUNT(A.AppointmentID) AS TotalVisits
                  FROM patient P
                  INNER JOIN appointment A ON P.PatientID = A.PatientID
                  WHERE A.AppointmentStatus = 'Completed'
                  GROUP BY P.PatientID
                  ORDER BY TotalVisits DESC
                  LIMIT 3";
        break;

    case 'highest_paying_customers':
        $query = "SELECT P.FirstName, P.LastName, SUM(S.Cost) AS TotalSpent
                  FROM patient P
                  INNER JOIN appointment A ON P.PatientID = A.PatientID
                  INNER JOIN service S ON A.ServiceCode = S.ServiceCode
                  WHERE A.AppointmentStatus IN ('Completed', 'Missed')
                  GROUP BY P.PatientID
                  ORDER BY TotalSpent DESC
                  LIMIT 3";
        break;

    case 'most_visited_dentist':
        $query = "SELECT D.FirstName, D.LastName, COUNT(A.AppointmentID) AS TotalAppointments
                  FROM dentist D
                  INNER JOIN appointment A ON D.DentistID = A.DentistID
                  GROUP BY D.DentistID
                  ORDER BY TotalAppointments DESC
                  LIMIT 1";
        break;

    case 'most_requested_services':
        $query = "SELECT S.ServiceName, COUNT(A.AppointmentID) AS ServiceRequests
                  FROM service S
                  INNER JOIN appointment A ON S.ServiceCode = A.ServiceCode
                  GROUP BY S.ServiceName
                  ORDER BY ServiceRequests DESC";
        break;

    case 'most_cancelled_appointments':
        $query = "SELECT S.ServiceName, COUNT(A.AppointmentID) AS CancelledAppointments
                  FROM service S
                  INNER JOIN appointment A ON S.ServiceCode = A.ServiceCode
                  WHERE A.AppointmentStatus = 'Cancelled'
                  GROUP BY S.ServiceName
                  ORDER BY CancelledAppointments DESC
                  LIMIT 1";
        break;

    case 'patient_age_distribution':
        $query = "SELECT CASE
                        WHEN TIMESTAMPDIFF(YEAR, P.DOB, CURDATE()) BETWEEN 0 AND 20 THEN '0-20'
                        WHEN TIMESTAMPDIFF(YEAR, P.DOB, CURDATE()) BETWEEN 21 AND 40 THEN '21-40'
                        WHEN TIMESTAMPDIFF(YEAR, P.DOB, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
                        ELSE '61+'
                    END AS AgeGroup,
                    COUNT(P.PatientID) AS PatientCount
                    FROM patient P
                    GROUP BY AgeGroup";
        break;

    case 'dentist_positive_feedbacks':
        $query = "SELECT D.FirstName, D.LastName, COUNT(A.AppointmentID) AS PositiveFeedbacks
                  FROM dentist D
                  INNER JOIN appointment A ON D.DentistID = A.DentistID
                  WHERE A.PatientFeedback LIKE '%positive%' AND A.PatientFeedback LIKE '%dentist%'
                  GROUP BY D.DentistID
                  ORDER BY PositiveFeedbacks DESC
                  LIMIT 1";
        break;

    case 'dentist_negative_feedbacks':
        $query = "SELECT D.FirstName, D.LastName, COUNT(A.AppointmentID) AS NegativeFeedbacks
                  FROM dentist D
                  INNER JOIN appointment A ON D.DentistID = A.DentistID
                  WHERE A.PatientFeedback LIKE '%negative%' AND A.PatientFeedback LIKE '%dentist%'
                  GROUP BY D.DentistID
                  ORDER BY NegativeFeedbacks DESC
                  LIMIT 1";
        break;

    default:
        // If no valid topic is provided, set a default response
        $response = "Invalid topic provided.";
        break;
}

// Execute the query if it is set
if ($query != '') {
    $result = $conn->query($query);

    if ($result && $result->num_rows > 0) {
        // Build the response as an HTML table
        $response = '<table class="report-table">';
        $response .= '<thead><tr>';

        // Add headers based on the result columns
        $field_info = $result->fetch_fields();
        foreach ($field_info as $field) {
            $response .= '<th>' . htmlspecialchars($field->name) . '</th>';
        }
        $response .= '</tr></thead><tbody>';

        // Add rows based on the result set
        while ($row = $result->fetch_assoc()) {
            $response .= '<tr>';
            foreach ($row as $cell) {
                $response .= '<td>' . htmlspecialchars($cell) . '</td>';
            }
            $response .= '</tr>';
        }

        $response .= '</tbody></table>';
    } else {
        $response = "No data available for the selected topic.";
    }
}

// Close the database connection
$conn->close();

// Return the response as the AJAX request result
echo $response;
?>
