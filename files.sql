CREATE TABLE `hsn_inventory` (
	`name` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_turkish_ci',
	`data` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_turkish_ci'
)
COLLATE='utf8_turkish_ci'
ENGINE=InnoDB
;

ALTER TABLE `items`
	ADD `stackable` INT(11) NULL DEFAULT '1',
    ADD `closeonuse` INT(11) NULL DEFAULT '1'
;