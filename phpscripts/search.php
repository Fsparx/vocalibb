<?php
header('Content-Type: application/json');
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "librarynew";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $book = $_POST['search'];
    $sql = "SELECT * FROM bookinfo WHERE LOWER(bookinfo.title) LIKE LOWER(?) LIMIT 5;";
    $stmt = $conn->prepare($sql);
    $searchTerm = "%$book%";
    $stmt->bind_param("s", $searchTerm);

    // Execute the query
    $stmt->execute();
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        // Initialize an array to store book information
        $books = [];
        
        // Fetch each row as an associative array
        while ($row = $result->fetch_assoc()) {
            $books[] = $row;
        }
    
        // Return the book information as JSON
        echo json_encode($books);
    } else {
        // Return an empty array if no books are found
        echo json_encode([]);
    }
}
 else {
    // Handle invalid request method
    echo json_encode(['error' => 'Invalid request method']);
    http_response_code(405);
}

// Close the connection
$conn->close();
?>