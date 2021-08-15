ALTER TABLE `ox_inventory`
	RENAME TO `ox_inventory`,
	CHANGE COLUMN `owner` `owner` VARCHAR(60) NULL COLLATE 'utf8mb4_unicode_ci' FIRST,
	CHANGE COLUMN `name` `name` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `owner`,
	CHANGE COLUMN `data` `data` LONGTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `name`,
	DROP INDEX `name`,
	ADD UNIQUE INDEX `name` (`name`),
	ADD UNIQUE INDEX `owner` (`owner`, `name`);

ALTER TABLE `owned_vehicles`
	ADD COLUMN `trunk` LONGTEXT NULL,
	ADD COLUMN `glovebox` LONGTEXT NULL,
	ADD INDEX `owner` (`owner`);

ALTER TABLE `vehicles`
	ADD INDEX `category` (`category`);