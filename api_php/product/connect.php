<?php
$host = "localhost";
$user = "root";
$pass = "";
$dbname = "data_api_flutter";

// إنشاء الاتصال
$con = new mysqli($host, $user, $pass, $dbname);

// التحقق من الاتصال
if ($con->connect_error) {
    die("Connection failed: " . $con->connect_error);
}
?>
