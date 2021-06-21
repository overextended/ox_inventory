exports('ItemCancelled', function()
	return cancelled
end)

is_table_equal = function(t1,t2)
	local ty1 = type(t1)
	local ty2 = type(t2)
	if ty1 ~= ty2 then return false end
	if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
	for k1,v1 in pairs(t1) do
	   local v2 = t2[k1]
	   if v2 == nil or not is_table_equal(v1,v2) then return false end
	end
	for k2,v2 in pairs(t2) do
	   local v1 = t1[k2]
	   if v1 == nil or not is_table_equal(v1,v2) then return false end
	end
	return true
end
exports('MatchTables', is_table_equal)

table_contains = function(table, value)
	if type(value) == 'string' then
		if table.type == value then return true end
	else
		local match = {}
		local values = 0
		for k1, v1 in pairs(value) do
			values = values + 1
			for k2, v2 in pairs(table) do
				if v1 == v2 then
					match[#match+1] = true
				end
			end
		end
		if #match == values then return true else return false end
	end
end
exports('TableContains', table_contains)

InventorySearch = function(func, item, metadata)
	if item then
		if type(item) == 'string' then item = {item} end
		if type(metadata) == 'string' then metadata = {type=metadata} end
		local returnData = {}
		for i=1, #item do
			local item = string.lower(item[i])
			if item:find('weapon_') then item = string.upper(item) end
			if func == 1 then returnData[item] = {}
			elseif func == 2 then returnData[item] = 0 end
			for k, v in pairs(ESX.PlayerData.inventory) do
				if v.name == item then
					if not v.metadata then v.metadata = {} end
					if not metadata or table_contains(v.metadata, metadata) then
						if func == 1 then table.insert(returnData[item], ESX.PlayerData.inventory[v.slot])
						elseif func == 2 then
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

