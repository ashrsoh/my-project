<?php 
error_reporting(E_ALL);
ini_set('display_errors', 1);

include("connect.php");

// تحقق من إرسال البيانات
if(isset($_POST['name']) && isset($_POST['email']) && isset($_POST['password']) && isset($_POST['note'])) {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $note = $_POST['note'];

    // طباعة القيم للتحقق
    echo "Name: $name<br>";
    echo "Email: $email<br>";
    echo "Password: $password<br>";
    echo "Note: $note<br>";

    // استعلام لإدخال البيانات في قاعدة البيانات
    $sql = "INSERT INTO user (name, email, password, note) VALUES ('$name', '$email', '$password', '$note')";
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
