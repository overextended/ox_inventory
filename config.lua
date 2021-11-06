ox = {server = IsDuplicityVersion(), name = GetCurrentResourceName()}
Config = {}
Config.Locale = 'en'

Config.DefaultWeight = ESX.GetConfig().MaxWeight

-- Number of slots in the player inventory
Config.PlayerSlots = 50

-- If vehicle plates are stored with a trailing space, set to false (i.e. `XXX 000 `)
Config.TrimPlate = true

-- Adds compatibility for qtarget (https://github.com/QuantusRP/qtarget)
Config.Target = false

-------------------------------------------------------------------------------------

if ox.server == false then
	-- Set the keybinds for primary, secondary, and hotbar
	Config.Keys = {'F2', 'K', 'TAB'}

	-- Blur the screen while the inventory is open
	Config.EnableBlur = true

	-- Reload empty weapons automatically
	Config.AutoReload = false

	-- Enable sentry logging (this reports UI errors and general performance statistics to the Ox team, anonymously)
	Config.Sentry = true
else
	-- Check the latest available version
	Config.CheckVersion = false

	-- When should unused inventories be wiped
	Config.DBCleanup = '6 MONTH'

	-- Enable integrated logging
	Config.Logs = true

	-- Police grade at which somoene can take items from evidence
	Config.TakeFromEvidence = 2

	-- Adds some random item spawns into unowned inventories
	Config.RandomLoot = true

	if Config.RandomLoot then
		-- Minimum chance to generate an item
		Config.LootChance = 50

		-- item, minimum, maximum
		Config.Loot = {
			{'cola', 0, 1},
			{'water', 0, 2},
			{'garbage', 0, 1},
			{'panties', 0, 1},
			{'money', 0, 100},
			{'bandage', 0, 1}
		}

		Config.DumpsterLoot = {
			{'mustard', 0, 1},
			{'garbage', 1, 3},
			{'panties', 0, 1},
			{'money', 0, 10},
			{'burger', 0, 1}
		}

	end
end