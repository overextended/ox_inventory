if not lib then return end

local Inventory = {}

local Stashes = {}

local Evidences = {}

Inventory.Dumpsters = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}

if shared.target then
	local function OpenDumpster(entity)
		entity = entity.entity
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

	exports.ox_target:addModel(Inventory.Dumpsters, {
		{
			icon = 'fas fa-dumpster',
			label = locale('search_dumpster'),
			onSelect = function(entity)
				OpenDumpster(entity)
			end,
			distance = 2
		},
	})
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
		if Evidences then
			for _, v in pairs(Evidences) do
				exports.ox_target:removeZone(v)
			end
		end

		table.wipe(Evidences)

		for _, evidence in pairs(self) do
			if evidence.point then
				evidence.point:remove()
			end

			if client.hasGroup(shared.police) then
				if shared.target then
					if evidence.target then
						Evidences[#Evidences+1] = exports.ox_target:addBoxZone({
							coords = evidence.target.loc,
							size = vec3(evidence.target.length or 0.5, evidence.target.width or 0.5, evidence.target.maxZ - evidence.target.minZ),
							rotation = evidence.target.heading or 0.0,
							debug = evidence.target.debug,
							options = {
								{
									name = evidence.target.name,
									icon = evidence.target.icon or 'fas fa-warehouse',
									label = locale('open_police_evidence'),
									onSelect = openEvidence,
									distance = evidence.target.distance or 2.0
								}
							}
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
		if Stashes then
			for _, v in pairs(Stashes) do
				exports.ox_target:removeZone(v)
			end
		end

		table.wipe(Stashes)

		for id, stash in pairs(self) do
			if stash.jobs then stash.groups = stash.jobs end

			if stash.point then
				stash.point:remove()
			end

			if not stash.groups or client.hasGroup(stash.groups) then
				if shared.target and stash.target then
					Stashes[#Stashes + 1] = exports.ox_target:addBoxZone({
						coords = stash.target.loc,
						size = vec3(stash.target.length or 0.5, stash.target.width or 0.5, stash.target.maxZ - stash.target.minZ),
						rotation = stash.target.heading or 0.0,
						debug = stash.target.debug,
						options = {
							{
								name = stash.target.name,
								icon = stash.target.icon or 'fas fa-warehouse',
								label = stash.target.label or locale('open_stash'),
								onSelect = function()
										exports.ox_inventory:openInventory('stash', stash.name)
								end,
								distance = stash.target.distance or 3.0
							}
						}
					})
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

client.inventory = Inventory
