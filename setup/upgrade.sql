-- Update existing linden_inventory table to new name and indexes
ALTER TABLE `linden_inventory`
	RENAME TO `ox_inventory`,
	CHANGE COLUMN `owner` `owner` VARCHAR(60) NULL COLLATE 'utf8mb4_unicode_ci' FIRST,
	CHANGE COLUMN `name` `name` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `owner`,
	CHANGE COLUMN `data` `data` LONGTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `name`,
	DROP INDEX `name`,
	ADD UNIQUE INDEX `name` (`name`),
	ADD UNIQUE INDEX `owner` (`owner`, `name`);

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