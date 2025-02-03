<?php 
$host="localhost";
$user="root";
$pass="";
$dbname="data_api_flutter";
$con=mysqli_connect($host,$user,$pass,$dbname);
if(!$con)
{
    die("Connection failed: " . mysqli_connect_error());
}


error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json; charset=UTF-8');

?>