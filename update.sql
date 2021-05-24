-- Update for 1.5.3
ALTER TABLE `linden_inventory`
	CHANGE COLUMN `owner` `owner` VARCHAR(60) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci' FIRST,
	CHANGE COLUMN `name` `name` VARCHAR(100) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci' AFTER `owner`;


-- Update for 1.5.2
ALTER TABLE `linden_inventory`
	DROP COLUMN `id`;


-- Update for 1.5.0
ALTER TABLE `linden_inventory`
	ADD COLUMN `lastupdated` TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP();
    
