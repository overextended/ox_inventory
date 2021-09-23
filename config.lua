ox = {server = IsDuplicityVersion(), name = GetCurrentResourceName()}
Config = {}
Config.Locale = 'en'

Config.DefaultWeight = ESX.GetConfig().MaxWeight

-- Number of slots in the player inventory
Config.PlayerSlots = 50

-- If vehicle plates are stored with a trailing space, set to false (i.e. `XXX 000 `)
Config.TrimPlate = true

-- Restrict the purchase of firearms with a license
Config.Licenses = {
	['weapon'] = 5000
}

if ox.server then
	-- Check the latest available version
	Config.CheckVersion = false

	-- When should unused inventories be wiped
	Config.DBCleanup = '6 MONTH'

	-- Enable integrated logging
	Config.Logs = false

	-- Adds some random item spawns into unowned inventories
	Config.RandomLoot = true

	if Config.RandomLoot then
		-- Minimum chance to generate an item
		Config.LootChance = 100

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
else
	-- Set the keybinds for primary, secondary, and hotbar
	Config.Keys = {'F2', 'K', 'TAB'}

	-- Blur the screen while the inventory is open
	Config.EnableBlur = true

	-- Reload empty weapons automatically
	Config.AutoReload = false

	-- Adds compatibility for qtarget (https://github.com/QuantusRP/qtarget)
	Config.qtarget = false

	-- Dumpster models
	Config.Dumpsters = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}
end