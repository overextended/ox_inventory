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

setContainerProperties('wallet', {
	slots = 12,
	maxWeight = 3000,
	whitelist = { 'id_card','driver_license', 'drive_a', 'drive_b', 'drive_c', 'weaponlicense', 'fishinglicense', 'huntinglicense', 'lawyerpass','bank_card','security_card_01','security_card_02','money','scard_fleeca','casino_member','casino_vip', 'gym_membership' }
})

setContainerProperties('briefcase', {
	slots = 10,
	maxWeight = 7500,
	whitelist = { 'money','certificate','cwnote','cwnotepad','rentalpapers','printerdocument','laptop','keeptablet', 'filled_evidence_bag', 'empty_evidence_bag', 'recoveredbullet', 'bulletcasings' }	
})

setContainerProperties('keyring', {
	slots = 20,
	maxWeight = 7500,
	whitelist = { 'vehiclekeys' }	
})

setContainerProperties('box_small', {
	slots = 5,
	maxWeight = 7500,
})

setContainerProperties('giftbox_red', {
	slots = 5,
	maxWeight = 3000,
})

setContainerProperties('giftbox_white', {
	slots = 5,
	maxWeight = 3000,
})

setContainerProperties('lscardbook_black', {
	slots = 90,
	maxWeight = 1000,
	whitelist = { 'lstradingcard' }
})

setContainerProperties('lscardbook_blue', {
	slots = 90,
	maxWeight = 1000,
	whitelist = { 'lstradingcard' }
})

setContainerProperties('lscardbook_green', {
	slots = 90,
	maxWeight = 1000,
	whitelist = { 'lstradingcard' }
})

setContainerProperties('lscardbook_yellow', {
	slots = 90,
	maxWeight = 1000,
	whitelist = { 'lstradingcard' }
})

setContainerProperties('paperbag', {
	slots = 5,
	maxWeight = 1000,
	blacklist = { 'testburger' }
})

setContainerProperties('pizzabox', {
	slots = 5,
	maxWeight = 1000,
	whitelist = { 'pizza' }
})

setContainerProperties('ammocase', {
	slots = 10,
	maxWeight = 15000,
	whitelist = { 'ammo-9', 'ammo-45', 'ammo-22', 'ammo-38', 'ammo-44', 'ammo-50', 'ammo-rifle', 'ammo-rifle2', 'ammo-shotgun', 'ammo-sniper' }
})


return containers
