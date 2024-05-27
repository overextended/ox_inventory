local containers = {}

---@class ItemContainerProperties
---@field slots number
---@field maxWeight number
---@field whitelist? table<string, true> | string[]
---@field blacklist? table<string, true> | string[]

local function arrayToSet(tbl)
    local size = #tbl
    local set = table.create(0, size)

    for i = 1, size do
        set[tbl[i]] = true
    end

    return set
end

---Registers items with itemName as containers (i.e. backpacks, wallets).
---@param itemName string
---@param properties ItemContainerProperties
---@todo Rework containers for flexibility, improved data structure; then export this method.
local function setContainerProperties(itemName, properties)
    local blacklist, whitelist = properties.blacklist, properties.whitelist

    if blacklist then
        local tableType = table.type(blacklist)

        if tableType == 'array' then
            blacklist = arrayToSet(blacklist)
        elseif tableType ~= 'hash' then
            TypeError('blacklist', 'table', type(blacklist))
        end
    end

    if whitelist then
        local tableType = table.type(whitelist)

        if tableType == 'array' then
            whitelist = arrayToSet(whitelist)
        elseif tableType ~= 'hash' then
            TypeError('whitelist', 'table', type(whitelist))
        end
    end

    containers[itemName] = {
        size = { properties.slots, properties.maxWeight },
        blacklist = blacklist,
        whitelist = whitelist,
    }
end
setContainerProperties('paperbag', {
    slots = 5,
    maxWeight = 10000,
    blacklist = { 'bburger', 'cola2', 'pie', 'pizza', 'water', 'weapon_pistol' }
})

setContainerProperties('pizzabox', {
    slots = 5,
    maxWeight = 10000,
    whitelist = { 'pizza' }
})

setContainerProperties('keychain', {
    slots = 12,
    maxWeight = 30000,
    whitelist = { 'carkey', 'leasekey' }
})

setContainerProperties('largebag', {
    slots = 30,
    maxWeight = 30000,
    blacklist = { 'outfit', 'fish', 'carkey', 'leasekey' }
})

setContainerProperties('icebox', {
    slots = 32,
    maxWeight = 30000,
    whitelist = { 'fish' },
})


setContainerProperties('secureweaponscase', {
    slots = 2,
    maxWeight = 100000,
    whitelist = { 'WEAPON_FM41', 'WEAPON_FM42', 'WEAPON_ASSAULTRIFLE', 'WEAPON_CARBINERIFLE', 'WEAPON_CARBINERIFLE_MK2', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_HEAVYSNIPER_MK2', 'ammo-sniper', 'ammo-rifle', 'armour', 'WEAPON_GLOCK19', 'ammo-9', 'ammo-45', 'ammo-rifle2', 'handcuffs', 'cuffkey', 'weapon_stungun' },
})

setContainerProperties('wallet', {
    slots = 32,
    maxWeight = 64000,
    whitelist = { 'identification', 'money', 'dmoney', 'document', 'lockpick', 'advancedlockpick', 'phone', 'paper', 'joint', 'card', 'bookofstamps', 'ring' },
})

setContainerProperties('cardbinder', {
    slots = 400,
    maxWeight = 120000,
    whitelist = { 'card' },
})


setContainerProperties('funkobag', {
    slots = 120,
    maxWeight = 120000,
    whitelist = { 'funkobox', 'funko' },
})

setContainerProperties('cartonofcigarettes', {
    slots = 1,
    maxWeight = 6400,
    whitelist = { 'cig', 'joint' },
})


return containers
