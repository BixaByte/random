<?php session_start();
	$logout = $_GET['id'];
	if($logout=="logout"){
		
		session_destroy();
		header("location:login.php");
		exit;
	}
	

?>