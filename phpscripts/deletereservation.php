<?php
include('config.php');
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $rid = $_POST['rid'];
    $bid = $_POST['bid'];
    $sql = "DELETE FROM reservation WHERE rid=(?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $rid);
    
        
    
    if($stmt->execute()){
        $sqlupdate="UPDATE bookinfo SET available='YES' WHERE bid=(?)";
        $stmt2= $conn->prepare($sqlupdate);
        $stmt2->bind_param("i",$bid);
        $stmt2->execute();
        $stmt2->close();
        echo json_encode(["message"=>"Successfull"]);
    }else{
        echo json_encode(["message"=>"Unsuccessfull"]);
    }
}
// Close the connection
$stmt->close();
$conn->close();
?>