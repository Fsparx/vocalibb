<?php
header('Content-Type: application/json');
include('config.php');
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $book = $_POST['search'];
    
    $sql = "SELECT * FROM bookinfo WHERE LOWER(bookinfo.title)=LOWER(?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s",$book);

    // Execute the query
    $stmt->execute();
    $result = $stmt->get_result();
    //echo $result;
    if ($result->num_rows > 0) {
        // Initialize an array to store book information
        $books = [];
        
        // Fetch each row as an associative array
        $row = $result->fetch_assoc();
        $books[] = $row;
        
    
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