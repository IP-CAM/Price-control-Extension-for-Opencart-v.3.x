<?php
	/*
		currency_id - валюта
		pc_column - номера колонок
		markup - наценка
		stock_status - соответсвие значений состоянию на складе
	*/


	header('Content-Type: text/html; charset=UTF-8');
	error_reporting(-1);
	require_once './config.php';

	$host = DB_HOSTNAME;
	$user = DB_USERNAME;
	$pass = DB_PASSWORD;
	$dbname = DB_DATABASE;
	$pr = DB_PREFIX;

	try {
		$dbh = new PDO("mysql:host=".$host.";dbname=".$dbname, $user, $pass);
		$dbh->exec('SET NAMES utf8');
	$dbh->exec("SET SQL_MODE = ''");
		}
	catch(PDOException $e) {
		echo $e->getMessage();
	}

	$stmt = $dbh->prepare("CREATE TABLE IF NOT EXISTS  " . $pr . "price_control (
		`pc_score_id` int(11) NOT NULL AUTO_INCREMENT,
		`currency_id` int(11) NOT NULL,
		`name` varchar(32) NOT NULL,
		`url` varchar(255) NOT NULL,
		`pc_column` text(255) NOT NULL,
		`markup` text(255) NOT NULL,
		`stock_status` text(255) NOT NULL,
		PRIMARY KEY (`pc_score_id`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;");
	$stmt->execute();

	$stmt = $dbh->prepare("CREATE TABLE IF NOT EXISTS  " . $pr . "price_control_to_product (
		`price_control_id` int(11) NOT NULL AUTO_INCREMENT,
		`pc_score_id` int(11) NOT NULL,
		`product_id` int(11) NOT NULL,
		`model` varchar(32) NOT NULL,
		`name` varchar(255) NOT NULL,
		`price` decimal(15,4) NOT NULL,
		`extra_charge` int(11) NOT NULL DEFAULT 0,
		`stock_status_id` int(11) NOT NULL,
		`label` tinyint(1) NOT NULL DEFAULT 0,
		`date` date NOT NULL,
		PRIMARY KEY (`price_control_id`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;");
	$stmt->execute();
?>
