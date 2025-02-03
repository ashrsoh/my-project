<?php
$host = "localhost";
$user = "root";
$pass = "";
$dbname = "data_api_flutter";

$conn = mysqli_connect($host, $user, $pass, $dbname);

// التحقق من نجاح الاتصال
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}




error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");


// استعلام جلب جميع المنتجات
$query = "SELECT id, name, quantity, price, date, userId, total_price, note, note1, note2, note3 FROM items";
$result = mysqli_query($conn, $query);

// التحقق من الأخطاء في الاستعلام
if (!$result) {
    echo json_encode([
        "status" => "error",
        "message" => "Database error: " . mysqli_error($conn)
    ]);
    exit();
}

if (mysqli_num_rows($result) > 0) {
    $products = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $products[] = $row;
    }
    echo json_encode([
        "status" => "done",
        "data" => $products
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "No products found."
    ]);
}

mysqli_close($conn);
?>
