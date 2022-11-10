if not lib then return end

local Inventory = {}

Inventory.Dumpsters = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}

if shared.target then
	local function OpenDumpster(entity)
		local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity)

		if not netId then
			NetworkRegisterEntityAsNetworked(entity)
			SetEntityAsMissionEntity(entity, false, false)
			netId = NetworkGetNetworkIdFromEntity(entity)
			NetworkUseHighPrecisionBlending(netId, false)
			SetNetworkIdExistsOnAllMachines(netId, true)
			SetNetworkIdCanMigrate(netId, true)
		end

		client.openInventory('dumpster', 'dumpster'..netId)
	end

	exports.qtarget:AddTargetModel(Inventory.Dumpsters, {
		options = {
			{
				icon = 'fas fa-dumpster',
				label = locale('search_dumpster'),
				action = function(entity)
					OpenDumpster(entity)
				end
			},
		},
		distance = 2
	})
end

local table = lib.table

---@param search string|number slots|1, count|2
---@param item table | string
---@param metadata? table | string
function Inventory.Search(search, item, metadata)
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

local function OpenStash(data)
	exports.ox_inventory:openInventory('stash', data)
end

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
										OpenStash({id=id})
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
						invId = id,
						nearby = nearbyStash
					})
				end
			end
		end
	end
})

client.inventory = Inventory
