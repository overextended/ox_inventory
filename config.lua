Keybind = {
	Primary = 'F2',
	Secondary = 'K',
	Hotbar = 'TAB'
}

Config = {}
Config.Locale = 'en'

Config.Resource = GetCurrentResourceName()

-- Compare the version of this resource to the latest (default: every 60 minutes)
Config.CheckVersion = true
Config.CheckVersionDelay = 60

-- Time until unused inventory data is wiped
Config.DBCleanup = '6 MONTH'

-- Number of inventory slots
Config.PlayerSlots = 50

-- If vehicle plates are stored with a trailing space, set to false (i.e. `XXX 000 `)
Config.TrimPlate = true

-- Blur the screen while in an inventory
Config.EnableBlur = true

-- Requires esx_licenses
Config.WeaponsLicense = true
Config.WeaponsLicensePrice = 5000

-- Set to true to enable integrated logging (extra configuration in server/logs)
Config.Logs = false

-- Reload empty weapons automatically
Config.AutoReload = false

-- Randomise the price of items in each shop at resource start
Config.RandomPrices = false

-- If you use bt-target and want to make use of bt-target on the shops enable this (requires fork at https://github.com/OfficialNoms/bt-target)
Config.bt_target = false