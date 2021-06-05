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

local SearchItems = function(item, metadata)
	if item then
		local getType = type(item)
		if getType == 'string' then
			item = string.lower(item)
			if item:find('weapon_') then item = string.upper(item) end
			local returnData = {count=0, slots={}}
			if type(metadata) == 'string' then metadata = {type=metadata} end
			for k, v in pairs(ESX.PlayerData.inventory) do
				if v.name == item then
					if not v.metadata then v.metadata = {} end
					if not metadata or is_table_equal(v.metadata, metadata) then
						returnData.count = returnData.count + v.count
						returnData.slots[#returnData.slots+1] = v.slot
					end
				end
			end
			if returnData.count > 0 then return returnData end
		elseif getType == 'table' then
			local returnData = {}
			for i=1, #item do
				item[i] = string.lower(item[i])
				if item[i]:find('weapon_') then item[i] = string.upper(item[i]) end
				returnData[i] = {count=0, slots={}}
				if type(metadata) == 'string' then metadata = {type=metadata} end
				for k, v in pairs(ESX.PlayerData.inventory) do
					if v.name == item[i] then
						if not v.metadata then v.metadata = {} end
						if not metadata or is_table_equal(v.metadata, metadata) then
							returnData[i].count = returnData[i].count + v.count
							returnData[i].slots[#returnData[i].slots+1] = v.slot
						end
					end
				end
			end
			if next(returnData) then return returnData end
		end
	end
	return false
end
exports('SearchItems', SearchItems)

--[[	Example usage
RegisterCommand('test', function(source, args, rawCommand)
	local inventory = ESX.GetPlayerData().inventory
	local data = exports['linden_inventory']:SearchItems({'weapon_pistol', 'water'}, args[2])
	local getType = type(data)
	if getType == 'string' then
		print('You have '..data.count..'x '..args[1]..' in '..#data.slots.. ' slots')
		for k,v in pairs(data.slots) do
			local slotItem = inventory[v]
			print(slotItem.label, slotItem.slot, slotItem.count)
			for a,b in next, slotItem.metadata do
				print(a, b)
			end
		end
	elseif getType == 'table' then
		for i=1, #data do
			for k,v in pairs(data[i].slots) do
				local slotItem = inventory[v]
				print(slotItem.label, slotItem.slot, slotItem.count)
				for a,b in next, slotItem.metadata do
					print(a, b)
				end
			end
		end
	end
end)
--]]
