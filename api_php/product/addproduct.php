<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

include("connect.php");

if (
    isset(
        $_POST['name'], 
        $_POST['quantity'], 
        $_POST['price'], 
        $_POST['date'], 
        $_POST['userId'], 
        $_POST['total_price'], 
        $_POST['note'], 
        $_POST['note1'], 
        $_POST['note2'], 
        $_POST['note3']
    )
) {
    $name = mysqli_real_escape_string($con, $_POST['name']);
    $quantity = mysqli_real_escape_string($con, $_POST['quantity']);
    $price = mysqli_real_escape_string($con, $_POST['price']);
    $date = mysqli_real_escape_string($con, $_POST['date']);
    $userId = mysqli_real_escape_string($con, $_POST['userId']);
    $total_price = mysqli_real_escape_string($con, $_POST['total_price']);
    $note = mysqli_real_escape_string($con, $_POST['note']);
    $note1 = mysqli_real_escape_string($con, $_POST['note1']);
    $note2 = mysqli_real_escape_string($con, $_POST['note2']);
    $note3 = mysqli_real_escape_string($con, $_POST['note3']);

    // تأكد من إضافة userId في قاعدة البيانات
    $sql = "INSERT INTO items (name, quantity, price, date, userId, total_price, note, note1, note2, note3) 
            VALUES ('$name', '$quantity', '$price', '$date', '$userId', '$total_price', '$note', '$note1', '$note2', '$note3')";

    if (mysqli_query($con, $sql)) {
        echo json_encode(["status" => "done"]);
    } else {
        echo json_encode(["status" => "error", "message" => mysqli_error($con)]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
}
?>
