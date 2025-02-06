<?php
include('config.php');
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'];
    $sql = "SELECT * FROM cart INNER JOIN bookinfo ON cart.bid=bookinfo.bid WHERE cart.uid=(?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $id);

    
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