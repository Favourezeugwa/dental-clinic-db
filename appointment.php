<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="queries.css" />
    <title>Dental Clinic Dashboard</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
</head>

<body>
    <div class="dashboard">
        <!-- Vertical menu -->
        <nav class="menu">
        <div class="logo">
          <h2>DentalClinic</h2>
        </div>
        <ul class="menu-list">
          <li>
            <a href="index.php"><i class="fa fa-home"></i> Home</a>
          </li>
          <li>
            <a href="#"
              ><i class="fa-regular fa-calendar-check"></i>Appointments</a
            >
          </li>
          <li>
            <a href="patient.php"
              ><i class="fa-solid fa-user-injured"></i>Patients</a
            >
          </li>
          <li>
            <a href="dentist.php"><i class="fa-solid fa-user-md"></i>Dentist</a>
          </li>
          <li>
              <a href="service.php"><i class="fa-solid fa-list-alt"></i> Services</a>
          </li>
          <li>
              <a href="service_by_dentist.php"><i class="fa-solid fa-tooth"></i> Services by Dentist</a>
          </li>
          <li>
            <a href="reports.php"
              ><i class="fa fa-clipboard-list"></i></i>Reports</a
            >
          </li>
          <li>
              <a href="log.php"><i class="fa-solid fa-history"></i> Logs</a>
          </li>
          <li>
            <a href="#"><i class="fa-solid fa-cog"></i>Settings</a>
          </li>
        </ul>
      </nav>

        <div class="main-content">
            <h1>All Appointments</h1>

            <?php
            // (1) Make a connection to the mydentalclinic database
            $servername = "localhost";
            $username = "root";
            $password = ""; 
            $database = "dentalclinic"; 
            $conn = new mysqli($servername, $username, $password, $database);

            // Check connection
            if ($conn->connect_error) {
                die("Connection failed: " . $conn->connect_error);
            }

            // (3) Execute query to show records of the patient table
            $appointmentQuery = "SELECT * FROM appointment";
            $appointmentResult = $conn->query($appointmentQuery);

            if ($appointmentResult->num_rows > 0) {
                echo "<p>Total number of appointments : $appointmentResult->num_rows </p>";
                
                // Create a table with appropriate classes for styling
                echo '<div class="table-container">';
                echo '<table>';
                echo '<thead>';
                echo '<tr>';
                echo '<th>Appointment ID</th>';
                echo '<th>Patient ID</th>';
                echo '<th>Service code</th>';
                echo '<th>Dentist ID</th>';
                echo '<th>Appointment Date</th>';
                echo '<th>Appointment time</th>';
                echo '<th>Appointment status</th>';
                echo '<th>Dentist report</th>';
                echo '<th>Prescription</th>';
                echo '<th>Patient feedback</th>';
                echo '</tr>';
                echo '</thead>';
                
                // Create table rows from the fetched data
                echo '<tbody>';
                while ($row = $appointmentResult->fetch_assoc()) {
                    echo '<tr>';
                    echo '<td>' . htmlspecialchars($row["AppointmentID"]) . '</td>';
                    echo '<td>' . htmlspecialchars($row["PatientID"]) . '</td>';
                    echo '<td>' . htmlspecialchars($row["ServiceCode"]) . '</td>';
                    echo '<td>' . htmlspecialchars($row["DentistID"]) . '</td>';
                    echo '<td>' . htmlspecialchars($row["AppointmentDate"]) . '</td>';
                    echo '<td>' . htmlspecialchars($row["AppointmentTime"]) . '</td>';
                    echo '<td>' . htmlspecialchars($row["AppointmentStatus"]) . '</td>';
                    echo '<td>' . htmlspecialchars($row["DentistReport"]) . '</td>';
                    echo '<td>' . htmlspecialchars($row["Prescription"]) . '</td>';
                    echo '<td>' . htmlspecialchars($row["PatientFeedback"]) . '</td>';
                    echo '</tr>';
                }
                echo '</tbody>';
                
                echo '</table>';
                echo '</div>';
            } else {
                echo "<p>No appointment records found.</p>";
            }

            // Close the database connection
            $conn->close();
            ?>
        </div>
    </div>
</body>
</html>
