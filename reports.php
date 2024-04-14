<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reports - Dental Clinic</title>
    <link rel="stylesheet" href="styles.css" />
    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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
                    <a href="appointment.php"
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
                    <a href="reports.php"><i class="fa-solid fa-clipboard-list"></i>Reports</a>
                </li>
                <li>
                    <a href="log.php"><i class="fa-solid fa-history"></i> Logs</a>
                </li>
                <li>
                    <a href="#"><i class="fa-solid fa-cog"></i>Settings</a>
                </li>
            </ul>
        </nav>

        <!-- Main content area -->
        <div class="main-content">
            <h1>Reports</h1>

            <!-- Table for business questions -->
            <table class="reports-table">
                <tr>
                    <th>Business Questions</th>
                    <th>Action</th>
                </tr>
                <tr>
                    <td>Patients with the Most Visits</td>
                    <td><button class="view-report" data-topic="patient_most_visits">View</button></td>
                </tr>
                <tr>
                    <td>Highest Paying Customers</td>
                    <td><button class="view-report" data-topic="highest_paying_customers">View</button></td>
                </tr>
                <tr>
                    <td>Most Visited Dentist</td>
                    <td><button class="view-report" data-topic="most_visited_dentist">View</button></td>
                </tr>
                <tr>
                    <td>Most and Least Requested Services</td>
                    <td><button class="view-report" data-topic="most_requested_services">View</button></td>
                </tr>
                <tr>
                    <td>Most Cancelled Appointments</td>
                    <td><button class="view-report" data-topic="most_cancelled_appointments">View</button></td>
                </tr>
                <tr>
                    <td>Patient Age Distribution</td>
                    <td><button class="view-report" data-topic="patient_age_distribution">View</button></td>
                </tr>
                <tr>
                    <td>Dentist with Most Positive Feedbacks</td>
                    <td><button class="view-report" data-topic="dentist_positive_feedbacks">View</button></td>
                </tr>
                <tr>
                    <td>Dentist with Most Negative Feedbacks</td>
                    <td><button class="view-report" data-topic="dentist_negative_feedbacks">View</button></td>
                </tr>
                <!-- Add more rows for other business questions -->
            </table>

            <div class="blur-overlay" id="blur-overlay"></div>

            <!-- Modal for displaying report content -->
            <div id="report-modal" class="modal">
                <div class="modal-content">
                    <span class="close-modal" onclick="closeModal()">×</span>
                    <div id="report-content"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for handling AJAX requests and modal -->
    <script>
        // Function to handle the click event on a "view" button
        function handleViewReportClick(event) {
            const button = event.target;
            const topic = button.getAttribute("data-topic");

            // Make an AJAX POST request to get_report_content.php
            fetch("get_report_content.php", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                },
                body: `topic=${topic}`,
            })
            .then((response) => response.text()) // Parse the response as text
            .then((data) => {
                // Display the response data in the modal
                const reportContent = document.getElementById("report-content");
                reportContent.innerHTML = data;
                
                // Show the modal
                const modal = document.getElementById("report-modal");
                modal.style.display = "block";
                
                // Add blur effect to the 
                const blurOverlay = document.getElementById("blur-overlay");
                blurOverlay.style.display = "block";
            })
            .catch((error) => {
                console.error("Error fetching report content:", error);
            });
        }

        // Function to close the modal and remove the blur effect
        function closeModal() {
            const modal = document.getElementById("report-modal");
            if (modal) {
                modal.style.display = "none";
            }
            // Hide the blur overlay
            const blurOverlay = document.getElementById("blur-overlay");
            blurOverlay.style.display = "none";
        }

        // Attach event listeners to view buttons
        document.querySelectorAll(".view-report").forEach((button) => {
            button.addEventListener("click", handleViewReportClick);
        });
    </script>
</body>

</html>
