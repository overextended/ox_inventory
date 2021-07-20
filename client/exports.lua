exports('ItemCancelled', function()
	return cancelled
end)

InventorySearch = function(search, item, metadata)
	if item then
		if type(item) == 'string' then item = {item} end
		if type(metadata) == 'string' then metadata = {type=metadata} end
		local returnData = {}
		for i=1, #item do
			local item = string.lower(item[i])
			if item:find('weapon_') then item = string.upper(item) end
			if search == 1 then returnData[item] = {}
			elseif search == 2 then returnData[item] = 0 end
			for k, v in pairs(ESX.PlayerData.inventory) do
				if v.name == item then
					if not v.metadata then v.metadata = {} end
					if not metadata or func.tablecontains(v.metadata, metadata) then
						if search == 1 then table.insert(returnData[item], ESX.PlayerData.inventory[v.slot])
						elseif search == 2 then
							returnData[item] = returnData[item] + v.count
						end
					end
				end
			end
		end
		if next(returnData) then return returnData end
	end
	return false
end

SearchItems = function(item, metadata)
	return InventorySearch(1, item, metadata)
end
exports('SearchItems', SearchItems)

CountItems = function(item, metadata)
	return InventorySearch(2, item, metadata)
end
exports('CountItems', CountItems)

-- RegisterCommand('count', function(source, args, rawCommand)
-- 	local inventory = exports['linden_inventory']:CountItems({'meat', 'skin'}--[[, {grade=1}]])
-- 	if inventory then
-- 		for name, count in pairs(inventory) do
-- 			print('You have '..count.. ' '..name)
-- 		end
-- 	end
-- end)


-- RegisterCommand('search', function(source, args, rawCommand)
-- 	local inventory = exports['linden_inventory']:SearchItems({'meat', 'skin'}--[[, {grade=1}]])
-- 	if inventory then
-- 		for name, data in pairs(inventory) do
-- 			local count = 0
-- 			for _, v in pairs(data) do
-- 				if v.slot then
-- 					print(v.slot..' contains '..v.count..' '..name..' '..json.encode(v.metadata))
-- 					count = count + v.count
-- 				end
-- 			end
-- 			print('You have '..count.. ' '..name)
-- 		end
-- 	end
-- end)

