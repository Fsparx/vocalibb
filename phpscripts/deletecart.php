<?php
include('config.php');
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $cid = $_POST['cid'];
    $sql = "DELETE FROM cart WHERE cid=(?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $cid);
    if($stmt->execute()){
        echo json_encode(["message"=>"Successfull"]);
    }else{
        echo json_encode(["message"=>"Unsuccessfull"]);
    }
}

// Close the connection
$stmt->close();
$conn->close();
?>