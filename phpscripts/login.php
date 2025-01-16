
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
    // Get input from Flutter app
    $input_username = $_POST['username'];
    $input_password = $_POST['password'];
    
    // Prepare SQL query to find the user
    $sql = "SELECT * FROM users WHERE regno = '$input_username'";
    $result = $conn->query($sql);
    
    
    if ($result->num_rows > 0) {
        // User found
        $user = $result->fetch_assoc();
        $name= $user["firstname"];
        $id=$user["id"];
        $pref=$user["isprefset"];
        if ($input_password==$user['password']) {
            
            echo json_encode(["status" => "success", "message" => "Login successful","name" => $name,"id"=> $id,"isprefset"=>$pref]);
        } else {
            echo json_encode(["status" => "error", "message" => "Invalid password"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "User not found"]);
    }
}

$conn->close();
?>