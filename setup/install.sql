CREATE TABLE `ox_inventory` (
	`owner` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
	`name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
	`data` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
	`lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Setup new columns for vehicle stashes, and actually index owner
ALTER TABLE `owned_vehicles`
	ADD COLUMN `trunk` LONGTEXT NULL,
	ADD COLUMN `glovebox` LONGTEXT NULL,
	ADD INDEX `owner` (`owner`);

ALTER TABLE `user_licenses`
	ADD INDEX `owner` (`owner`);

-- Now I'm just being too kind
ALTER TABLE `vehicles`
	ADD INDEX `category` (`category`);
