local Inventory = {}

Inventory.Dumpsters = { 218085040, 666561306, -58485588, -206690185, 1511880420, 682791951, `prop_bin_07b`, `prop_bin_06a`, `prop_bin_08a`, `prop_bin_03a`, `prop_recyclebin_02_d`, `prop_bin_beach_01d`, `prop_bin_08open`, `prop_bin_12a`, `prop_bin_05a`, `prop_bin_07a`, `prop_bin_beach_01a`, `prop_recyclebin_02_c`, `zprop_bin_01a_old`, `prop_bin_14a`, `prop_postbox_01a`, `prop_bin_01a`, `prop_recyclebin_04_a`, `prop_bin_beach_01a`, `prop_recyclebin_02_c`, `prop_bin_01a_old`, `prop_recyclebin_03_a`, `prop_bin_07c`, `prop_bin_10b`, `prop_bin_14a`, `prop_bin_10a`, `prop_bin_07d`, `prop_recyclebin_01a`, `prop_skid_trolley_2`, `prop_skid_trolley_1`, `prop_bin_04a`, `prop_bin_02a` }
Inventory.FoodStash = { `prop_bbq_5`, `prop_bbq_1`, `prop_bbq_4_l1`, `prop_bbq_4`, `v_res_tre_fridge`, `prop_cooker_03`, `v_ret_fh_dryer`, `prop_micro_04`, `v_res_fridgemodsml`, `prop_fridge_03`, `prop_micro_01`, `prop_fridge_01`, `prop_micro_02`, `v_res_fridgemoda`, `prop_hotdogstand_01`, `prop_burgerstand_01`}

if shared.qtarget then
	local function OpenDumpster(entity)
		local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity)

		if not netId then
			NetworkRegisterEntityAsNetworked(entity)
			SetEntityAsMissionEntity(entity)
			netId = NetworkGetNetworkIdFromEntity(entity)
			NetworkUseHighPrecisionBlending(netId, false)
			SetNetworkIdExistsOnAllMachines(netId, true)
			SetNetworkIdCanMigrate(netId, true)
		end

		exports.ox_inventory:openInventory('dumpster', 'dumpster'..netId)
	end
	
	exports.qtarget:AddTargetModel(Inventory.Dumpsters, {
		options = {
			{
				icon = 'fas fa-dumpster',
				label = shared.locale('search_dumpster'),
				action = function(entity)
					OpenDumpster(entity)
				end
			},
		},
		distance = 2
	})
	
	local function OpenFoodStash(entity)
		local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity)

		if not netId then
			NetworkRegisterEntityAsNetworked(entity)
			SetEntityAsMissionEntity(entity)
			netId = NetworkGetNetworkIdFromEntity(entity)
			NetworkUseHighPrecisionBlending(netId, false)
			SetNetworkIdExistsOnAllMachines(netId, true)
			SetNetworkIdCanMigrate(netId, true)
		end

		exports.ox_inventory:openInventory('food', 'foodstash_'..netId)
	end
	
	exports.qtarget:AddTargetModel(Inventory.FoodStash, {
		options = {
			{
				icon = 'fas fa-hamburger',
				label = shared.locale('search'),
				action = function(entity)
					OpenFoodStash(entity)
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

local function OpenEvidence()
	exports.ox_inventory:openInventory('policeevidence')
end

Inventory.Evidence = setmetatable(data('evidence'), {
	__call = function(self)
		for _, evidence in pairs(self) do
			if shared.qtarget then
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
							label = shared.locale('open_police_evidence'),
							job = shared.police,
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
			if stash.jobs then stash.groups = stash.jobs end

			if shared.qtarget and stash.target then
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
							icon = stash.target.icon or 'fas fa-warehouse',
							label = stash.target.label or shared.locale('open_stash'),
							job = stash.groups,
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
