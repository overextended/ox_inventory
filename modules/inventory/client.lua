local M = {}

M.Dumpsters = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}

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

	exports.qtarget:AddTargetModel(M.Dumpsters, {
		options = {
			{
				icon = "fas fa-dumpster",
				label = "Search Dumpster",
				action = function(entity)
					OpenDumpster(entity)
				end
			},
		},
		distance = 2
	})

end

return M