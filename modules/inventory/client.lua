local Utils <const> = module('utils')

local Dumpsters = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}

if Config.Target then

	local OpenDumpster = function(entity)
		local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity) or false
		if netId == false then
			SetEntityAsMissionEntity(entity)
			NetworkRegisterEntityAsNetworked(entity)
			netId = NetworkGetNetworkIdFromEntity(entity)
			NetworkUseHighPrecisionBlending(netId, false)
			SetNetworkIdExistsOnAllMachines(netId)
			SetNetworkIdCanMigrate(netId, true)
		end
		TriggerEvent('ox_inventory:openInventory', 'dumpster', {id='dumpster'..netId})
	end

	exports.qtarget:AddTargetModel(Dumpsters, {
		options = {
			{
				icon = "fas fa-dumpster",
				label = ox.locale('search_dumpster'),
				action = function(entity)
					OpenDumpster(entity)
				end
			},
		},
		distance = 2
	})

end

local Search = function(search, item, metadata)
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
			for _, v in pairs(ESX.PlayerData.inventory) do
				if v.name == item then
					if not v.metadata then v.metadata = {} end
					if not metadata or Utils.TableContains(v.metadata, metadata) then
						if search == 1 then returnData[item][#returnData[item]+1] = ESX.PlayerData.inventory[v.slot]
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

exports('Search', Search)

return {
	Dumpsters = Dumpsters, Search = Search
}
