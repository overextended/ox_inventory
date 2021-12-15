local Inventory = {}

Inventory.Dumpsters = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}

if ox.qtarget then
	local function OpenDumpster(entity)
		local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity) or false
		if netId == false then
			SetEntityAsMissionEntity(entity)
			NetworkRegisterEntityAsNetworked(entity)
			netId = NetworkGetNetworkIdFromEntity(entity)
			NetworkUseHighPrecisionBlending(netId, false)
			SetNetworkIdExistsOnAllMachines(netId)
			SetNetworkIdCanMigrate(netId, true)
		end
		exports.ox_inventory:openInventory('dumpster', 'dumpster'..netId)
	end

	exports.qtarget:AddTargetModel(Inventory.Dumpsters, {
		options = {
			{
				icon = 'fas fa-dumpster',
				label = ox.locale('search_dumpster'),
				action = function(entity)
					OpenDumpster(entity)
				end
			},
		},
		distance = 2
	})
end

local table = import 'table'

function Inventory.Search(search, item, metadata)
	if item then
		if type(item) == 'string' then item = {item} end
		if type(metadata) == 'string' then metadata = {type=metadata} end
		local items = #item
		local returnData = {}
		for i=1, items do
			local item = string.lower(item[i])
			if item:find('weapon_') then item = string.upper(item) end
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

local function OpenEvidence()
	exports.ox_inventory:openInventory('policeevidence')
end

Inventory.Evidence = setmetatable(data('evidence'), {
	__call = function(self)
		for _, evidence in pairs(self) do
			if ox.qtarget then
				exports.qtarget:RemoveZone(evidence.target.name)
				exports.qtarget:AddBoxZone(evidence.target.name, evidence.target.loc, evidence.target.length or 0.5, evidence.target.width or 0.5,
				{
					name = evidence.target.name,
					heading = evidence.target.heading or 0.0,
					debugPoly = false,
					minZ = evidence.target.minZ,
					maxZ = evidence.target.maxZ
				}, {
					options = {
						{
							icon = 'fas fa-warehouse',
							label = 'Open Police Evidence',
							job = 'police',
							action = function()
								OpenEvidence()
							end
						},
					},
					distance = evidence.target.distance or 3.0
				})
			end
		end
	end
})

local function OpenStash(data)
	exports.ox_inventory:openInventory('stash', data)
end

Inventory.Stashes = setmetatable(data('stashes'), {
	__call = function(self)
		for id, stash in pairs(self) do
			if ox.qtarget then
				exports.qtarget:RemoveZone(stash.name)
				exports.qtarget:AddBoxZone(stash.name, stash.target.loc, stash.target.length or 0.5, stash.target.width or 0.5,
				{
					name = stash.name,
					heading = stash.target.heading or 0.0,
					debugPoly = false,
					minZ = stash.target.minZ,
					maxZ = stash.target.maxZ
				}, {
					options = {
						{
							icon = 'fas fa-warehouse',
							label = stash.target.label or 'Open Stash',
							job = stash.jobs,
							action = function()
								OpenStash({id=id})
							end
						},
					},
					distance = stash.target.distance or 3.0
				})
			end
		end
	end
})

client.inventory = Inventory