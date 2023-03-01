if not lib then return end

---@overload fun(name: string): OxServerItem
local Items = {}
local ItemList = shared.items
---@cast ItemList { [string]: OxServerItem }

TriggerEvent('ox_inventory:itemList', ItemList)

-- Slot count and maximum weight for containers
-- Whitelist and blacklist: ['item_name'] = true
Items.containers = {
	['paperbag'] = {
		size = {5, 1000},
		blacklist = {
			['testburger'] = true -- No burgers!
		}
	},
	['pizzabox'] = {
		size = {1, 1000},
		whitelist = {
			['pizza'] = true -- Pizza box for pizza only
		}
	}
}

-- Possible metadata when creating garbage
local trash = {
	{description = 'An old rolled up newspaper.', weight = 200, image = 'trash_newspaper'},
	{description = 'A discarded burger shot carton.', weight = 50, image = 'trash_burgershot'},
	{description = 'An empty soda can.', weight = 20, image = 'trash_can'},
	{description = 'A mouldy piece of bread.', weight = 70, image = 'trash_bread'},
	{description = 'An empty ciggarette carton.', weight = 10, image = 'trash_fags'},
	{description = 'A slightly used pair of panties.', weight = 20, image = 'panties'},
	{description = 'An empty coffee cup.', weight = 20, image = 'trash_coffee'},
	{description = 'A crumpled up piece of paper.', weight = 5, image = 'trash_paper'},
	{description = 'An empty chips bag.', weight = 5, image = 'trash_chips'},
}

---@param _ table?
---@param name string?
---@return table?
local function getItem(_, name)
	if name then
		name = name:lower()

		if name:sub(0, 7) == 'weapon_' then
			name = name:upper()
		end

		return ItemList[name]
	end

	return ItemList
end

setmetatable(Items --[[@as table]], {
	__call = getItem
})

-- Support both names
exports('Items', function(item) return getItem(nil, item) end)
exports('ItemList', function(item) return getItem(nil, item) end)

local Inventory

