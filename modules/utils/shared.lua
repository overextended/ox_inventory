local M = {}

M.CheckTable = function(table, value)
	for _, v in pairs(table) do
		if v == value then return true end
	end
	return false
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

M.TableContains = function(t1, t2)
	if next(t1) then
		if type(t2) == 'string' then
			if table.type == value then return true end
		else
			local match, values = {}, 0
			for _, v1 in pairs(t2) do
				values += 1
				local size = #match
				for _, v2 in pairs(t1) do
					if v1 == v2 then match[size+1] = true end
				end
			end
			if #match == values then return true end
		end
	end
	return false
end
exports('TableContains', M.TableContains)

return M