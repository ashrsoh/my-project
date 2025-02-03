<?php 
error_reporting(E_ALL);
ini_set('display_errors', 1);

include("connect.php");

if(isset($_POST['id'])) {
    $id = $_POST['id'];

    $sql = "DELETE FROM user WHERE id = '$id'";
    $result = $con->query($sql);

    if ($result) {
        echo json_encode(["status" => "done"]);
    } else {
        echo json_encode(["status" => "error", "message" => $con->error]);
        error_log("Database error: " . $con->error); // Log the error
    }
} else {
    echo json_encode(["status" => "error", "message" => "Missing required fields."]);
    error_log("Missing required fields: " . json_encode($_POST)); // Log the missing fields
}
?>
