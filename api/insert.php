<?php
require_once 'conn.php';
function insertProduct($name, $description, int $price, int $stock) {
    try {
        $pdo = new PDO("mysql:host=".$GLOBALS['servername'].";dbname=".$GLOBALS['dbname'], $GLOBALS['username'], $GLOBALS['password']);

        // calling stored procedure command
        $sql = 'CALL insertProducts(:name,:description,:price,:stock)';

        // prepare for execution of the stored procedure
        $stmt = $pdo->prepare($sql);

        // pass value to the command
        $stmt->bindParam(':name', $name, PDO::PARAM_STR);
        $stmt->bindParam(':description', $description, PDO::PARAM_STR);
        $stmt->bindParam(':price', $price, PDO::PARAM_INT);
        $stmt->bindParam(':stock', $stock, PDO::PARAM_INT);
        // execute the stored procedure
        $rs = $stmt->execute();
        $row = $stmt -> fetch();    
        $stmt->closeCursor();

        return  $row['last_id'];
        // $sql = 'CALL selectProducts()';
        // // call the stored procedure
        // $q = $pdo->query($sql);
        // $q->setFetchMode(PDO::FETCH_ASSOC);
        // $r = $q->fetchAll();
        // $data = json_encode($r);
        // header("Content-type: application/json; charset=utf-8");
        // echo '{"data":'.$data.',"result":'.$rs.'}';
    } catch (PDOException $e) {
        die("Error occurred:" . $e->getMessage());
    }
    return null;
};
// insertProduct("Cartera", "Mejor material peruano", 291, 45);

function insertImage($idp, $image) {
    try {
        $pdo = new PDO("mysql:host=".$GLOBALS['servername'].";dbname=".$GLOBALS['dbname'], $GLOBALS['username'], $GLOBALS['password']);
        $sql = 'CALL insertImages(:idp,:image)';
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':idp', $idp, PDO::PARAM_INT);
        $stmt->bindParam(':image', $image, PDO::PARAM_STR);
        $rs = $stmt->execute();  
        $stmt->closeCursor();
    } catch (PDOException $e) {
        die("Error occurred:" . $e->getMessage());
    }
    return null;
};

?>