<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

include("connect.php"); 
if (isset($_POST['id'])) {
    $id = $_POST['id'];
    $sql = "DELETE FROM items WHERE id='$id'";

    if (mysqli_query($con, $sql)) {
        echo json_encode(["status" => "done"]);
    } else {
        echo json_encode(["status" => "error", "message" => mysqli_error($con)]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Missing items ID"]);
}
?>
