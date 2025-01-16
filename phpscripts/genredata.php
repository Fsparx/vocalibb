<?php
// Database credentials
$host = 'localhost';
$dbname = 'librarynew'; 
$username = 'root'; 
$password = ''; 
$conn = new mysqli($host, $username, $password, $dbname);


if ($conn->connect_error) {
    echo json_encode(['error' => 'Connection failed: ' . $conn->connect_error]);
    exit;
}

// SQL query to fetch all data from the library_data table
$query = "SELECT authorized_value, lib_text FROM depdata";
$result = $conn->query($query);

// Check if there are any rows returned
if ($result->num_rows > 0) {
    $data = [];
    
    // Fetch the rows and add them to the data array
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    
    // Return the data as a JSON response
    echo json_encode($data);
} else {
    echo json_encode(['error' => 'No data found in the library_data table.']);
}

// Close the database connection
$conn->close();
?>
