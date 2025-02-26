<?php
include('config.php');
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $uid = $_POST["uid"];
    $token = $_POST["fcm_token"];

    // Insert or update FCM token
    $query = "INSERT INTO fcm_token (uid, token) VALUES ('$uid', '$token') ON DUPLICATE KEY UPDATE token='$token'";
    
    if ($conn->query($query) === TRUE) {
        echo "Token stored successfully";
    } else {
        echo "Error: " . $conn->error;
    }
}
$conn->close();
?>