<?php
    include('config.php');
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $id=$_POST['id'];
        $current=$_POST["current"];
        $new=$_POST["new"];
        $sql="SELECT * FROM users WHERE id=(?)";
        $stmt = $conn->prepare($sql);
    
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result=$stmt->get_result();
        $row = $result->fetch_assoc();
        if($row["password"]==$current){
            
            $sql2="UPDATE users SET password=(?) WHERE id=(?)";
            $stmt2 = $conn->prepare($sql2);
            $stmt2->bind_param("si", $new,$id);
            if ($stmt2->execute()) {
                echo json_encode(["message"=>"Successfull"]);
            } else {
                echo "Error updating record: " . $stmt2->error;
            }
        }
        else{
            echo json_encode(["message"=>"Current Password Wrong"]);
        }

    }
    $stmt->close();
    $conn->close();
?>