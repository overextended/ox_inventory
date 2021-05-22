ALTER TABLE `linden_inventory`
    ADD COLUMN `lastupdated` TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP();
    
