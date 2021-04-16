Config = {}

-- Compare the version of this resource to the latest (default: every 60 minutes)
Config.CheckVersion = true
Config.CheckVersionDelay = 60

-- Number of inventory slots
Config.PlayerSlots = 50

-- Regular carry weight, can be increased by backpacks through esx_skin
Config.PlayerWeight = 30000

-- Blur the screen while in an inventory
Config.EnableBlur = true

-- Requires esx_licenses
Config.WeaponsLicense = true
Config.WeaponsLicensePrice = 5000

-- Set the name of your logging resource, or false to disable
Config.Logs = false --'linden_logs'

-- Default keymapping for the inventory; players can assign their own
Config.InventoryKey = 'F2'
Config.VehicleInventoryKey = 'K'

-- Reload empty weapons automatically
Config.AutoReload = false

-- Randomise the price of items in each shop at resource start
Config.RandomPrices = false

-- Show player identifier (often steamhex) on their id card
Config.ShowIdentifierID = true
