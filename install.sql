CREATE TABLE IF NOT EXISTS `linden_inventory` (
    `owner` VARCHAR(60) NOT NULL DEFAULT '' COLLATE 'utf8mb4_unicode_ci',
    `name` VARCHAR(100) NOT NULL DEFAULT '' COLLATE 'utf8mb4_unicode_ci', 
    `data` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    `lastupdated` TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    UNIQUE INDEX (`name`, `owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

	
REPLACE INTO `licenses` (`type`, `label`) VALUES
	('weapon', "Weapons license");


CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `weight` int(11) NOT NULL DEFAULT 1,
  `can_remove` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;	

ALTER TABLE `items`
	ADD IF NOT EXISTS `stackable` TINYINT(1) NULL DEFAULT '1', 
	ADD IF NOT EXISTS `closeonuse` TINYINT(1) NULL DEFAULT '1', 
	ADD IF NOT EXISTS `description` VARCHAR(50) NULL DEFAULT NULL,
	ADD PRIMARY KEY IF NOT EXISTS (`name`);
