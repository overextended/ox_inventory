-- Update for 1.5.2
ALTER TABLE `linden_inventory`
	DROP COLUMN `id`;


-- Update for 1.5.0
ALTER TABLE `linden_inventory`
    ADD COLUMN `lastupdated` TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP();
    
