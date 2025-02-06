<?php
    include('config.php');
    if($_SERVER["REQUEST_METHOD"]=="POST"){
        $id=$_POST["id"];
        $bid=$_POST["bid"];
        $sqlcheck="SELECT available FROM bookinfo WHERE bid=(?)";
        $stmt2 =$conn->prepare($sqlcheck);
        $stmt2->bind_param("i",$bid);
        $stmt2->execute();
        $result = $stmt2->get_result();
        $bookavailable = $result->fetch_assoc();
        $sqlcheck2="SELECT * FROM reservation WHERE bid=(?) AND uid=(?)";
        $stmt4 =$conn->prepare($sqlcheck2);
        $stmt4->bind_param("ii",$bid,$id);
        $stmt4->execute();
        $result2 = $stmt4->get_result();
        $isalreadyreserved = $result2->fetch_assoc();
        if($isalreadyreserved){
            echo json_encode(["message"=>"YOU RESERVED"]);
        }
        elseif($bookavailable["available"]=="YES"){
            $currentDateTime = date('Y-m-d H:i:s');
            $datetimeAfterTwoDays = date('Y-m-d H:i:s', strtotime('+2 days'));
            $sql="INSERT INTO reservation (uid,bid,rdt,edt) VALUES(?,?,?,?)";
            $stmt =$conn->prepare($sql);
            $stmt->bind_param("iiss",$id,$bid,$currentDateTime,$datetimeAfterTwoDays);
            if($stmt->execute()){
                
                echo json_encode(["message"=>"Successfull"]);
                $sqlno="UPDATE bookinfo SET available='NO' WHERE bid=(?)";
                $stmt3 =$conn->prepare($sqlno);
                $stmt3->bind_param("i",$bid);
                $stmt3->execute();
                $stmt3->close();
            }
            else{
                echo json_encode(["message"=>"Unsucessfull"]);
            }
            $stmt->close();
        }elseif($bookavailable["available"]=="NO"){
            echo json_encode(["message"=>"NOT AVAILABLE"]);
        }
    }
    
    $stmt2->close();
    
    $conn->close();
?>