CreateThread(function()
	Inventory = server.inventory

	if shared.framework == 'esx' then
		local success, items = pcall(MySQL.query.await, 'SELECT * FROM items')

		if success and items and next(items) then
			local dump = {}
			local count = 0

			for i = 1, #items do
				local item = items[i]

				if not ItemList[item.name] then
					item.close = item.closeonuse == nil and true or item.closeonuse
					item.stack = item.stackable == nil and true or item.stackable
					item.description = item.description
					item.weight = item.weight or 0
					dump[i] = item
					count += 1
				end
			end

			if table.type(dump) ~= "empty" then
				local file = {string.strtrim(LoadResourceFile(shared.resource, 'data/items.lua'))}
				file[1] = file[1]:gsub('}$', '')

				local itemFormat = [[

	['%s'] = {
		label = '%s',
		weight = %s,
		stack = %s,
		close = %s,
		description = %s
	},
]]
				local fileSize = #file

				for _, item in pairs(dump) do
					local formatName = item.name:gsub("'", "\\'"):lower()
					if not ItemList[formatName] then
						fileSize += 1

						file[fileSize] = (itemFormat):format(formatName, item.label:gsub("'", "\\'"), item.weight, item.stack, item.close, item.description and json.encode(item.description) or 'nil')
						ItemList[formatName] = item
					end
				end

				file[fileSize+1] = '}'

				SaveResourceFile(shared.resource, 'data/items.lua', table.concat(file), -1)
				shared.info(count, 'items have been copied from the database.')
				shared.info('You should restart the resource to load the new items.')
			end

			shared.info('Database contains', #items, 'items.')

			warn('Some third-party resources may conflict with item and inventory data structure.\n')
		end

		Wait(500)

	elseif shared.framework == 'qb' then
		local QBCore = exports['qb-core']:GetCoreObject()
		local items = QBCore.Shared.Items

		if table.type(items) ~= "empty" then
			local dump = {}
			local count = 0
			local ignoreList = {
				"weapon_",
				"pistol_",
				"pistol50_",
				"revolver_",
				"smg_",
				"combatpdw_",
				"shotgun_",
				"rifle_",
				"carbine_",
				"gusenberg_",
				"sniper_",
				"snipermax_",
				"tint_",
				"_ammo"
			}

			local function checkIgnoredNames(name)
				for i = 1, #ignoreList do
					if string.find(name, ignoreList[i]) then
						return true
					end
				end
				return false
			end

			for k, item in pairs(items) do
				if not ItemList[item.name] and not checkIgnoredNames(item.name) then
					local oxItem = {
						name = item.name,
						label = item.label,
						close = item.shouldClose == nil and true or item.shouldClose,
						stack = not item.unique and true,
						description = item.description,
						weight = item.weight or 0,
					}

					local status = {}
					if item.hunger then
						status.hunger = item.hunger
					end
					if item.thirst then
						status.thirst = item.thirst
					end

					if next(status) then
						oxItem.client = {
							status = status
						}
					end

					dump[k] = oxItem
					count += 1
				end
			end

			if table.type(dump) ~= "empty" then
				local file = {string.strtrim(LoadResourceFile(shared.resource, 'data/items.lua'))}
				file[1] = file[1]:gsub('}$', '')

				local itemFormat = [[

	['%s'] = {
		label = '%s',
		weight = %s,
		stack = %s,
		close = %s,
		description = %s,
		status = %s,
	},
]]

				local v = "0.303" -- (C) 2012-18 Paul Kulchenko; MIT License
				local snum = {[tostring(1/0)]='1/0 --[[math.huge]]',[tostring(-1/0)]='-1/0 --[[-math.huge]]',[tostring(0/0)]='0/0'}
				local badtype = {thread = true, userdata = true, cdata = true}
				local getmetatable = debug and debug.getmetatable or getmetatable
				local pairs = function(t) return next, t end -- avoid using __pairs in Lua 5.2+
				local keyword, globals, G = {}, {}, (_G or _ENV)
				for _,k in ipairs({'and', 'break', 'do', 'else', 'elseif', 'end', 'false',
				'for', 'function', 'goto', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat',
				'return', 'then', 'true', 'until', 'while'}) do keyword[k] = true end
				for k,v in pairs(G) do globals[v] = k end -- build func to name mapping
				for _,g in ipairs({'coroutine', 'debug', 'io', 'math', 'string', 'table', 'os'}) do
				for k,v in pairs(type(G[g]) == 'table' and G[g] or {}) do globals[v] = g..'.'..k end end

				local function s(t, opts)
				local name, indent, fatal, maxnum = opts.name, opts.indent, opts.fatal, opts.maxnum
				local sparse, custom, huge = opts.sparse, opts.custom, not opts.nohuge
				local space, maxl = (opts.compact and '' or ' '), (opts.maxlevel or math.huge)
				local maxlen, metatostring = tonumber(opts.maxlength), opts.metatostring
				local iname, comm = '_'..(name or ''), opts.comment and (tonumber(opts.comment) or math.huge)
				local numformat = opts.numformat or "%.17g"
				local seen, sref, syms, symn = {}, {'local '..iname..'={}'}, {}, 0
				local function gensym(val) return '_'..(tostring(tostring(val)):gsub("[^%w]",""):gsub("(%d%w+)",
					-- tostring(val) is needed because __tostring may return a non-string value
					function(s) if not syms[s] then symn = symn+1; syms[s] = symn end return tostring(syms[s]) end)) end
				local function safestr(s) return type(s) == "number" and (huge and snum[tostring(s)] or numformat:format(s))
					or type(s) ~= "string" and tostring(s) -- escape NEWLINE/010 and EOF/026
					or ("%q"):format(s):gsub("\010","n"):gsub("\026","\\026") end
				-- handle radix changes in some locales
				if opts.fixradix and (".1f"):format(1.2) ~= "1.2" then
					local origsafestr = safestr
					safestr = function(s) return type(s) == "number"
					and (nohuge and snum[tostring(s)] or numformat:format(s):gsub(",",".")) or origsafestr(s)
					end
				end
				local function comment(s,l) return comm and (l or 0) < comm and ' --[['..select(2, pcall(tostring, s))..']]' or '' end
				local function globerr(s,l) return globals[s] and globals[s]..comment(s,l) or not fatal
					and safestr(select(2, pcall(tostring, s))) or error("Can't serialize "..tostring(s)) end
				local function safename(path, name) -- generates foo.bar, foo[3], or foo['b a r']
					local n = name == nil and '' or name
					local plain = type(n) == "string" and n:match("^[%l%u_][%w_]*$") and not keyword[n]
					local safe = plain and n or '['..safestr(n)..']'
					return (path or '')..(plain and path and '.' or '')..safe, safe end
				local alphanumsort = type(opts.sortkeys) == 'function' and opts.sortkeys or function(k, o, n) -- k=keys, o=originaltable, n=padding
					local maxn, to = tonumber(n) or 12, {number = 'a', string = 'b'}
					local function padnum(d) return ("%0"..tostring(maxn).."d"):format(tonumber(d)) end
					table.sort(k, function(a,b)
					-- sort numeric keys first: k[key] is not nil for numerical keys
					return (k[a] ~= nil and 0 or to[type(a)] or 'z')..(tostring(a):gsub("%d+",padnum))
						< (k[b] ~= nil and 0 or to[type(b)] or 'z')..(tostring(b):gsub("%d+",padnum)) end) end
				local function val2str(t, name, indent, insref, path, plainindex, level)
					local ttype, level, mt = type(t), (level or 0), getmetatable(t)
					local spath, sname = safename(path, name)
					local tag = plainindex and
					((type(name) == "number") and '' or name..space..'='..space) or
					(name ~= nil and sname..space..'='..space or '')
					if seen[t] then -- already seen this element
					sref[#sref+1] = spath..space..'='..space..seen[t]
					return tag..'nil'..comment('ref', level)
					end
					-- protect from those cases where __tostring may fail
					if type(mt) == 'table' and metatostring ~= false then
					local to, tr = pcall(function() return mt.__tostring(t) end)
					local so, sr = pcall(function() return mt.__serialize(t) end)
					if (to or so) then -- knows how to serialize itself
						seen[t] = insref or spath
						t = so and sr or tr
						ttype = type(t)
					end -- new value falls through to be serialized
					end
					if ttype == "table" then
					if level >= maxl then return tag..'{}'..comment('maxlvl', level) end
					seen[t] = insref or spath
					if next(t) == nil then return tag..'{}'..comment(t, level) end -- table empty
					if maxlen and maxlen < 0 then return tag..'{}'..comment('maxlen', level) end
					local maxn, o, out = math.min(#t, maxnum or #t), {}, {}
					for key = 1, maxn do o[key] = key end
					if not maxnum or #o < maxnum then
						local n = #o -- n = n + 1; o[n] is much faster than o[#o+1] on large tables
						for key in pairs(t) do
						if o[key] ~= key then n = n + 1; o[n] = key end
						end
					end
					if maxnum and #o > maxnum then o[maxnum+1] = nil end
					if opts.sortkeys and #o > maxn then alphanumsort(o, t, opts.sortkeys) end
					local sparse = sparse and #o > maxn -- disable sparsness if only numeric keys (shorter output)
					for n, key in ipairs(o) do
						local value, ktype, plainindex = t[key], type(key), n <= maxn and not sparse
						if opts.valignore and opts.valignore[value] -- skip ignored values; do nothing
						or opts.keyallow and not opts.keyallow[key]
						or opts.keyignore and opts.keyignore[key]
						or opts.valtypeignore and opts.valtypeignore[type(value)] -- skipping ignored value types
						or sparse and value == nil then -- skipping nils; do nothing
						elseif ktype == 'table' or ktype == 'function' or badtype[ktype] then
						if not seen[key] and not globals[key] then
							sref[#sref+1] = 'placeholder'
							local sname = safename(iname, gensym(key)) -- iname is table for local variables
							sref[#sref] = val2str(key,sname,indent,sname,iname,true)
						end
						sref[#sref+1] = 'placeholder'
						local path = seen[t]..'['..tostring(seen[key] or globals[key] or gensym(key))..']'
						sref[#sref] = path..space..'='..space..tostring(seen[value] or val2str(value,nil,indent,path))
						else
						out[#out+1] = val2str(value,key,indent,nil,seen[t],plainindex,level+1)
						if maxlen then
							maxlen = maxlen - #out[#out]
							if maxlen < 0 then break end
						end
						end
					end
					local prefix = string.rep(indent or '', level)
					local head = indent and '{\n'..prefix..indent or '{'
					local body = table.concat(out, ','..(indent and '\n'..prefix..indent or space))
					local tail = indent and "\n"..prefix..'}' or '}'
					return (custom and custom(tag,head,body,tail,level) or tag..head..body..tail)..comment(t, level)
					elseif badtype[ttype] then
					seen[t] = insref or spath
					return tag..globerr(t, level)
					elseif ttype == 'function' then
					seen[t] = insref or spath
					if opts.nocode then return tag.."function() --[[..skipped..]] end"..comment(t, level) end
					local ok, res = pcall(string.dump, t)
					local func = ok and "((loadstring or load)("..safestr(res)..",'@serialized'))"..comment(t, level)
					return tag..(func or globerr(t, level))
					else return tag..safestr(t) end -- handle all other types
				end
				local sepr = indent and "\n" or ";"..space
				local body = val2str(t, name, indent) -- this call also populates sref
				local tail = #sref>1 and table.concat(sref, sepr)..sepr or ''
				local warn = opts.comment and #sref>1 and space.."--[[incomplete output with shared/self-references skipped]]" or ''
				return not name and body..warn or "do local "..body..sepr..tail.."return "..name..sepr.."end"
				end

				local function merge(a, b) if b then for k,v in pairs(b) do a[k] = v end end; return a; end
				function SerpentBlock(a, opts)
					return s(a, merge({indent = '  ', sortkeys = function(k, o)
					local order = {"one", "two", "three", "four", "five", "six"}
					table.sort(k, function(one, two)
						local oneI = 0
						local twoI = 0
						for i=1, #order do
							if order[i] == one then
								oneI = i
							end
							if order[i] == two then
								twoI = i
							end
							if oneI ~= 0 and twoI ~= 0 then
								break
							end
						end
						return oneI < twoI
					end)
					end}, opts))
				end

				local fileSize = #file

				local serpent = require("serpent")
				for _, item in pairs(dump) do
					local formatName = item.name:gsub("'", "\\'"):lower()
					if not ItemList[formatName] then
						fileSize += 1
						file[fileSize] = serpent.block(item)
						-- file[fileSize] = (itemFormat):format(formatName, item.label:gsub("'", "\\'"), item.weight, item.stack, item.close, item.description and json.encode(item.description) or 'nil', item.status and json.encode(item.status) or 'nil')
						ItemList[formatName] = item
					end
				end

				file[fileSize+1] = '}'

				SaveResourceFile(shared.resource, 'data/items.lua', table.concat(file), -1)
				shared.info(count, 'items have been copied from the QBCore.Shared.Items.')
				shared.info('You should restart the resource to load the new items.')
			end
		end

		Wait(500)
	end

	local clearStashes = GetConvar('inventory:clearstashes', '6 MONTH')

	if clearStashes ~= '' then
		pcall(MySQL.query.await, ('DELETE FROM ox_inventory WHERE lastupdated < (NOW() - INTERVAL %s) OR data = "[]"'):format(clearStashes))
	end

	local count = 0

	Wait(1000)

	for _ in pairs(ItemList) do
		count += 1
	end

	shared.info(('Inventory has loaded %d items'):format(count))
	collectgarbage('collect') -- clean up from initialisation
	shared.ready = true
end)

local function GenerateText(num)
	local str
	repeat str = {}
		for i = 1, num do str[i] = string.char(math.random(65, 90)) end
		str = table.concat(str)
	until str ~= 'POL' and str ~= 'EMS'
	return str
end

local function GenerateSerial(text)
	if text and text:len() > 3 then
		return text
	end

	return ('%s%s%s'):format(math.random(100000,999999), text == nil and GenerateText(3) or text, math.random(100000,999999))
end

local function setItemDurability(item, metadata)
	local degrade = item.degrade

	if degrade then
		metadata.durability = os.time()+(degrade * 60)
		metadata.degrade = degrade
	elseif item.durability then
		metadata.durability = 100
	end

	return metadata
end

function Items.Metadata(inv, item, metadata, count)
	if type(inv) ~= 'table' then inv = Inventory(inv) end
	if not item.weapon then metadata = not metadata and {} or type(metadata) == 'string' and {type=metadata} or metadata end
	if not count then count = 1 end

	if item.weapon then
		if type(metadata) ~= 'table' then metadata = {} end
		if not metadata.durability then metadata.durability = 100 end
		if not metadata.ammo and item.ammoname then metadata.ammo = 0 end
		if not metadata.components then metadata.components = {} end

		if metadata.registered ~= false and (metadata.ammo or item.name == 'WEAPON_STUNGUN') then
			local registered = type(metadata.registered) == 'string' and metadata.registered or inv?.player?.name

			if registered then
				metadata.registered = registered
				metadata.serial = GenerateSerial(metadata.serial)
			else
				metadata.registered = nil
			end
		end

		if item.hash == `WEAPON_PETROLCAN` or item.hash == `WEAPON_HAZARDCAN` or item.hash == `WEAPON_FERTILIZERCAN` or item.hash == `WEAPON_FIREEXTINGUISHER` then
			metadata.ammo = metadata.durability
		end
	else
		local container = Items.containers[item.name]

		if container then
			count = 1
			metadata.container = metadata.container or GenerateText(3)..os.time()
			metadata.size = container.size
		elseif not next(metadata) then
			if item.name == 'identification' then
				count = 1
				metadata = {
					type = inv.player.name,
					description = locale('identification', (inv.player.sex) and locale('male') or locale('female'), inv.player.dateofbirth)
				}
			elseif item.name == 'garbage' then
				local trashType = trash[math.random(1, #trash)]
				metadata.image = trashType.image
				metadata.weight = trashType.weight
				metadata.description = trashType.description
			end
		end

		if not metadata.durability then
			metadata = setItemDurability(ItemList[item.name], metadata)
		end
	end

	if count > 1 and not item.stack then
		count = 1
	end

	local response = TriggerEventHooks('createItem', {
		inventoryId = inv and inv.id,
		metadata = metadata,
		item = item,
		count = count,
	})

	if type(response) == 'table' then
		metadata = response
	end

	if metadata.imageurl and Utils.IsValidImageUrl then
		if Utils.IsValidImageUrl(metadata.imageurl) then
			Utils.DiscordEmbed('Valid image URL', ('Created item "%s" (%s) with valid url in "%s".\n%s\nid: %s\nowner: %s'):format(metadata.label or item.label, item.name, inv.label, metadata.imageurl, inv.id, inv.owner, metadata.imageurl), metadata.imageurl, 65280)
		else
			Utils.DiscordEmbed('Invalid image URL', ('Created item "%s" (%s) with invalid url in "%s".\n%s\nid: %s\nowner: %s'):format(metadata.label or item.label, item.name, inv.label, metadata.imageurl, inv.id, inv.owner, metadata.imageurl), metadata.imageurl, 16711680)
			metadata.imageurl = nil
		end
	end

	return metadata, count
end

function Items.CheckMetadata(metadata, item, name, ostime)
	if metadata.bag then
		metadata.container = metadata.bag
		metadata.size = Items.containers[name]?.size or {5, 1000}
		metadata.bag = nil
	end

	local durability = metadata.durability

	if durability then
		if durability > 100 and ostime >= durability then
			metadata.durability = 0
		end
	else
		metadata = setItemDurability(item, metadata)
	end

	if metadata.components then
		if table.type(metadata.components) == 'array' then
			for i = #metadata.components, 1, -1 do
				if not ItemList[metadata.components[i]] then
					table.remove(metadata.components, i)
				end
			end
		else
			local components = {}
			local size = 0

			for _, component in pairs(metadata.components) do
				if component and ItemList[component] then
					size += 1
					components[size] = component
				end
			end

			metadata.components = components
		end
	end

	if metadata.serial and item.weapon and not item.ammoname then
		metadata.serial = nil
	end

	return metadata
end

local function Item(name, cb)
	local item = ItemList[name]

	if item and not item.cb then
		item.cb = cb
	end
end

-----------------------------------------------------------------------------------------------
-- Serverside item functions
-----------------------------------------------------------------------------------------------

-- Item('testburger', function(event, item, inventory, slot, data)
-- 	if event == 'usingItem' then
-- 		if Inventory.GetItem(inventory, item, inventory.items[slot].metadata, true) > 0 then
-- 			-- if we return false here, we can cancel item use
-- 			return {
-- 				inventory.label, event, 'external item use poggies'
-- 			}
-- 		end

-- 	elseif event == 'usedItem' then
-- 		print(('%s just ate a %s from slot %s'):format(inventory.label, item.label, slot))

-- 	elseif event == 'buying' then
-- 		print(data.id, data.coords, json.encode(data.items[slot], {indent=true}))
-- 	end
-- end)

-----------------------------------------------------------------------------------------------

server.items = Items
