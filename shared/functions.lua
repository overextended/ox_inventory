func = {}

func.trim = function(string)
	return string:match("^%s*(.-)%s*$")
end

func.checktable = function(table, value)
	for k, v in pairs(table) do
		if v == value then return true end
	end
	return false
end

func.matchtables = function(t1,t2)
	local ty1 = type(t1)
	local ty2 = type(t2)
	if ty1 ~= ty2 then return false end
	if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
	for k1,v1 in pairs(t1) do
	   local v2 = t2[k1]
	   if v2 == nil or not func.matchtables(v1,v2) then return false end
	end
	for k2,v2 in pairs(t2) do
	   local v1 = t1[k2]
	   if v1 == nil or not func.matchtables(v1,v2) then return false end
	end
	return true
end
exports('MatchTables', func.matchtables)

func.tablecontains = function(table, value)
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
exports('TableContains', func.tablecontains)