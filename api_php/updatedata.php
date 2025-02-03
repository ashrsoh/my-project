<?php 
error_reporting(E_ALL);
ini_set('display_errors', 1);

include("connect.php");

if(isset($_POST['id']) && isset($_POST['name']) && isset($_POST['email'])) {
    $id = $_POST['id'];
    $name = $_POST['name'];
    $email = $_POST['email'];

    // تأكد من استخدام استعلام مع حماية ضد الحقن
    $stmt = $con->prepare("UPDATE user SET name = ?, email = ? WHERE id = ?");
    $stmt->bind_param("ssi", $name, $email, $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "done"]);
    } else {
        echo json_encode(["status" => "error", "message" => $stmt->error]);
        error_log("Database error: " . $stmt->error); // Log the error
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Missing required fields."]);
    error_log("Missing required fields: " . json_encode($_POST)); // Log the missing fields
}
?>
