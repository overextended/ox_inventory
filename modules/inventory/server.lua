if not lib then return end

local Inventory = {}
local Inventories = {}
local Vehicles = data 'vehicles'
local Stashes = data 'stashes'
local GetVehicleNumberPlateText = GetVehicleNumberPlateText

local function loadInventoryData(data, player)
	local source = source
	local inventory

	if not data.type and type(data.id) == 'string' then
		if data.id:find('^glove') then
			data.type = 'glovebox'
		elseif data.id:find('^trunk') then
			data.type = 'trunk'
		elseif data.id:find('^evidence-') then
			data.type = 'policeevidence'
		end
	end

	if data.type == 'trunk' or data.type == 'glovebox' then
		inventory = Inventories[data.id]

		if not inventory then
			local entity

			if data.netid then
				entity = NetworkGetEntityFromNetworkId(data.netid)

				if not entity then
					return shared.info('Failed to load vehicle inventory data (no entity exists with given netid).')
				end
			else
				local vehicles = GetAllVehicles()

				for i = 1, #vehicles do
					local vehicle = vehicles[i]
					local plate = GetVehicleNumberPlateText(vehicle)

					if data.id:find(plate) then
						entity = vehicle
						break
					end
				end

				if not entity then
					return shared.info('Failed to load vehicle inventory data (no entity exists with given plate).')
				end
			end

			if not source then
				source = NetworkGetEntityOwner(entity)

				if not source then
					return shared.info('Failed to load vehicle inventory data (entity is unowned).')
				end
			end

			local model, class = lib.callback.await('ox_inventory:getVehicleData', source, data.netid)
			local storage = Vehicles[data.type].models[model] or Vehicles[data.type][class]
			local plate = server.trimplate and string.strtrim(data.id:sub(6)) or data.id:sub(6)

			if Ox then
				local vehicle = Ox.GetVehicle(entity)

				if vehicle then
					inventory = Inventory.Create(vehicle.id or vehicle.plate, plate, data.type, storage[1], 0, storage[2], false)
				end
			end

			if not inventory then
				inventory = Inventory.Create(data.id, plate, data.type, storage[1], 0, storage[2], false)
			end
		end
	elseif data.type == 'policeevidence' then
		inventory = Inventory.Create(data.id, locale('police_evidence'), data.type, 100, 0, 100000, false)
	else
		local stash = Stashes[data.id] or Inventory.CustomStash[data.id]

		if stash then
			if stash.jobs then stash.groups = stash.jobs end
			if player and stash.groups and not server.hasGroup(player, stash.groups) then return end

			local owner

			if stash.owner then
				if stash.owner == true then
					owner = data.owner or player?.owner
				else
					owner = stash.owner
				end
			end

			inventory = Inventories[owner and ('%s:%s'):format(stash.name, owner) or stash.name]

			if not inventory then
				inventory = Inventory.Create(stash.name, stash.label or stash.name, 'stash', stash.slots, 0, stash.weight, owner, nil, stash.groups)
			end
		end
	end

	return inventory or false
end

setmetatable(Inventory, {
	__call = function(self, inv, player)
		if not inv then
			return self
		elseif type(inv) == 'table' then
			return inv.items and inv or loadInventoryData(inv, player)
		end

		return Inventories[inv] or loadInventoryData({ id = inv }, player)
	end
})

---@param inv string | number | table
---@param owner? string | number
---@return table?
local function getInventory(inv, owner)
	if not inv then return Inventory end
	local type = type(inv)

	if type == 'table' or type == 'number' then
		return Inventory(inv)
	else
		return Inventory({ id = inv, owner = owner })
	end
end

exports('Inventory', getInventory)
exports('GetInventory', getInventory)

---@param inv string | number | table
---@param owner? string | number
---@return table?
exports('GetInventoryItems', function(inv, owner)
	return getInventory(inv, owner)?.items
end)

---@param inv table | string | number
---@param k string
---@param v any
function Inventory.Set(inv, k, v)
	inv = Inventory(inv)
	if inv then
		if type(v) == 'number' then math.floor(v + 0.5) end

		if k == 'open' and v == false then
			if inv.type ~= 'player' then
				if inv.player then
					inv.type = 'player'
				elseif inv.type == 'drop' and not next(inv.items) then
					return Inventory.Remove(inv)
				else
					inv.time = os.time()
				end
			end

			if inv.player then
				inv.containerSlot = nil
			end
		elseif k == 'maxWeight' and v < 1000 then
			v *= 1000
		end

		inv[k] = v
	end
end

---@param inv table | string | number
---@param key string
function Inventory.Get(inv, key)
	inv = Inventory(inv)
	if inv then
		return inv[key]
	end
end

---@param inv table | string | number
---@return table items table containing minimal inventory data
local function minimal(inv)
	inv = Inventory(inv)
	local inventory, count = {}, 0
	for k, v in pairs(inv.items) do
		if v.name and v.count > 0 then
			count += 1
			inventory[count] = {
				name = v.name,
				count = v.count,
				slot = k,
				metadata = next(v.metadata) and v.metadata or nil
			}
		end
	end
	return inventory
end

