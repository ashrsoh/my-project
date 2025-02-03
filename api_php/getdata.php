<?php 
include("connect.php");
ini_set('display_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json');

$sql = "SELECT * FROM `user`";
$result = $con->query($sql);

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode(["data" => $data]);

error_log("Fetched data: " . json_encode($data)); // Log the fetched data
?>
