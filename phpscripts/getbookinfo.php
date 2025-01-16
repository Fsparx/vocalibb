<?php
// Database credentials
$host = 'localhost';
$dbname = 'librarynew'; 
$username = 'root'; 
$password = ''; 
$conn = new mysqli($host, $username, $password, $dbname);
// ini_set('memory_limit', '512M');  // Increase memory limit if needed
// set_time_limit(0); 

if ($conn->connect_error) {
    echo json_encode(['error' => 'Connection failed: ' . $conn->connect_error]);
    exit;
}
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = (int)$_POST['id'];

    $sql="SELECT prefs  FROM preferences WHERE uid=(?)";
    $stmt =$conn->prepare($sql);
    $stmt->bind_param("i",$id);
    $stmt->execute();
    $result = $stmt->get_result();
    if($result->num_rows >0){
        $prefs=[];
        while($row= $result->fetch_assoc()){
            $sql2="SELECT lib_text FROM depdata where authorized_value=(?)";
            $stmt2 =$conn->prepare($sql2);
            $stmt2->bind_param("s",$row["prefs"]);
            $stmt2->execute();
            $result1 = $stmt2->get_result();
            $row1= $result1->fetch_assoc();
            $prefs[$row["prefs"]] = $row1["lib_text"];
        }
        
    }
    else{
        echo json_encode([]);
    }
    $groupedBooks=[];
    foreach($prefs as $code => $name){
        $sql3="SELECT * FROM bookinfo WHERE category=(?) ORDER BY RAND() LIMIT 6";
        $stmt3 =$conn->prepare($sql3);
        $stmt3->bind_param("s",$code);
        $stmt3->execute();
        $result3 = $stmt3->get_result();
        $books=[];
        while ($book = $result3->fetch_assoc()) {
            $books[] = $book;
        }
        $groupedBooks[$name] = $books;
        $stmt3->close();


    }
    echo json_encode($groupedBooks);
    // echo json_encode($groupedBooks);
    
}
$stmt->close();
$stmt2->close();
$conn->close();
?>