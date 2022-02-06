CREATE TABLE `ox_inventory` (
	`owner` varchar(60) DEFAULT NULL,
	`name` varchar(100) NOT NULL,
	`data` longtext DEFAULT NULL,
	`lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	UNIQUE KEY `owner` (`owner`,`name`)
);
