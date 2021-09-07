local M = module('utils', true)

M.PlayAnim = function(wait, ...)
	local args = {...}
	RequestAnimDict(args[1])
	CreateThread(function()
		repeat Wait(10) until HasAnimDictLoaded(args[1])
		TaskPlayAnim(ESX.PlayerData.ped, table.unpack(args))
		Wait(wait)
		ClearPedSecondaryTask(ESX.PlayerData.ped)
		RemoveAnimDict(args[1])
	end)
end

M.PlayAnimAdvanced = function(wait, ...)
	local args = {...}
	RequestAnimDict(args[1])
	CreateThread(function()
		repeat Wait(10) until HasAnimDictLoaded(args[1])
		TaskPlayAnimAdvanced(ESX.PlayerData.ped, table.unpack(args))
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(ESX.PlayerData.ped) end
		RemoveAnimDict(args[1])
	end)
end

M.InventorySearch = function(search, item, metadata)
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
			for k, v in pairs(ESX.PlayerData.inventory) do
				if v.name == item then
					if not v.metadata then v.metadata = {} end
					if not metadata or M.TableContains(v.metadata, metadata) then
						if search == 1 then table.insert(returnData[item], ESX.PlayerData.inventory[v.slot])
						elseif search == 2 then
							returnData[item] = returnData[item] + v.count
						end
					end
				end
			end
		end
		if next(returnData) then return items == 1 and returnData[item[1]] or returnData end
	end
	return false
end
exports('InventorySearch', M.InventorySearch)

return M
