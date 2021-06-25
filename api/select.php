<?php
require_once 'conn.php';

$lastedIdp = $_GET['idp'];

function selectProducts($idp) {
    try {
        $pdo = new PDO("mysql:host=".$GLOBALS['servername'].";dbname=".$GLOBALS['dbname'], $GLOBALS['username'], $GLOBALS['password']);
        $sql = 'CALL selectProducts(:idp)';

        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':idp', $idp, PDO::PARAM_INT);
        $rs = $stmt->execute();
        $r = $stmt -> fetchAll();    
        $stmt->closeCursor();

        $arr = array();
        $latest = 0;
        for ($i=0; $i < count($r) ; $i++) { 
            $arr[] = array('idp'=>$r[$i]['idp'],'name'=>$r[$i]['name'],'description'=>$r[$i]['description'],'price'=>$r[$i]['price'],'stock'=>$r[$i]['stock'],'images'=>json_decode($r[$i]['photos']));
            $latest = $r[$i]['idp'];
        }
        $fulljson=array_merge($arr);
        $return = array('data'=>$fulljson, 'latest' => $latest);
        
        header("Content-type: application/json; charset=utf-8");
        echo json_encode ($return);
       

    } catch (PDOException $e) {
        die("Error occurred:" . $e->getMessage());
    }
    return null;
};
selectProducts($lastedIdp);
?>