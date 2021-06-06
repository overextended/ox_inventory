CREATE TABLE IF NOT EXISTS `linden_inventory` (
    `owner` VARCHAR(60) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
    `name` VARCHAR(100) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci', 
    `data` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    `lastupdated` TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    UNIQUE INDEX (`name`, `owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

	
REPLACE INTO `licenses` (`type`, `label`) VALUES
	('weapon', "Weapons license");
