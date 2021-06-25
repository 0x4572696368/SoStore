<?php
require_once 'insert.php';

$id = insertProduct($_POST["name"], $_POST["description"], $_POST["price"], $_POST["stock"]);

$cn = count($_FILES['file']['name']);
for($i=0;$i<$cn;$i++){
  $filename = $_FILES['file']['name'][$i];
  echo $filename;
  move_uploaded_file($_FILES['file']['tmp_name'][$i],'upload/'.$filename);
  insertImage($id, $filename);
}

echo $_POST["name"]." - ";
echo $_POST["price"]." - ";
echo $_POST["stock"]." - ";
echo $_POST["description"]." - ";


?>