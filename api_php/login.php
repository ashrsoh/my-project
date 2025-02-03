<?php
// إعدادات الاتصال بقاعدة البيانات
$servername = "localhost"; // أو عنوان السيرفر الخاص بك
$username = "root";        // اسم المستخدم لقاعدة البيانات
$password = "";            // كلمة المرور لقاعدة البيانات
$dbname = "data_api_flutter"; // اسم قاعدة البيانات

// إنشاء الاتصال
$conn = new mysqli($servername, $username, $password, $dbname);

// التحقق من الاتصال
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// الحصول على البيانات المرسلة من التطبيق
$email = $_POST['email'];
$name = $_POST['name'];

// التحقق من وجود اسم المستخدم وكلمة المرور في قاعدة البيانات
$sql = "SELECT * FROM user WHERE email = ? AND name = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $email, $name);
$stmt->execute();
$result = $stmt->get_result();

// إذا تم العثور على المستخدم
if ($result->num_rows > 0) {
    // استرجاع بيانات المستخدم
    $user = $result->fetch_assoc();
    
    // إرسال الاستجابة بنجاح
    echo json_encode([
        "status" => "success",
        "message" => "Login successful",
        "user" => $user
    ]);
} else {
    // إرسال استجابة بفشل الدخول
    echo json_encode([
        "status" => "error",
        "message" => "Invalid username or password"
    ]);
}

// إغلاق الاتصال
$stmt->close();
$conn->close();
?>