---@param inv table | string | number
---@param item table
---@param count number
---@param metadata any
---@param slot any
function Inventory.SetSlot(inv, item, count, metadata, slot)
	inv = Inventory(inv)
	local currentSlot = inv.items[slot]
	local newCount = currentSlot and currentSlot.count + count or count
	local newWeight = currentSlot and inv.weight - currentSlot.weight or inv.weight

	if currentSlot and newCount < 1 then
		currentSlot = nil
	else
		currentSlot = {name = item.name, label = item.label, weight = item.weight, slot = slot, count = newCount, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
		local slotWeight = Inventory.SlotWeight(item, currentSlot)
		currentSlot.weight = slotWeight
		newWeight += slotWeight
	end

	inv.weight = newWeight
	inv.items[slot] = currentSlot
	inv.changed = true

	return currentSlot
end

local Items

CreateThread(function()
	TriggerEvent('ox_inventory:loadInventory', Inventory)
	Items = server.items

	-- Require "set inventory:weaponmismatch 1" to enable experimental weapon checks.
	-- Maybe need some tweaks, and will definitely need more hashes added to the ignore list.
	-- May even use weaponDamageEvent, depending on performance..
	if GetConvarInt('inventory:weaponmismatch', 0) == 0 then return end

	local ignore = {
		[0] = 1, -- GetSelectedPedWeapon returns 0 when using a firetruk; likely some other cases
		[966099553] = 1, -- I don't know
		[`WEAPON_UNARMED`] = 1,
		[`WEAPON_ANIMAL`] = 1,
		[`WEAPON_COUGAR`] = 1,
	}

	while true do
		Wait(30000)

		for id, inv in pairs(Inventories) do
			if inv.player then
				local hash = GetSelectedPedWeapon(inv.player.ped)

				if not ignore[hash] then
					local currentWeapon = inv.items[inv.weapon]?.name

					if currentWeapon then
						local currentHash = Items(currentWeapon).hash

						if currentHash ~= hash then
							inv.weapon = nil
							print(('Player.%s weapon mismatch (%s). Current weapon: %s (%s)'):format(id, hash, currentWeapon, currentHash))
						end
					else
						print(('Player.%s weapon mismatch (%s)'):format(id, hash, currentWeapon))
					end

					if not inv.weapon then
						TriggerClientEvent('ox_inventory:disarm', id)
					end
				end
			end
		end
	end
end)

---@param item table
---@param slot table
function Inventory.SlotWeight(item, slot)
	local weight = item.weight * slot.count
	if not slot.metadata then slot.metadata = {} end

	if item.ammoname and slot.metadata.ammo then
		local ammoWeight = Items(item.ammoname)?.weight

		if ammoWeight then
			weight += (ammoWeight * slot.metadata.ammo)
		end
	end

	if slot.metadata.components then
		for i = #slot.metadata.components, 1, -1 do
			local componentWeight = Items(slot.metadata.components[i])?.weight

			if componentWeight then
				weight += componentWeight
			end
		end
	end

	if slot.metadata.weight then
		weight += (slot.metadata.weight * slot.count)
	end

	return weight
end

---@param items table
function Inventory.CalculateWeight(items)
	local weight = 0
	for _, v in pairs(items) do
		local item = Items(v.name)
		if item then
			weight = weight + Inventory.SlotWeight(item, v)
		end
	end
	return weight
end

-- This should be handled by frameworks, but sometimes isn't or is exploitable in some way.
local activeIdentifiers = {}

---@param id string|number
---@param label string|nil
---@param invType string
---@param slots number
---@param weight number
---@param maxWeight number
---@param owner string | number | boolean
---@param items? table
--- This should only be utilised internally!
--- To create a stash, please use `exports.ox_inventory:RegisterStash` instead.
function Inventory.Create(id, label, invType, slots, weight, maxWeight, owner, items, groups)
	if invType == 'player' then
		if activeIdentifiers[owner] then
			DropPlayer(tostring(id), ("Character identifier '%s' is already active."):format(owner))
		end

		activeIdentifiers[owner] = 1
	end

	local self = {
		id = id,
		label = label or id,
		type = invType,
		slots = slots,
		weight = weight,
		maxWeight = maxWeight or shared.playerweight,
		owner = owner,
		items = type(items) == 'table' and items,
		open = false,
		set = Inventory.Set,
		get = Inventory.Get,
		minimal = minimal,
		time = os.time(),
		groups = groups,
	}

	if invType == 'drop' then
		self.datastore = true
	else
		self.changed = false

		if invType ~= 'glovebox' and invType ~= 'trunk' then
			self.dbId = id

			if invType ~= 'player' and owner and type(owner) ~= 'boolean' then
				self.id = ('%s:%s'):format(self.id, owner)
			end
		else
			if Ox then
				self.dbId = id
				self.id = (invType == 'glovebox' and 'glove' or invType)..label
			else
				self.dbId = label
			end
		end
	end

	if not items then
		self.items, self.weight, self.datastore = Inventory.Load(self.dbId, invType, owner)
	elseif weight == 0 and next(items) then
		self.weight = Inventory.CalculateWeight(items)
	end

	Inventories[self.id] = self
	return Inventories[self.id]
end

---@param inv table | string | number
function Inventory.Remove(inv)
	inv = Inventory(inv)

	if inv then
		if inv.type == 'drop' then
			TriggerClientEvent('ox_inventory:removeDrop', -1, inv.id)
			Inventory.Drops[inv.id] = nil
		elseif inv.player then
			activeIdentifiers[inv.owner] = nil
		end

		Inventories[inv.id] = nil
	end
end

---Update the internal reference to vehicle stashes. Does not trigger a save or update the database.
---@param oldPlate string
---@param newPlate string
function Inventory.UpdateVehicle(oldPlate, newPlate)
	local trunk = Inventory('trunk'..oldPlate)
	local glove = Inventory('glove'..oldPlate)

	if trunk then
		Inventories[trunk.id] = nil
		trunk.label = newPlate
		trunk.dbId = type(trunk.id) == 'number' and trunk.dbId or newPlate
		trunk.id = 'trunk'..newPlate
		Inventories[trunk.id] = trunk
	end

	if glove then
		Inventories[glove.id] = nil
		glove.label = newPlate
		glove.dbId = type(glove.id) == 'number' and glove.dbId or newPlate
		glove.id = 'glove'..newPlate
		Inventories[glove.id] = glove
	end
end
exports('UpdateVehicle', Inventory.UpdateVehicle)
function Inventory.Save(inv)
	inv = Inventory(inv)

	if inv then
		local items = json.encode(minimal(inv))
		inv.changed = false

		if inv.player then
			db.savePlayer(inv.owner, items)
		else
			if inv.type == 'trunk' then
				db.saveTrunk(inv.dbId, items)
			elseif inv.type == 'glovebox' then
				db.saveGlovebox(inv.dbId, items)
			else
				db.saveStash(inv.owner, inv.dbId, items)
			end
		end
	end
end

local function randomItem(loot, items, size)
	local item = loot[math.random(1, size)]
	for i = 1, #items do
		if items[i][1] == item[1] then
			return randomItem(loot, items, size)
		end
	end
	return item
end

local function randomLoot(loot)
	local items = {}

	if loot then
		local size = #loot
		for i = 1, math.random(0, 3) do
			if i > size then return items end
			local item = randomItem(loot, items, size)
			if math.random(1, 100) <= (item[4] or 80) then
				local count = math.random(item[2], item[3])
				if count > 0 then
					items[#items+1] = {item[1], count}
				end
			end
		end
	end

	return items
end

---@param inv table | string | number
---@param invType string
---@param items? table
---@return table returnData, number totalWeight, boolean true
local function generateItems(inv, invType, items)
	if items == nil then
		if invType == 'dumpster' then
			items = randomLoot(server.dumpsterloot)
		elseif invType == 'vehicle' then
			items = randomLoot(server.vehicleloot)
		end
	end

	if not items then
		items = {}
	end

	local returnData, totalWeight = table.create(#items, 0), 0
	for i = 1, #items do
		local v = items[i]
		local item = Items(v[1])
		if not item then
			shared.warning('unable to generate', v[1], 'item does not exist')
		else
			local metadata, count = Items.Metadata(inv, item, v[3] or {}, v[2])
			local weight = Inventory.SlotWeight(item, {count=count, metadata=metadata})
			totalWeight = totalWeight + weight
			returnData[i] = {name = item.name, label = item.label, weight = weight, slot = i, count = count, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
		end
	end

	return returnData, totalWeight, true
end

---@param id string|number
---@param invType string
---@param owner string | number | boolean
function Inventory.Load(id, invType, owner)
	local datastore, result

	if id and invType then
		if invType == 'dumpster' then
			if server.randomloot then
				return generateItems(id, invType)
			else
				datastore = true
			end
		elseif invType == 'trunk' or invType == 'glovebox' then
			result = invType == 'trunk' and db.loadTrunk(id) or db.loadGlovebox(id)

			if not result then
				if server.randomloot then
					return generateItems(id, 'vehicle')
				else
					datastore = true
				end
			else result = result[invType] end
		else
			result = db.loadStash(owner or '', id)
		end
	end

	local returnData, weight = {}, 0

	if result and type(result) == 'string' then
		result = json.decode(result)
	end

	if result then
		local ostime = os.time()

		for _, v in pairs(result) do
			local item = Items(v.name)
			if item then
				v.metadata = Items.CheckMetadata(v.metadata or {}, item, v.name, ostime)
				local slotWeight = Inventory.SlotWeight(item, v)
				weight += slotWeight
				returnData[v.slot] = {name = item.name, label = item.label, weight = slotWeight, slot = v.slot, count = v.count, description = item.description, metadata = v.metadata, stack = item.stack, close = item.close}
			end
		end
	end

	return returnData, weight, datastore
end

local table = lib.table

---@param inv table | string | number
---@param item table | string
---@param metadata? any
---@param returnsCount? boolean
---@return table | number | nil
function Inventory.GetItem(inv, item, metadata, returnsCount)
	if type(item) ~= 'table' then item = Items(item) end

	if item then
		item = returnsCount and item or table.clone(item)
		inv = Inventory(inv)
		local count = 0

		if inv then
			local ostime = os.time()

			if type(metadata) ~= 'table' then
				metadata = metadata and { type = metadata or nil }
			end

			for _, v in pairs(inv.items) do
				if v and v.name == item.name and (not metadata or table.contains(v.metadata, metadata)) then
					count += v.count
					local durability = v.metadata.durability

					if durability and durability > 100 and ostime >= durability then
						v.metadata.durability = 0
					end
				end
			end
		end

		if returnsCount then return count else
			item.count = count
			return item
		end
	end
end
exports('GetItem', Inventory.GetItem)

---@param fromInventory any
---@param toInventory any
---@param slot1 number
---@param slot2 number
function Inventory.SwapSlots(fromInventory, toInventory, slot1, slot2)
	local fromSlot = fromInventory.items[slot1] and table.clone(fromInventory.items[slot1]) or nil
	local toSlot = toInventory.items[slot2] and table.clone(toInventory.items[slot2]) or nil
	if fromSlot then fromSlot.slot = slot2 end
	if toSlot then toSlot.slot = slot1 end
	fromInventory.items[slot1], toInventory.items[slot2] = toSlot, fromSlot
	return fromSlot, toSlot
end
exports('SwapSlots', Inventory.SwapSlots)

function Inventory.ContainerWeight(container, metaWeight, playerInventory)
	playerInventory.weight -= container.weight
	container.weight = Items(container.name).weight
	container.weight += metaWeight
	container.metadata.weight = metaWeight
	playerInventory.weight += container.weight
end

---@param inv table | string | number
---@param item table | string
---@param count number
---@param metadata? table
function Inventory.SetItem(inv, item, count, metadata)
	if type(item) ~= 'table' then item = Items(item) end
	if item and count >= 0 then
		inv = Inventory(inv)
		if inv then
			local itemCount = Inventory.GetItem(inv, item.name, metadata, true) --[[@as number]]

			if count > itemCount then
				count -= itemCount
				Inventory.AddItem(inv, item.name, count, metadata)
			elseif count <= itemCount then
				itemCount -= count
				Inventory.RemoveItem(inv, item.name, itemCount, metadata)
			end
		end
	end
end

---@param inv table | string | number
function Inventory.GetCurrentWeapon(inv)
	inv = Inventory(inv)

	if inv?.player then
		local weapon = inv.items[inv.weapon]

		if weapon and Items(weapon.name).weapon then
			return weapon
		end

		inv.weapon = nil
	end
end
exports('GetCurrentWeapon', Inventory.GetCurrentWeapon)

---@param inv table | string | number
---@param slot number
---@return table? item
function Inventory.GetSlot(inv, slot)
	inv = Inventory(inv)

	if inv then
		slot = inv.items[slot]
		local durability = slot?.metadata.durability

		if durability and durability > 100 and os.time() >= durability then
			slot.metadata.durability = 0
		end

		return slot
	end
end
exports('GetSlot', Inventory.GetSlot)

---@param inv table | string | number
---@param slot number
function Inventory.SetDurability(inv, slot, durability)
	inv = Inventory(inv)

	if inv then
		slot = inv.items[slot]

		if slot then
			slot.metadata.durability = durability

			if inv.player then
				if server.syncInventory then server.syncInventory(inv) end
				TriggerClientEvent('ox_inventory:updateSlots', inv.id, {{item = slot, inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight})
			end
		end
	end
end
exports('SetDurability', Inventory.SetDurability)

---@param inv table | string | number
---@param slot number | false
---@param metadata table
function Inventory.SetMetadata(inv, slot, metadata)
	inv = Inventory(inv)
	slot = type(slot) == 'number' and (inv and inv.items[slot])
	if inv and slot then
		if inv then
			slot.metadata = type(metadata) == 'table' and metadata or { type = metadata or nil }

			if metadata.weight then
				inv.weight -= slot.weight
				slot.weight = Inventory.SlotWeight(Items(slot.name), slot)
				inv.weight += slot.weight
			end

			if inv.player then
				if server.syncInventory then server.syncInventory(inv) end
				TriggerClientEvent('ox_inventory:updateSlots', inv.id, {{item = slot, inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight})
			end
		end
	end
end
exports('SetMetadata', Inventory.SetMetadata)

---@param inv table | string | number
---@param item table | string
---@param count number
---@param metadata? table | string
---@param slot? number
---@param cb? fun(success?: boolean, response: string|OxItem|nil)
---@return boolean? success, string|OxItem|nil response
function Inventory.AddItem(inv, item, count, metadata, slot, cb)
	if type(item) ~= 'table' then item = Items(item) end
	if type(inv) ~= 'table' then inv = Inventory(inv) end
	count = math.floor(count + 0.5)
	local success, response

	if item then
		if inv then
			if metadata and type(metadata) ~= 'table' then
				metadata = metadata and { type = metadata or nil }
			end

			local toSlot, slotMetadata, slotCount

			if slot then
				local slotItem = inv.items[slot]
				slotMetadata, slotCount = Items.Metadata(inv.id, item, metadata or {}, count)

				if not slotItem or (item.stack and slotItem.name == item.name and table.matches(slotItem.metadata, slotMetadata)) then
					toSlot = slot
				end
			end

			if not toSlot then
				local items = inv.items
				slotMetadata, slotCount = Items.Metadata(inv.id, item, metadata and table.clone(metadata) or {}, count)

				for i = 1, inv.slots do
					local slotItem = items[i]

					if item.stack and slotItem ~= nil and slotItem.name == item.name and table.matches(slotItem.metadata, slotMetadata) then
						toSlot = i
						break
					elseif not item.stack and not slotItem then
						if not toSlot then toSlot = {} end

						toSlot[#toSlot + 1] = { slot = i, count = slotCount, metadata = slotMetadata }

						if count == slotCount then
							break
						end

						count -= 1
						slotMetadata, slotCount = Items.Metadata(inv.id, item, metadata and table.clone(metadata) or {}, count)
					elseif not toSlot and not slotItem then
						toSlot = i
						break
					end
				end
			end

			if toSlot then
				if type(toSlot) == 'number' then
					Inventory.SetSlot(inv, item, slotCount, slotMetadata, toSlot)

					if inv.player then
						if server.syncInventory then server.syncInventory(inv) end
						TriggerClientEvent('ox_inventory:updateSlots', inv.id, {{item = inv.items[toSlot], inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight}, slotCount, false)
					end

					local invokingResource = server.loglevel > 1 and GetInvokingResource()

					if invokingResource then
						lib.logger(inv.owner, 'addItem', ('"%s" added %sx %s to "%s"'):format(invokingResource, count, item.name, inv.label))
					end

					success = true
					response = inv.items[toSlot]
				else
					local added = 0

					for i = 1, #toSlot do
						local data = toSlot[i]
						added += data.count
						Inventory.SetSlot(inv, item, data.count, data.metadata, data.slot)
						toSlot[i] = { item = inv.items[data.slot], inventory = inv.type }
					end

					if inv.player then
						if server.syncInventory then server.syncInventory(inv) end
						TriggerClientEvent('ox_inventory:updateSlots', inv.id, toSlot, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight}, added, false)
					end

					local invokingResource = server.loglevel > 1 and GetInvokingResource()

					if invokingResource then
						lib.logger(inv.owner, 'addItem', ('"%s" added %sx %s to "%s"'):format(invokingResource, added, item.name, inv.label))
					end

					for i = 1, #toSlot do
						toSlot[i] = toSlot[i].item
					end

					success = true
					response = toSlot
				end
			else
				response = 'inventory_full'
			end
		else
			response = 'invalid_inventory'
		end
	else
		response = 'invalid_item'
	end

	if cb then
		return cb(success, response)
	end

	return success, response
end
exports('AddItem', Inventory.AddItem)

---@param inv table | string | number
---@param search string|number slots|1, count|2
---@param items table | string
---@param metadata? table | string
function Inventory.Search(inv, search, items, metadata)
	if items then
		inv = Inventory(inv)
		if inv then
			inv = inv.items

			if search == 'slots' then search = 1 elseif search == 'count' then search = 2 end
			if type(items) == 'string' then items = {items} end

			if type(metadata) ~= 'table' then
				metadata = metadata and { type = metadata or nil }
			end

			local itemCount = #items
			local returnData = {}

			for i = 1, itemCount do
				local item = string.lower(items[i])
				if item:sub(0, 7) == 'weapon_' then item = string.upper(item) end

				if search == 1 then
					returnData[item] = {}
				elseif search == 2 then
					returnData[item] = 0
				end

				for _, v in pairs(inv) do
					if v.name == item then
						if not v.metadata then v.metadata = {} end

						if not metadata or table.contains(v.metadata, metadata) then
							if search == 1 then
								returnData[item][#returnData[item]+1] = inv[v.slot]
							elseif search == 2 then
								returnData[item] += v.count
							end
						end
					end
				end
			end

			if next(returnData) then return itemCount == 1 and returnData[items[1]] or returnData end
		end
	end

	return false
end
exports('Search', Inventory.Search)

---@param inv table | string | number
---@param item table | string
---@param metadata? table
function Inventory.GetItemSlots(inv, item, metadata)
	inv = Inventory(inv)
	local totalCount, slots, emptySlots = 0, {}, inv.slots
	for k, v in pairs(inv.items) do
		emptySlots -= 1
		if v.name == item.name then
			if metadata and v.metadata == nil then
				v.metadata = {}
			end
			if not metadata or table.matches(v.metadata, metadata) then
				totalCount = totalCount + v.count
				slots[k] = v.count
			end
		end
	end
	return slots, totalCount, emptySlots
end
exports('GetItemSlots', Inventory.GetItemSlots)

---@param inv table | string | number
---@param item table | string
---@param count number
---@param metadata? table | string
---@param slot number?
---@return boolean? success
function Inventory.RemoveItem(inv, item, count, metadata, slot)
	if type(item) ~= 'table' then item = Items(item) end
	count = math.floor(count + 0.5)
	if item and count > 0 then
		inv = Inventory(inv)

		if type(metadata) ~= 'table' then
			metadata = metadata and { type = metadata or nil }
		end

		local itemSlots, totalCount = Inventory.GetItemSlots(inv, item, metadata)
		if count > totalCount then count = totalCount end
		local removed, total, slots = 0, count, {}
		if slot and itemSlots[slot] then
			removed = count
			Inventory.SetSlot(inv, item, -count, inv.items[slot].metadata, slot)
			slots[#slots+1] = inv.items[slot] or slot
		elseif itemSlots and totalCount > 0 then
			for k, v in pairs(itemSlots) do
				if removed < total then
					if v == count then
						removed = total
						inv.weight -= inv.items[k].weight
						inv.items[k] = nil
						slots[#slots+1] = inv.items[k] or k
					elseif v > count then
						Inventory.SetSlot(inv, item, -count, inv.items[k].metadata, k)
						slots[#slots+1] = inv.items[k] or k
						removed = total
						count = v - count
					else
						removed = removed + v
						count = count - v
						inv.weight -= inv.items[k].weight
						inv.items[k] = nil
						slots[#slots+1] = k
					end
				else break end
			end
		end

		if removed > 0 then
			if inv.player then
				if server.syncInventory then server.syncInventory(inv) end

				local array = table.create(#slots, 0)

				for k, v in pairs(slots) do
					array[k] = {item = type(v) == 'number' and { slot = v } or v, inventory = inv.type}
				end

				TriggerClientEvent('ox_inventory:updateSlots', inv.id, array, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight}, removed, true)

				local invokingResource = server.loglevel > 1 and GetInvokingResource()

				if invokingResource then
					lib.logger(inv.owner, 'removeItem', ('"%s" removed %sx %s from "%s"'):format(invokingResource, removed, item.name, inv.label))
				end
			end

			return true
		end
	end
end
exports('RemoveItem', Inventory.RemoveItem)

---@param inv table | string | number
---@param item table | string
---@param count number
---@param metadata? table | string
function Inventory.CanCarryItem(inv, item, count, metadata)
	if type(item) ~= 'table' then item = Items(item) end
	if item then
		inv = Inventory(inv)
		local itemSlots, totalCount, emptySlots = Inventory.GetItemSlots(inv, item, type(metadata) == 'table' and metadata or { type = metadata or nil })
		local weight = metadata?.weight or item.weight

		if next(itemSlots) or emptySlots > 0 then
			if weight == 0 then return true end
			if count == nil then count = 1 end
			local newWeight = inv.weight + (weight * count)

			if newWeight > inv.maxWeight then
				TriggerClientEvent('ox_lib:notify', inv.id, { type = 'error', description = locale('cannot_carry') })
				return false
			end

			return true
		end
	end
end
exports('CanCarryItem', Inventory.CanCarryItem)

---@param inv table | string | number
---@param item table | string
function Inventory.CanCarryAmount(inv, item)
    if type(item) ~= 'table' then item = Items(item) end
    if item then
        inv = Inventory(inv)
            local availableWeight = inv.maxWeight - inv.weight
            local canHold = math.floor(availableWeight / item.weight)
            return canHold
    end
end
exports('CanCarryAmount', Inventory.CanCarryAmount)

---@param inv table | string | number
---@param firstItem string
---@param firstItemCount number
---@param testItem string
---@param testItemCount number
function Inventory.CanSwapItem(inv, firstItem, firstItemCount, testItem, testItemCount)
	inv = Inventory(inv)
	local firstItemData = Inventory.GetItem(inv, firstItem)
	local testItemData = Inventory.GetItem(inv, testItem)
	if firstItemData and testItemData and firstItemData.count >= firstItemCount then
		local weightWithoutFirst = inv.weight - (firstItemData.weight * firstItemCount)
		local weightWithTest = weightWithoutFirst + (testItemData.weight * testItemCount)
		return weightWithTest <= inv.maxWeight
	end
end
exports('CanSwapItem', Inventory.CanSwapItem)

---Mostly for internal use, but deprecated.
---@param name string
---@param count number
---@param metadata table
---@param slot number
RegisterServerEvent('ox_inventory:removeItem', function(name, count, metadata, slot)
	Inventory.RemoveItem(source, name, count, metadata, slot)
end)

Inventory.Drops = {}

local function generateDropId()
	local drop
	repeat
		drop = math.random(100000, 999999)
		Wait(0)
	until not Inventories[drop]
	return drop
end

local function CustomDrop(prefix, items, coords, slots, maxWeight, instance)
	local drop = generateDropId()
	local inventory = Inventory.Create(drop, prefix..' '..drop, 'drop', slots or shared.playerslots, 0, maxWeight or shared.playerweight, false)
	local items, weight = generateItems(inventory, 'drop', items)

	inventory.items = items
	inventory.weight = weight
	inventory.coords = coords
	Inventory.Drops[drop] = {coords = inventory.coords, instance = instance}
	TriggerClientEvent('ox_inventory:createDrop', -1, drop, Inventory.Drops[drop], inventory.open and source)
end
AddEventHandler('ox_inventory:customDrop', CustomDrop)
exports('CustomDrop', CustomDrop)

local function dropItem(source, data)
	local playerInventory = Inventory(source)
	local fromData = playerInventory.items[data.fromSlot]

	if not fromData then return end

	if not TriggerEventHooks('swapItems', {
		source = source,
		fromInventory = playerInventory.id,
		fromSlot = fromData,
		fromType = playerInventory.type,
		toInventory = 'newdrop',
		toSlot = data.toSlot,
		toType = 'drop',
		count = data.count,
	}) then return end

	if data.count > fromData.count then data.count = fromData.count end

	local toData = table.clone(fromData)
	toData.slot = data.toSlot
	toData.count = data.count
	fromData.count -= data.count
	fromData.weight = Inventory.SlotWeight(Items(fromData.name), fromData)
	toData.weight = Inventory.SlotWeight(Items(toData.name), toData)

	if fromData.count < 1 then fromData = nil end

	playerInventory.weight -= toData.weight
	local slot = data.fromSlot
	local items = { [slot] = fromData or false }
	playerInventory.items[slot] = fromData

	if slot == playerInventory.weapon then
		playerInventory.weapon = nil
	end

	local dropId = generateDropId()
	local inventory = Inventory.Create(dropId, 'Drop '..dropId, 'drop', shared.playerslots, toData.weight, shared.playerweight, false, {[data.toSlot] = toData})
	local coords = GetEntityCoords(GetPlayerPed(source))
	inventory.coords = vec3(coords.x, coords.y, coords.z-0.2)
	Inventory.Drops[dropId] = {coords = inventory.coords, instance = data.instance}
	playerInventory.changed = true

	TriggerClientEvent('ox_inventory:createDrop', -1, dropId, Inventory.Drops[dropId], playerInventory.open and source, slot)

	if server.loglevel > 0 then
		lib.logger(playerInventory.owner, 'swapSlots', ('%sx %s transferred from "%s" to "%s"'):format(data.count, toData.name, playerInventory.label, dropId))
	end

	if server.syncInventory then server.syncInventory(playerInventory) end

	return true, { weight = playerInventory.weight, items = items }
end

lib.callback.register('ox_inventory:swapItems', function(source, data)
	if data.count > 0 and data.toType ~= 'shop' then
		if data.toType == 'newdrop' then
			return dropItem(source, data)
		else
			local playerInventory = Inventory(source)
			local toInventory = (data.toType == 'player' and playerInventory) or Inventory(playerInventory.open)
			local fromInventory = (data.fromType == 'player' and playerInventory) or Inventory(playerInventory.open)

			if not fromInventory then
				Wait(0)
				fromInventory = (data.fromType == 'player' and playerInventory) or Inventory(playerInventory.open)

				if not fromInventory then
					return shared.warning('Unknown error occured during swapItems\n', json.encode(data, {indent = true}))
				end
			end

			local sameInventory = fromInventory.id == toInventory.id
			local fromOtherPlayer = fromInventory.player and fromInventory ~= playerInventory
			local toOtherPlayer = toInventory.player and toInventory ~= playerInventory

			local toData = toInventory.items[data.toSlot]

			if not sameInventory and (fromInventory.type == 'policeevidence' or (toInventory.type == 'policeevidence' and toData)) then
				local group, rank = server.hasGroup(playerInventory, shared.police)

				if not group or server.evidencegrade > rank then
					return false, 'evidence_cannot_take'
				end
			end

			if toInventory and fromInventory and (fromInventory.id ~= toInventory.id or data.fromSlot ~= data.toSlot) then
				local fromData = fromInventory.items[data.fromSlot]

				if fromData and (not fromData.metadata.container or fromData.metadata.container and toInventory.type ~= 'container') then
					if data.count > fromData.count then data.count = fromData.count end

					local container = (not sameInventory and playerInventory.containerSlot) and (fromInventory.type == 'container' and fromInventory or toInventory)
					local containerItem = container and playerInventory.items[playerInventory.containerSlot]
					local hookPayload = {
						source = source,
						fromInventory = fromInventory.id,
						fromSlot = fromData,
						fromType = fromInventory.type,
						toInventory = toInventory.id,
						toSlot = toData or data.toSlot,
						toType = toInventory.type,
						count = data.count,
					}

					if toData and ((toData.name ~= fromData.name) or not toData.stack or (not table.matches(toData.metadata, fromData.metadata))) then
						-- Swap items
						local toWeight = not sameInventory and (toInventory.weight - toData.weight + fromData.weight)
						local fromWeight = not sameInventory and (fromInventory.weight + toData.weight - fromData.weight)
						hookPayload.action = 'swap'

						if not sameInventory then
							if (toWeight <= toInventory.maxWeight and fromWeight <= fromInventory.maxWeight) then
								if not TriggerEventHooks('swapItems', hookPayload) then return end

								fromInventory.weight = fromWeight
								toInventory.weight = toWeight

								if containerItem then
									local toContainer = toInventory.type == 'container'
									local whitelist = Items.containers[containerItem.name]?.whitelist
									local blacklist = Items.containers[containerItem.name]?.blacklist
									local checkItem = toContainer and fromData.name or toData.name

									if (whitelist and not whitelist[checkItem]) or (blacklist and blacklist[checkItem]) then
										return
									end

									Inventory.ContainerWeight(containerItem, toContainer and toWeight or fromWeight, playerInventory)
								end

								if fromOtherPlayer then
									TriggerClientEvent('ox_inventory:itemNotify', fromInventory.id, { fromData.metadata?.label or fromData.label, fromData.metadata?.image or fromData.name, 'ui_removed', fromData.count })
									TriggerClientEvent('ox_inventory:itemNotify', fromInventory.id, { toData.metadata?.label or toData.label, toData.metadata?.image or toData.name, 'ui_added', toData.count })
								elseif toOtherPlayer then
									TriggerClientEvent('ox_inventory:itemNotify', toInventory.id, { fromData.metadata?.label or fromData.label, fromData.metadata?.image or fromData.name, 'ui_added', fromData.count })
									TriggerClientEvent('ox_inventory:itemNotify', toInventory.id, { toData.metadata?.label or toData.label, toData.metadata?.image or toData.name, 'ui_removed', toData.count })
								end

								toData, fromData = Inventory.SwapSlots(fromInventory, toInventory, data.fromSlot, data.toSlot) --[[@as table]]

								if server.loglevel > 0 then
									lib.logger(playerInventory.owner, 'swapSlots', ('%sx %s transferred from "%s" to "%s" for %sx %s'):format(fromData.count, fromData.name, fromInventory.owner and fromInventory.label or fromInventory.id, toInventory.owner and toInventory.label or toInventory.id, toData.count, toData.name))
								end
							else return false, 'cannot_carry' end
						else
							if not TriggerEventHooks('swapItems', hookPayload) then return end

							toData, fromData = Inventory.SwapSlots(fromInventory, toInventory, data.fromSlot, data.toSlot)
						end

					elseif toData and toData.name == fromData.name and table.matches(toData.metadata, fromData.metadata) then
						-- Stack items
						toData.count += data.count
						fromData.count -= data.count
						local toSlotWeight = Inventory.SlotWeight(Items(toData.name), toData)
						local totalWeight = toInventory.weight - toData.weight + toSlotWeight

						if fromInventory.type == 'container' or sameInventory or totalWeight <= toInventory.maxWeight then
							hookPayload.action = 'stack'

							if not TriggerEventHooks('swapItems', hookPayload) then
								toData.count -= data.count
								fromData.count += data.count
								return
							end

							local fromSlotWeight = Inventory.SlotWeight(Items(fromData.name), fromData)
							toData.weight = toSlotWeight

							if not sameInventory then
								fromInventory.weight = fromInventory.weight - fromData.weight + fromSlotWeight
								toInventory.weight = totalWeight

								if container then
									Inventory.ContainerWeight(containerItem, toInventory.type == 'container' and toInventory.weight or fromInventory.weight, playerInventory)
								end

								if fromOtherPlayer then
									TriggerClientEvent('ox_inventory:itemNotify', fromInventory.id, { fromData.metadata?.label or fromData.label, fromData.metadata?.image or fromData.name, 'ui_removed', data.count })
								elseif toOtherPlayer then
									TriggerClientEvent('ox_inventory:itemNotify', toInventory.id, { toData.metadata?.label or toData.label, toData.metadata?.image or toData.name, 'ui_added', data.count })
								end

								if server.loglevel > 0 then
									lib.logger(playerInventory.owner, 'swapSlots', ('%sx %s transferred from "%s" to "%s"'):format(data.count, fromData.name, fromInventory.owner and fromInventory.label or fromInventory.id, toInventory.owner and toInventory.label or toInventory.id))
								end
							end

							fromData.weight = fromSlotWeight
						else
							toData.count -= data.count
							fromData.count += data.count
							return false, 'cannot_carry'
						end
					elseif data.count <= fromData.count then
						-- Move item to an empty slot
						toData = table.clone(fromData)
						toData.count = data.count
						toData.slot = data.toSlot
						toData.weight = Inventory.SlotWeight(Items(toData.name), toData)

						if fromInventory.type == 'container' or sameInventory or (toInventory.weight + toData.weight <= toInventory.maxWeight) then
							hookPayload.action = 'move'

							if not TriggerEventHooks('swapItems', hookPayload) then return end

							if not sameInventory then
								local toContainer = toInventory.type == 'container'

								if container then
									if toContainer and containerItem then
										local whitelist = Items.containers[containerItem.name]?.whitelist
										local blacklist = Items.containers[containerItem.name]?.blacklist

										if (whitelist and not whitelist[fromData.name]) or (blacklist and blacklist[fromData.name]) then
											return
										end
									end
								end

								fromInventory.weight -= toData.weight
								toInventory.weight += toData.weight

								if container then
									Inventory.ContainerWeight(containerItem, toContainer and toInventory.weight or fromInventory.weight, playerInventory)
								end

								if fromOtherPlayer then
									TriggerClientEvent('ox_inventory:itemNotify', fromInventory.id, { fromData.metadata?.label or fromData.label, fromData.metadata?.image or fromData.name, 'ui_removed', data.count })
								elseif toOtherPlayer then
									TriggerClientEvent('ox_inventory:itemNotify', toInventory.id, { fromData.metadata?.label or fromData.label, fromData.metadata?.image or fromData.name, 'ui_added', data.count })
								end

								if server.loglevel > 0 then
									lib.logger(playerInventory.owner, 'swapSlots', ('%sx %s transferred from "%s" to "%s"'):format(data.count, fromData.name, fromInventory.owner and fromInventory.label or fromInventory.id, toInventory.owner and toInventory.label or toInventory.id))
								end
							end

							fromData.count -= data.count
							fromData.weight = Inventory.SlotWeight(Items(fromData.name), fromData)

							if fromData.count > 0 then
								toData.metadata = table.clone(toData.metadata)
							end
						else return false, 'cannot_carry' end
					end

					if fromData and fromData.count < 1 then fromData = nil end

					local items = {}

					if fromInventory.player and not fromOtherPlayer then
						items[data.fromSlot] = fromData or false
						if toInventory.type == 'container' then
							items[playerInventory.containerSlot] = containerItem
						end
					end

					if toInventory.player and not toOtherPlayer then
						items[data.toSlot] = toData or false
						if fromInventory.type == 'container' then
							items[playerInventory.containerSlot] = containerItem
						end
					end

					fromInventory.items[data.fromSlot] = fromData
					toInventory.items[data.toSlot] = toData

					if fromInventory.changed ~= nil then fromInventory.changed = true end
					if toInventory.changed ~= nil then toInventory.changed = true end

					if sameInventory and fromOtherPlayer then
						TriggerClientEvent('ox_inventory:updateSlots', fromInventory.id,{
							{
								item = fromInventory.items[data.toSlot] or {slot=data.toSlot},
								inventory = fromInventory.type
							},
							{
								item = fromInventory.items[data.fromSlot] or {slot=data.fromSlot},
								inventory = fromInventory.type
							}
						}, { left = fromInventory.weight })

					elseif toOtherPlayer then
						TriggerClientEvent('ox_inventory:updateSlots', toInventory.id,{
							{
								item = toInventory.items[data.toSlot] or {slot=data.toSlot},
								inventory = toInventory.type
							}
						}, { left = toInventory.weight })

					elseif fromOtherPlayer then
						TriggerClientEvent('ox_inventory:updateSlots', fromInventory.id,{
							{
								item = fromInventory.items[data.fromSlot] or {slot=data.fromSlot},
								inventory = fromInventory.type
							}
						}, { left = fromInventory.weight })
					end

					local resp

					if next(items) then
						resp = { weight = playerInventory.weight, items = items }

						if server.syncInventory then
							if fromInventory.player then
								server.syncInventory(fromInventory)
							end

							if toInventory.player and not sameInventory then
								server.syncInventory(toInventory)
							end
						end
					end

					local weaponSlot

					if toInventory.weapon == data.toSlot then
						if not sameInventory then
							toInventory.weapon = nil
							TriggerClientEvent('ox_inventory:disarm', toInventory.id)
						else
							weaponSlot = data.fromSlot
							toInventory.weapon = weaponSlot
						end
					end

					if fromInventory.weapon == data.fromSlot then
						if not sameInventory then
							fromInventory.weapon = nil
							TriggerClientEvent('ox_inventory:disarm', fromInventory.id)
						elseif not weaponSlot then
							weaponSlot = data.toSlot
							fromInventory.weapon = weaponSlot
						end
					end

					return containerItem and containerItem.weight or true, resp, weaponSlot
				end
			end
		end
	end
end)

function Inventory.Confiscate(source)
	local inv = Inventories[source]
	if inv?.player then
		db.saveStash(inv.owner, inv.owner, json.encode(minimal(inv)))
		table.wipe(inv.items)
		inv.weight = 0
		TriggerClientEvent('ox_inventory:inventoryConfiscated', inv.id)
		if server.syncInventory then server.syncInventory(inv) end
	end
end
exports('ConfiscateInventory', Inventory.Confiscate)

function Inventory.Return(source)
	local inv = Inventories[source]

	if inv?.player then
		MySQL.scalar('SELECT data FROM ox_inventory WHERE name = ?', { inv.owner }, function(data)
			if data then
				MySQL.query('DELETE FROM ox_inventory WHERE name = ?', { inv.owner })
				data = json.decode(data)
				local inventory, totalWeight = {}, 0

				if data and next(data) then
					for i = 1, #data do
						local i = data[i]
						if type(i) == 'number' then break end
						local item = Items(i.name)
						if item then
							local weight = Inventory.SlotWeight(item, i)
							totalWeight = totalWeight + weight
							inventory[i.slot] = {name = i.name, label = item.label, weight = weight, slot = i.slot, count = i.count, description = item.description, metadata = i.metadata, stack = item.stack, close = item.close}
						end
					end
				end

				inv.weight = totalWeight
				inv.items = inventory

				TriggerClientEvent('ox_inventory:inventoryReturned', source, {inventory, totalWeight})

				if server.syncInventory then server.syncInventory(inv) end
			end
		end)
	end
end
exports('ReturnInventory', Inventory.Return)

---@param inv table | string | number
---@param keep? string | string[] an item or list of items to ignore while clearing items
function Inventory.Clear(inv, keep)
	inv = Inventory(inv)
	if not inv then return end

	local updateSlots = inv.player and {}
	local newWeight = 0
	local inc = 0

	if keep then
		local keptItems = {}
		local keepType = type(keep)

		if keepType == 'string' then
			for slot, v in pairs(inv.items) do
				if v.name == keep then
					keptItems[v.slot] = v
					newWeight += v.weight
				elseif updateSlots then
					inc += 1
					updateSlots[inc] = { item = { slot = slot }, inventory = inv.type }
				end
			end
		elseif keepType == 'table' and table.type(keep) == 'array' then
			for slot, v in pairs(inv.items) do
				for i = 1, #keep do
					if v.name == keep[i] then
						keptItems[v.slot] = v
						newWeight += v.weight
						goto foundItem
					end
				end

				if updateSlots then
					inc += 1
					updateSlots[inc] = { item = { slot = slot }, inventory = inv.type }
				end

				::foundItem::
			end
		end

		table.wipe(inv.items)
		inv.items = keptItems
	else
		if updateSlots then
			for slot in pairs(inv.items) do
				inc += 1
				updateSlots[inc] = { item = { slot = slot }, inventory = inv.type }
			end
		end

		table.wipe(inv.items)
	end

	inv.weight = newWeight
	inv.changed = true

	if not inv.player then
		if inv.open then
			local playerInv = Inventory(inv.open)
			TriggerClientEvent('ox_inventory:closeInventory', inv.open, true)
			playerInv:set('open', false)
		end

		inv:set('open', false)

		return
	end

	if server.syncInventory then server.syncInventory(inv) end

	inv.weapon = nil

	TriggerClientEvent('ox_inventory:updateSlots', inv.id, updateSlots, { left = inv.weight, right = inv.open and Inventories[inv.open]?.weight })
end
exports('ClearInventory', Inventory.Clear)

function Inventory.GetEmptySlot(inv)
	inv = Inventory(inv)

	if inv then
		local items = inv.items

		for i = 1, inv.slots do
			if not items[i] then
				return i
			end
		end
	end
end

local function prepareSave(inv)
	inv.changed = false

	if inv.player then
		if shared.framework ~= 'esx' then
			return 1, { json.encode(minimal(inv)), inv.owner }
		end
	elseif inv.type == 'trunk' then
		return 2, { json.encode(minimal(inv)), inv.dbId }
	elseif inv.type == 'glovebox' then
		return 3, { json.encode(minimal(inv)), inv.dbId }
	else
		return 4, { inv.owner or '', inv.dbId, json.encode(minimal(inv)) }
	end
end

SetInterval(function()
	local time = os.time()
	local parameters = { {}, {}, {}, {} }
	local size = { 0, 0, 0, 0 }

	for _, inv in pairs(Inventories) do
		if not inv.open then
			if not inv.datastore and inv.changed then
				local i, data = prepareSave(inv)

				if i then
					size[i] += 1
					parameters[i][size[i]] = data
				end
			end

			if not inv.player and (inv.datastore or inv.owner) and time - inv.time >= 3000 then
				Inventory.Remove(inv)
			end
		end
	end

	db.saveInventories(parameters[1], parameters[2], parameters[3], parameters[4])
end, 600000)

local function saveInventories(lock)
	local parameters = { {}, {}, {}, {} }
	local size = { 0, 0, 0, 0 }
	Inventory.Lock = lock or nil

	TriggerClientEvent('ox_inventory:closeInventory', -1, true)

	for _, inv in pairs(Inventories) do
		if not inv.datastore and inv.changed then
			local i, data = prepareSave(inv)

			if i then
				size[i] += 1
				parameters[i][size[i]] = data
			end
		end
	end

	db.saveInventories(parameters[1], parameters[2], parameters[3], parameters[4])
end

AddEventHandler('playerDropped', function()
	if GetNumPlayerIndices() == 0 then
		saveInventories()
	end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
	saveInventories(true)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == shared.resource then
		saveInventories(true)
	end
end)

RegisterServerEvent('ox_inventory:closeInventory', function()
	local inventory = Inventories[source]
	if inventory?.open then
		if type(inventory.open) ~= 'boolean' then
			local secondary = Inventories[inventory.open]
			if secondary then
				secondary:set('open', false)
			end
		end
		inventory:set('open', false)
	end
end)

RegisterServerEvent('ox_inventory:giveItem', function(slot, target, count)
	local fromInventory = Inventories[source]
	local toInventory = Inventories[target]

	if count <= 0 then count = 1 end

	if toInventory?.player then
		local data = fromInventory.items[slot]

		if not data then return end

		local item = Items(data.name)

		if not toInventory.open and data and data.count >= count and Inventory.CanCarryItem(toInventory, item, count, data.metadata) and TriggerEventHooks('swapItems', {
			source = fromInventory.id,
			fromInventory = fromInventory.id,
			fromType = fromInventory.type,
			toInventory = toInventory.id,
			toType = toInventory.type,
			count = data.count,
			action = 'give',
		}) then
			Inventory.RemoveItem(fromInventory, item, count, data.metadata, slot)
			Inventory.AddItem(toInventory, item, count, data.metadata)

			if server.loglevel > 0 then
				lib.logger(fromInventory.owner, 'giveItem', ('"%s" gave %sx %s to "%s"'):format(fromInventory.label, count, data.name, toInventory.label))
			end
		else
			TriggerClientEvent('ox_lib:notify', fromInventory.id, { type = 'error', description = locale('cannot_give', count, data.label) })
		end
	end
end)

RegisterServerEvent('ox_inventory:updateWeapon', function(action, value, slot)
	local inventory = Inventories[source]

	if not inventory then return end

	if not action then
		inventory.weapon = nil
		return
	end

	local syncInventory = false
	local type = type(value)

	if type == 'table' and action == 'component' then
		local item = inventory.items[value.slot]
		if item then
			if item.metadata.components then
				for k, v in pairs(item.metadata.components) do
					if v == value.component then
						table.remove(item.metadata.components, k)
						Inventory.AddItem(inventory, value.component, 1)
						return TriggerClientEvent('ox_inventory:updateSlots', inventory.id, {{item = item}}, {left=inventory.weight})
					end
				end
			end
		end
	else
		if not slot then slot = inventory.weapon end
		local weapon = inventory.items[slot]

		if weapon and weapon.metadata then
			local item = Items(weapon.name)

			if not item.weapon then
				inventory.weapon = nil
				return
			end

			if action == 'load' and weapon.metadata.durability > 0 then
				local ammo = Items(weapon.name).ammoname
				local diff = value - weapon.metadata.ammo
				Inventory.RemoveItem(inventory, ammo, diff)
				weapon.metadata.ammo = value
				weapon.weight = Inventory.SlotWeight(item, weapon)
				syncInventory = true
			elseif action == 'throw' then
				Inventory.RemoveItem(inventory, weapon.name, 1, weapon.metadata, weapon.slot)
			elseif action == 'component' then
				if type == 'number' then
					Inventory.AddItem(inventory, weapon.metadata.components[value], 1)
					table.remove(weapon.metadata.components, value)
					weapon.weight = Inventory.SlotWeight(item, weapon)
				elseif type == 'string' then
					local component = inventory.items[tonumber(value)]
					Inventory.RemoveItem(inventory, component.name, 1)
					table.insert(weapon.metadata.components, component.name)
					weapon.weight = Inventory.SlotWeight(item, weapon)
				end
				syncInventory = true
			elseif action == 'ammo' then
				if weapon.hash == `WEAPON_FIREEXTINGUISHER` or weapon.hash == `WEAPON_PETROLCAN` then
					weapon.metadata.durability = math.floor(value)
					weapon.metadata.ammo = weapon.metadata.durability
				elseif value < weapon.metadata.ammo then
					local durability = Items(weapon.name).durability * math.abs((weapon.metadata.ammo or 0.1) - value)
					weapon.metadata.ammo = value
					weapon.metadata.durability = weapon.metadata.durability - durability
					weapon.weight = Inventory.SlotWeight(item, weapon)
				end
				syncInventory = true
			elseif action == 'melee' and value > 0 then
				weapon.metadata.durability = weapon.metadata.durability - ((Items(weapon.name).durability or 1) * value)
				syncInventory = true
			end

			if action ~= 'throw' then TriggerClientEvent('ox_inventory:updateSlots', inventory.id, {{item = weapon}}, {left=inventory.weight}) end

			if weapon.metadata.durability and weapon.metadata.durability < 1 and action ~= 'load' and action ~= 'component' then
				TriggerClientEvent('ox_inventory:disarm', inventory.id)
			end

			if server.syncInventory and syncInventory then
				server.syncInventory(inventory)
			end
		end
	end
end)

lib.addCommand('group.admin', {'additem', 'giveitem'}, function(source, args)
	args.item = Items(args.item)
	if args.item and args.count > 0 then
		local metadata = args.metatype and { type = tonumber(args.metatype) or args.metatype }
		Inventory.AddItem(args.target, args.item.name, args.count, metadata)

		local inventory = Inventories[args.target]
		source = Inventories[source] or { label = 'console', owner = 'console' }

		if server.loglevel > 0 then
			lib.logger(source.owner, 'admin', ('"%s" gave %sx %s to "%s"'):format(source.label, args.count, args.item.name, inventory.label))
		end
	end
end, {'target:number', 'item:string', 'count:number', 'metatype'})

lib.addCommand('group.admin', 'removeitem', function(source, args)
	args.item = Items(args.item)
	if args.item and args.count > 0 then
		local metadata = args.metatype and { type = tonumber(args.metatype) or args.metatype }
		Inventory.RemoveItem(args.target, args.item.name, args.count, metadata)

		local inventory = Inventories[args.target]
		source = Inventories[source] or {label = 'console', owner = 'console'}

		if server.loglevel > 0 then
			lib.logger(source.owner, 'admin', ('"%s" removed %sx %s from "%s"'):format(source.label, args.count, args.item.name, inventory.label))
		end
	end
end, {'target:number', 'item:string', 'count:number', 'metatype'})

lib.addCommand('group.admin', 'setitem', function(source, args)
	args.item = Items(args.item)
	if args.item and args.count >= 0 then
		Inventory.SetItem(args.target, args.item.name, args.count, args.metaType)
		local inventory = Inventories[args.target]
		source = Inventories[source] or {label = 'console', owner = 'console'}

		if server.loglevel > 0 then
			lib.logger(source.owner, 'admin', ('"%s" set "%s" %s count to %sx'):format(source.label, inventory.label, args.item.name, args.count))
		end
	end
end, {'target:number', 'item:string', 'count:number', 'metatype:?string'})

lib.addCommand(false, 'clearevidence', function(source, args)
	local inventory = Inventories[source]
	local hasPermission = false

	if shared.framework == 'esx' then
		-- todo: make it work
	elseif shared.framework == 'qb' then
		-- todo: make it work
	else
		local group, rank = server.hasGroup(inventory, shared.police)
		---@diagnostic disable-next-line: undefined-field
		if group and rank == GlobalState.groups[group] then hasPermission = true end
	end

	if hasPermission then
		MySQL.query('DELETE FROM ox_inventory WHERE name = ?', {('evidence-%s'):format(args.evidence)})
	end
end, {'evidence:number'})

lib.addCommand('group.admin', 'takeinv', function(source, args)
	Inventory.Confiscate(args.target)
end, {'target:number'})

lib.addCommand('group.admin', 'returninv', function(source, args)
	Inventory.Return(args.target)
end, {'target:number'})

lib.addCommand('group.admin', 'clearinv', function(source, args)
	Inventory.Clear(tonumber(args.target) or args.target)
end, {'target'})

lib.addCommand('group.admin', 'saveinv', function(source, args)
	saveInventories(args[1] == 1 or args[1] == 'true')
end)

lib.addCommand('group.admin', 'viewinv', function(source, args)
	local inventory = Inventories[args.target] or Inventories[tonumber(args.target)]
	TriggerClientEvent('ox_inventory:viewInventory', source, inventory)
end, {'target'})

Inventory.accounts = server.accounts

Inventory.CustomStash = {}
---@param name string stash identifier when loading from the database
---@param label string display name when inventory is open
---@param slots number
---@param maxWeight number
---@param owner string|boolean|nil
---@param groups table
--- For simple integration with other resources that want to create valid stashes.
--- This needs to be triggered before a player can open a stash.
--- ```
--- Owner sets the stash permissions.
--- string: can only access the stash linked to the owner (usually player identifier)
--- true: each player has a unique stash, but can request other player's stashes
--- nil: always shared
---
--- groups: { ['police'] = 0 }
--- ```
local function RegisterStash(name, label, slots, maxWeight, owner, groups, coords)
	if type(name) ~= 'string' then
		error(('received %s for stash name (expected string)'):format(type(name)))
	end

	if not slots then
		error(('received %s for stash slots (expected number)'):format(slots))
	end

	if not maxWeight then
		error(('received %s for stash maxWeight (expected number)'):format(maxWeight))
	end

	if coords then
		local typeof = type(coords)
		if typeof ~= 'vector3' then
			if typeof == 'table' then
				coords = vec3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
			else
				error(('received %s for stash coords (expected vector3)'):format(typeof))
			end
		end
	end

	local curStash = Inventory.CustomStash[name]

	if curStash then
		---@todo creating proper stash classes with inheritence would simplify updating data
		---i.e. all stashes with the same type share groups, maxweight, slots, dbid, etc.
		---only label, owner, weight, coords, and items really need to vary
		for _, stash in pairs(Inventories) do
			if stash.type == 'stash' and stash.dbId == name then
				stash.label = label or stash.label
				stash.owner = (owner and owner ~= true) and stash.owner or owner
				stash.slots = slots or stash.slots
				stash.maxWeight = maxWeight or stash.maxWeight
				stash.groups = groups or stash.groups
				stash.coords = coords or stash.coords
			end
		end
	end

	Inventory.CustomStash[name] = {
		name = name,
		label = label,
		owner = owner,
		slots = slots,
		weight = maxWeight,
		groups = groups,
		coords = coords
	}
end
exports('RegisterStash', RegisterStash)

server.inventory = Inventory
