-- Run this if using ESX to setup columns for vehicle stashes
ALTER TABLE `owned_vehicles`
	ADD COLUMN `trunk` LONGTEXT NULL,
	ADD COLUMN `glovebox` LONGTEXT NULL;

-- Run this if using QBCore to setup columns for vehicle stashes
ALTER TABLE `player_vehicles`
	ADD COLUMN `trunk` LONGTEXT NULL,
	ADD COLUMN `glovebox` LONGTEXT NULL;