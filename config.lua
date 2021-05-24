Config = {}
Config.Locale = 'en'

-- Compare the version of this resource to the latest (default: every 60 minutes)
Config.CheckVersion = true
Config.CheckVersionDelay = 60

-- Time until unused inventory data is wiped
Config.DBCleanup = '6 MONTH'

-- Number of inventory slots
Config.PlayerSlots = 50

-- If vehicle plates are stored with a trailing space, set to false (i.e. `XXX-000 `)
Config.TrimPlate = true

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

-- Show player identifier (typically Rockstar License) on identification
Config.ShowIdentifierID = false

-- Enable random loot in dumpsters, gloveboxes, trunks
Config.RandomLoot = true
-- Percentage chance of loot generating in their respective container types
Config.TrunkLootChance = 100
Config.GloveboxLootChance = 100
Config.DumpsterLootChance = 100

Config.Trash = {
    {description = 'An old rolled up newspaper', weight = 200, image = 'trash_newspaper'}, 
    {description = 'A discarded burger shot carton', weight = 50, image = 'trash_burgershot'},
    {description = 'An empty soda can', weight = 20, image = 'trash_can'},
    {description = 'A mouldy piece of bread', weight = 70, image = 'trash_bread'},
    {description = 'An empty ciggarette carton', weight = 10, image = 'trash_fags'},
    {description = 'A slightly used pair of panties', weight = 20, image = 'panties'},
    {description = 'An empty coffee cup', weight = 20, image = 'trash_coffee'},
    {description = 'A crumpled up piece of paper', weight = 5, image = 'trash_paper'},
    {description = 'An empty chips bag', weight = 5, image = 'trash_chips'},
}