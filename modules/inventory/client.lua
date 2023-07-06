if not lib then return end

local Inventory = {}

Inventory.Dumpsters = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}

function Inventory.OpenDumpster(entity)
	local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity)

	if not netId then
		local coords = GetEntityCoords(entity)
		entity = GetClosestObjectOfType(coords.x, coords.y, coords.z, 0.1, GetEntityModel(entity), true, true, true)
		netId = entity ~= 0 and NetworkGetNetworkIdFromEntity(entity)
	end

	if netId then
		client.openInventory('dumpster', 'dumpster'..netId)
	end
end

if shared.target then
	exports.qtarget:AddTargetModel(Inventory.Dumpsters, {
		options = {
			{
				icon = 'fas fa-dumpster',
				label = locale('search_dumpster'),
				action = function(entity)
					Inventory.OpenDumpster(entity)
				end
			},
		},
		distance = 2
	})
else
	local dumpsters = table.create(0, #Inventory.Dumpsters)

	for i = 1, #Inventory.Dumpsters do
		dumpsters[Inventory.Dumpsters[i]] = true
	end

	Inventory.Dumpsters = dumpsters
end

local table = lib.table

---@param search 'slots' | 1 | 'count' | 2
---@param item table | string
---@param metadata? table | string
function Inventory.Search(search, item, metadata)
	if not PlayerData.loaded then
		if not coroutine.running() then
			error('player inventory has not yet loaded.')
		end

		repeat Wait(100) until PlayerData.loaded
	end

	if item then
		if search == 'slots' then search = 1 elseif search == 'count' then search = 2 end
		if type(item) == 'string' then item = {item} end
		if type(metadata) == 'string' then metadata = {type=metadata} end

		local items = #item
		local returnData = {}
		for i = 1, items do
			local item = string.lower(item[i])
			if item:sub(0, 7) == 'weapon_' then item = string.upper(item) end
			if search == 1 then returnData[item] = {}
			elseif search == 2 then returnData[item] = 0 end
			for _, v in pairs(PlayerData.inventory) do
				if v.name == item then
					if not v.metadata then v.metadata = {} end
					if not metadata or table.contains(v.metadata, metadata) then
						if search == 1 then returnData[item][#returnData[item]+1] = PlayerData.inventory[v.slot]
						elseif search == 2 then
							returnData[item] += v.count
						end
					end
				end
			end
		end
		if next(returnData) then return items == 1 and returnData[item[1]] or returnData end
	end
	return false
end
exports('Search', Inventory.Search)

exports('GetPlayerItems', function()
	return PlayerData.inventory
end)

exports('GetPlayerWeight', function()
	return PlayerData.weight
end)

exports('GetPlayerMaxWeight', function()
	return PlayerData.maxWeight
end)

local Items = require 'modules.items.client'

local function assertMetadata(metadata)
	if metadata and type(metadata) ~= 'table' then
		metadata = metadata and { type = metadata or nil }
	end

	return metadata
end

---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return SlotWithItem?
function Inventory.GetSlotWithItem(itemName, metadata, strict)
	local inventory = PlayerData.inventory
	local item = Items(itemName) --[[@as OxClientItem?]]

	if not inventory or not item then return end

	metadata = assertMetadata(metadata)
	local tablematch = strict and table.matches or table.contains

	for _, slotData in pairs(inventory) do
		if slotData and slotData.name == item.name and (not metadata or tablematch(slotData.metadata, metadata)) then
			return slotData
		end
	end
end

exports('GetSlotWithItem', Inventory.GetSlotWithItem)

---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return number?
function Inventory.GetSlotIdWithItem(itemName, metadata, strict)
	return Inventory.GetSlotWithItem(itemName, metadata, strict)?.slot
end

exports('GetSlotIdWithItem', Inventory.GetSlotIdWithItem)

---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return SlotWithItem[]?
function Inventory.GetSlotsWithItem(itemName, metadata, strict)
	local inventory = PlayerData.inventory
	local item = Items(itemName) --[[@as OxClientItem?]]

	if not inventory or not item then return end


	metadata = assertMetadata(metadata)
	local response = {}
	local n = 0
	local tablematch = strict and table.matches or table.contains

	for _, slotData in pairs(inventory) do
		if slotData and slotData.name == item.name and (not metadata or tablematch(slotData.metadata, metadata)) then
			n += 1
			response[n] = slotData
		end
	end

	return response
end

exports('GetSlotsWithItem', Inventory.GetSlotsWithItem)

---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return number[]?
function Inventory.GetSlotIdsWithItem(itemName, metadata, strict)
	local items = Inventory.GetSlotsWithItem(itemName, metadata, strict)

	if items then
		---@cast items +number[]
		for i = 1, #items do
			items[i] = items[i].slot
		end

		return items
	end
end

---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return number
function Inventory.GetItemCount(itemName, metadata, strict)
	local inventory = PlayerData.inventory
	local item = Items(itemName) --[[@as OxClientItem?]]

	if not inventory or not item then return 0 end

	if not metadata then
		return item.count
	end


	metadata = assertMetadata(metadata)
	local count = 0
	local tablematch = strict and table.matches or table.contains

	for _, slotData in pairs(inventory) do
		if slotData and slotData.name == item.name and (not metadata or tablematch(slotData.metadata, metadata)) then
			count += slotData.count
		end
	end

	return count
end

exports('GetItemCount', Inventory.GetItemCount)


local function openEvidence()
	client.openInventory('policeevidence')
end

---@param point CPoint
local function nearbyEvidence(point)
	---@diagnostic disable-next-line: param-type-mismatch
	DrawMarker(2, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 30, 150, 222, false, false, 0, true, false, false, false)

	if point.isClosest and point.currentDistance < 1.2 and IsControlJustReleased(0, 38) then
		openEvidence()
	end
end

Inventory.Evidence = setmetatable(data('evidence'), {
	__call = function(self)
		for _, evidence in pairs(self) do
			if evidence.point then
				evidence.point:remove()
			end

			if client.hasGroup(shared.police) then
				if shared.target then
					if evidence.target then
						exports.qtarget:RemoveZone(evidence.target.name)
						exports.qtarget:AddBoxZone(evidence.target.name, evidence.target.loc, evidence.target.length or 0.5, evidence.target.width or 0.5,
						{
							name = evidence.target.name,
							heading = evidence.target.heading or 0.0,
							debugPoly = evidence.target.debug,
							minZ = evidence.target.minZ,
							maxZ = evidence.target.maxZ,
							drawSprite = evidence.target.drawSprite,
						}, {
							options = {
								{
									icon = evidence.target.icon or 'fas fa-warehouse',
									label = locale('open_police_evidence'),
									job = shared.police,
									action = openEvidence,
									iconColor = evidence.target.iconColor,
								},
							},
							distance = evidence.target.distance or 2.0
						})
					end
				else
					evidence.target = nil
					evidence.point = lib.points.new({
						coords = evidence.coords,
						distance = 16,
						inv = 'policeevidence',
						nearby = nearbyEvidence
					})
				end
			end
		end
	end
})

local function nearbyStash(self)
	---@diagnostic disable-next-line: param-type-mismatch
	DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 30, 150, 222, false, false, 0, true, false, false, false)
end

Inventory.Stashes = setmetatable(data('stashes'), {
	__call = function(self)
		for id, stash in pairs(self) do
			if stash.jobs then stash.groups = stash.jobs end

			if stash.point then
				stash.point:remove()
			end

			if not stash.groups or client.hasGroup(stash.groups) then
				if shared.target then
					if stash.target then
						exports.qtarget:RemoveZone(stash.name)
						exports.qtarget:AddBoxZone(stash.name, stash.target.loc, stash.target.length or 0.5, stash.target.width or 0.5,
						{
							name = stash.name,
							heading = stash.target.heading or 0.0,
							debugPoly = stash.target.debug,
							minZ = stash.target.minZ,
							maxZ = stash.target.maxZ,
							drawSprite = stash.target.drawSprite,
						}, {
							options = {
								{
									icon = stash.target.icon or 'fas fa-warehouse',
									label = stash.target.label or locale('open_stash'),
									job = stash.groups,
									action = function()
										exports.ox_inventory:openInventory('stash', stash.name)
									end,
									iconColor = stash.target.iconColor,
								},
							},
							distance = stash.target.distance or 3.0
						})
					end
				else
					stash.target = nil
					stash.point = lib.points.new({
						coords = stash.coords,
						distance = 16,
						inv = 'stash',
						invId = stash.name,
						nearby = nearbyStash
					})
				end
			end
		end
	end
})

RegisterNetEvent('ox_inventory:refreshMaxWeight', function(data)
    if data.inventoryId == cache.serverId then
        PlayerData.maxWeight = data.maxWeight
    end

	SendNUIMessage({
		action = 'refreshSlots',
		data = {
			weightData = {
				inventoryId = data.inventoryId,
				maxWeight = data.maxWeight
			}
		}
	})
end)

return Inventory
