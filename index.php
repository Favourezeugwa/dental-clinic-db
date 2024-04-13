<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dental Clinic</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>My Dental Clinic</h1>
    <?php
    // (1) Make a connection to mydentalclinic database
    $servername = "localhost";
    $username = "root";
    $password = ""; 
    $database = "dentalclinic"; 
    $conn = new mysqli($servername, $username, $password, $database);

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    echo "<p>Connected successfully</p>";

    // (3) Execute query to show records of the patient table
    $patientQuery = "SELECT * FROM patient"; 
    $patientResult = $conn->query($patientQuery);
    if ($patientResult->num_rows > 0) {
        echo "<h3>Display information of patient</h3>";
        echo "</h3>($patientResult->num_rows items) returned</h3>";
        echo "<table>";
        echo "<tr><th>Patient ID</th><th>First Name</th><th>Last Name</th><th>Date of Birth</th><th>Gender</th><th>Phone Number</th><th>Email</th><th>Address</th><th>City</th><th>Zip code</th></tr>";
        while($row = $patientResult->fetch_assoc()) {
            echo "<tr>";
            echo "<td>".$row["PatientID"]."</td>";
            echo "<td>".$row["FirstName"]."</td>";
            echo "<td>".$row["LastName"]."</td>";
            echo "<td>".$row["DOB"]."</td>";
            echo "<td>".$row["Gender"]."</td>";
            echo "<td>".$row["Email"]."</td>";
            echo "<td>".$row["PhoneNumber"]."</td>";
            echo "<td>".$row["Address"]."</td>";
            echo "<td>".$row["City"]."</td>";
            echo "<td>".$row["ZipCode"]."</td>";
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "0 results";
    }

    $conn->close();
    ?>

</body>
</html>
