<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

include("connect.php");

if (isset($_POST['id'], $_POST['name'], $_POST['quantity'], $_POST['price'], $_POST['date'], $_POST['userId'], $_POST['total_price'], $_POST['note'], $_POST['note1'], $_POST['note2'], $_POST['note3'])) {
    $id = $_POST['id'];
    $name = $_POST['name'];
    $quantity = $_POST['quantity'];
    $price = $_POST['price'];
    $date = $_POST['date'];
    $userId = $_POST['userId'];
    $total_price = $_POST['total_price'];
    $note = $_POST['note'];
    $note1 = $_POST['note1'];
    $note2 = $_POST['note2'];
    $note3 = $_POST['note3'];

    // تحضير استعلام التحديث باستخدام prepared statements لتجنب SQL injection
    $sql = "UPDATE items SET name=?, quantity=?, price=?, date=?, userId=?, total_price=?, note=?, note1=?, note2=?, note3=? WHERE id=?";
    
    if ($stmt = mysqli_prepare($con, $sql)) {
        // ربط المعاملات مع استعلام التحضير
        mysqli_stmt_bind_param($stmt, "ssssssssssi", $name, $quantity, $price, $date, $userId, $total_price, $note, $note1, $note2, $note3, $id);

        // تنفيذ الاستعلام
        if (mysqli_stmt_execute($stmt)) {
            echo json_encode(["status" => "done"]);
        } else {
            echo json_encode(["status" => "error", "message" => mysqli_error($con)]);
        }

        // غلق البيان
        mysqli_stmt_close($stmt);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to prepare statement"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
}
?>
