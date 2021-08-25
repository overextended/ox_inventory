local M = {}

M.CheckTable = function(table, value)
	for k, v in pairs(table) do
		if v == value then return true end
	end
	return false
end

M.Copy = function(t, deep)
	local copy = {}
	if type(t) == 'table' then
		for k,v in pairs(t) do
			if type(v) == 'table' then
				if deep then
					copy[M.Copy(t, true)] = M.Copy(t, true)
					setmetatable(copy, M.Copy(getmetatable(t)))
				else copy[k] = M.Copy(v) end
			else
				if type(v) == 'function' then v = nil end
				copy[k] = v
			end
		end
	else copy = t end
	return copy
end

M.MatchTables = function(t1,t2)
	t1, t2 = t1 or {}, t2 or {}
	local ty1 = type(t1)
	local ty2 = type(t2)
	if ty1 ~= ty2 then return false end
	if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
	for k1,v1 in pairs(t1) do
	   local v2 = t2[k1]
	   if v2 == nil or not M.MatchTables(v1,v2) then return false end
	end
	for k2,v2 in pairs(t2) do
	   local v1 = t1[k2]
	   if v1 == nil or not M.MatchTables(v1,v2) then return false end
	end
	return true
end
exports('MatchTables', M.MatchTables)

M.TableContains = function(table, value)
	table = table or {}
	if type(value) == 'string' then
		if table.type == value then return true end
	else
		local match = {}
		local values = 0
		for k1, v1 in pairs(value) do
			values = values + 1
			local size = #match
			for k2, v2 in pairs(table) do
				if v1 == v2 then
					match[size+1] = true
				end
			end
		end
		if #match == values then return true else return false end
	end
end
exports('TableContains', M.TableContains)

if not ox.server then
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
	exports('SearchItems', function(item, metadata)
		return InventorySearch(1, item, metadata)
	end)
	
	exports('CountItems', function(item, metadata)
		return InventorySearch(2, item, metadata)
	end)
end

return M
