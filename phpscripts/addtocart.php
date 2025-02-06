<?php
include('config.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'];
    $bid = $_POST['bid'];
    if (!is_numeric($id) || !is_numeric($bid)) {
        echo json_encode(["message" => "Invalid input"]);
        exit();
    }
    $sql = "INSERT INTO cart (uid, bid) VALUES (?, ?)";
    $stmt = $conn->prepare($sql);
    if ($stmt) {
        $stmt->bind_param("ii", $id, $bid);

        try {
            if ($stmt->execute()) {
                echo json_encode(["message" => "Successful"]);
            }
        } catch (mysqli_sql_exception $e) {
            
            if ($e->getCode() == 1062) { // 1062 is the error code for duplicate entry in MySQL
                echo json_encode(["message" => "Duplicate", "error" => $e->getMessage()]);
            } else {
                echo json_encode(["message" => "Unsuccessful", "error" => $e->getMessage()]);
            }
        }

        $stmt->close();
    } else {
        echo json_encode(["message" => "Failed to prepare statement", "error" => $conn->error]);
    }
} else {
    echo json_encode(["message" => "Invalid request method"]);
}

$conn->close();
?>
