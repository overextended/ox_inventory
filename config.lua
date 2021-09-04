Config = {}
Config.Locale = 'en'

if ox.server then
	Config.DefaultWeight = ESX.GetConfig().MaxWeight

	-- Number of slots in the player inventory
	Config.PlayerSlots = 50
	
	-- Check the latest available version
	Config.CheckVersion = false

	-- When should unused inventories be wiped
	Config.DBCleanup = '6 MONTH'
	
	-- Enable integrated logging
	Config.Logs = false

else
	-- Set the keybinds for primary, secondary, and hotbar
	Config.Keys = {'F2', 'K', 'TAB'}

	-- Blur the screen while the inventory is open
	Config.EnableBlur = true

	-- Reload empty weapons automatically
	Config.AutoReload = false

	-- Adds compatibility for qtarget (https://github.com/QuantusRP/qtarget)
	Config.qtarget = false

end

-- If vehicle plates are stored with a trailing space, set to false (i.e. `XXX 000 `)
Config.TrimPlate = true

-- Restrict the purchase of firearms with a license
Config.WeaponsLicense = true
Config.WeaponsLicensePrice = 5000
