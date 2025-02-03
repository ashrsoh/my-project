<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

include("connect.php");

if (isset($_GET['userId'])) {
    $userId = mysqli_real_escape_string($con, $_GET['userId']);

    $sql = "SELECT * FROM items WHERE userId = '$userId'";
    $result = mysqli_query($con, $sql);

    if ($result) {
        $data = [];
        while ($row = mysqli_fetch_assoc($result)) {
            $data[] = $row;
        }
        echo json_encode(["status" => "done", "data" => $data]);
    } else {
        echo json_encode(["status" => "error", "message" => mysqli_error($con)]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Missing userId"]);
}
?>
