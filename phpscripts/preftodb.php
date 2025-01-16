
<?php
header('Content-Type: application/json');
//echo "hiii";
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "librarynew"; // Change to your DB name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = (int)$_POST['id'];
    $categories = json_decode($_POST['category']);
    $sqldelete="DELETE FROM preferences WHERE uid=(?)";
    $stmt2 =$conn->prepare($sqldelete);
    $stmt2->bind_param("i",$id);
    $stmt2->execute();

    $sql = "INSERT INTO preferences (uid,prefs) VALUES (?,?)";
    $stmt =$conn->prepare($sql);
    $sql2 = "UPDATE users SET isprefset=1 WHERE id='$id'";
    $conn->query($sql2);
    foreach($categories as $category){
        $stmt->bind_param("is",$id,$category);
        $stmt->execute();
    }
}
$stmt->close();
$stmt2->close();
$conn->close();
?>