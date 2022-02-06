-- Update existing linden_inventory table to new name and indexes
ALTER TABLE `linden_inventory`
	RENAME TO `ox_inventory`,
	CHANGE COLUMN `owner` `owner` VARCHAR(60) NULL FIRST,
	CHANGE COLUMN `name` `name` VARCHAR(100) NOT NULL AFTER `owner`,
	CHANGE COLUMN `data` `data` LONGTEXT NULL AFTER `name`,
	DROP INDEX `name`,
	ADD UNIQUE INDEX `owner` (`owner`, `name`);
