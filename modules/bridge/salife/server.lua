---@todo separate module into smaller submodules to handle each framework
---starting to get bulky
local Tunnel = module("salrp", "lib/Tunnel")
local Proxy = module("salrp", "lib/Proxy")

salrpi = {}
salrp = Proxy.getInterface("salrp")
salrpclient = Tunnel.getInterface("salrp", "ox_inventory")
Iclient = Tunnel.getInterface("ox_inventory")
Tunnel.bindInterface("ox_inventory",salrpi)
Proxy.addInterface("ox_inventory",salrpi)

local playerDropped = ...
local Inventory, Items

CreateThread(function()
	Inventory = require 'modules.inventory.server'
	Items = require 'modules.items.server'
end)

--AddEventHandler('salrp:playerLeave', function(user_id, source) playerDropped(source) end)
AddEventHandler('salrp:playerLeave', function(user_id, source) server.playerDropped(source) end)
-- server.playerDropped

--[[AddEventHandler('salrp:playerJoinGroup', function(user_id, group, gtype)
	local inventory = Inventory(source)
	if not inventory then return end
	inventory.player.groups[inventory.player.job] = nil 
	inventory.player.job = group
	inventory.player.groups[group] = 1
end)
AddEventHandler('salrp:playerLeaveGroup', function(user_id, group, gtype)
	local inventory = Inventory(source)
	if not inventory then return end
	inventory.player.groups[inventory.player.job] = nil
	inventory.player.job = group
	inventory.player.groups[group] = 1
end)]]

server.GetPlayerFromId = function(id)
	local identifier = salrp.getUserId(id)
	local identity = salrp.getUserIdentity(identifier)
	local name = identity.firstname .. " " .. identity.name
	local source = id
	return {
		source = source,
		name = name,
		identifier = identifier
	}
end 

SetTimeout(1000, function()
	server.GetPlayerFromId = function(id)
		local identifier = salrp.getUserId(id)
		local identity = salrp.getUserIdentity(identifier)
		local name = identity.firstname .. " " .. identity.name
		local source = id

		local g = salrp.getUserGroups(identifier)

		local groups = {
			--[player.job.name] = player.job.grade
		}

		for k,v in pairs(g) do
			groups[k] = 1
			--print("groups", k, 1)
		end

		local jobdata = Player(source).state["salife_oxinv:jobdata"]
		while jobdata == nil do jobdata = Player(source).state["salife_oxinv:jobdata"] Wait(0) end
		for k,v in pairs(jobdata.jobs)do
			groups[k] = v.rank
		end

		return {
			source = source,
			name = name,
			identifier = identifier,
			groups = groups
		}
	end 
	local users = SAL:getUsers()
	for uid,src in pairs(users) do
		--local inventory = salrp.getInventory(uid)
		local id = salrp.getUserIdentity(uid)

		local g = salrp.getUserGroups(uid) or {}

		local groups = {
			--[player.job.name] = player.job.grade
		}

		for k,v in pairs(g) do
			groups[k] = 1
			--print("groups", k, 1)
		end

		local jobdata = Player(src).state["salife_oxinv:jobdata"]
		while jobdata == nil do jobdata = Player(src).state["salife_oxinv:jobdata"] Wait(0) end
		while jobdata == nil do Wait(0) end
		for k,v in pairs(jobdata.jobs)do
			groups[k] = v.rank
		end



		local weight = 30000
		while not Player(src).state["salplus"] do Wait(100) end
		if Player(src).state["salplus"] and Player(src).state["salplus"] > 0 then
			weight = weight + 30000
		end
		--local str = exports.salife_oxinv:getSkillLvl(src, 'strength')
		--weight = weight + (str * 200)
		Player(src).state['ox_inventory:maxweight'] = math.floor(weight)

		local id = salrp.getUserIdentity(uid)

		server.setPlayerInventory({source = src, identifier = uid, name = id.firstname .. " " .. id.name, groups = groups})
	end
end)

server.accounts = {
	money = 0,
}

function server.hasGroup(inv, group)
	print('has group bridge', inv, group)
	--print(json.encode(inv, {indent=true}))
	print(json.encode(group, {indent=true}))
	local source = inv.player.source
	if not source then return false end

	local user_id = Player(source).state.user_id

	local groups = {}
	local g = salrp.getUserGroups(user_id)
	local groups = {
		--[player.job.name] = player.job.grade
	}

	print(inv, group, 'hasgroup')

	for k,v in pairs(g) do
		groups[k] = 0
		--print("groups", k, 1)
	end

	local jobdata = Player(source).state["salife_oxinv:jobdata"]
	while jobdata == nil do jobdata = Player(source).state["salife_oxinv:jobdata"] Wait(0) end
	while jobdata == nil do Wait(0) end
	for k,v in pairs(jobdata.jobs) do
		groups[k] = v.rank
	end

	if type(group) == 'table' then
		print(json.encode(group, {indent=true}))
		for name, rank in pairs(group) do
			local groupRank = exports.salife_oxinv:GetJobRank(user_id, name)
			if groupRank and groupRank >= rank then
				return name, groupRank
			end
			if groups[name] and groups[name] >= rank then
				return name, groups[name]
			end
		end
	else
		local groupRank = exports.salife_oxinv:GetJobRank(user_id, group)
		if groupRank then
			return group, groupRank
		end
		
		if groups[group] and groups[group] >= 0 then
			return group, groups[group]
		end
	end
end

function server.setPlayerData(player)
	local user_id = player.identifier
	local g = salrp.getUserGroups(user_id) or {}

	local groups = {
		--[player.job.name] = player.job.grade
	}

	for k,v in pairs(g) do
		groups[k] = 1
		--print("groups", k, 1)
	end

	local jobdata = Player(player.source).state["salife_oxinv:jobdata"]
	while jobdata == nil do jobdata = Player(player.source).state["salife_oxinv:jobdata"] Wait(0) end
	while jobdata == nil do Wait(0) end
	for k,v in pairs(jobdata.jobs)do
		groups[k] = v.rank
	end


	local id = salrp.getUserIdentity(user_id)

	return {
		source = player.source,
		identifier = user_id,
		name = id.firstname .. " " .. id.name,
		groups = groups,
		--sex = "male",
		--dateofbirth = "01/01/1990",
	}
end

--[[function server.syncInventory(inv)
	local money = table.clone(server.accounts)

	for _, v in pairs(inv.items) do
		--print(v.name)
		if money[v.name] then
			money[v.name] += v.count
		end
	end

	local player = server.GetPlayerFromId(inv.id)
	player.syncInventory(inv.weight, inv.maxWeight, inv.items, money)
end]]

--[[function server.convertInventory(playerId, items)
	--print("convert inventory salife", playerId, items)
	if type(items) == 'table' then
		local user_id = server.GetPlayerFromId(playerId)
		local returnData, totalWeight = table.create(#items, 0), 0
		local slot = 0

		--[[if user_id then
			for name in pairs(server.accounts) do
				if not items[name] then
					local account = player.getAccount(name)

					if account.money then
						items[name] = account.money
					end
				end
			end
		end]

		for name, v in pairs(items) do
			--print(name, v)
			local item = Items(name)

			if item and v.amount > 0 then
				local metadata = Items.Metadata(playerId, item, false, v.amount)
				local weight = Inventory.SlotWeight(item, {count=v.amount, metadata=metadata})
				totalWeight = totalWeight + weight
				slot += 1
				returnData[slot] = {name = item.name, label = item.label, weight = weight, slot = slot, count = v.amount, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
			end
		end

		return returnData, totalWeight
	end
end]]

AddEventHandler("ox_inventory:salplusMe", function(user_id, source)
	Inventory.Save(source)
	local id = salrp.getUserIdentity(user_id)

	local g = salrp.getUserGroups(user_id)

	local groups = {
		--[player.job.name] = player.job.grade
	}

	for k,v in pairs(g) do
		groups[k] = 1
		--print("groups", k, 1)
	end

	local jobdata = Player(source).state["salife_oxinv:jobdata"]
	while jobdata == nil do jobdata = Player(source).state["salife_oxinv:jobdata"] Wait(0) end

	for k,v in pairs(jobdata.jobs)do
		groups[k] = v.rank
	end

	local weight = 30000
	if Player(source).state["salplus"] and Player(source).state["salplus"] > 0 then
		weight = weight + 30000
	end
	--local str = exports.salife_oxinv:getSkillLvl(source, 'strength')
	--weight = weight + (str * 200)
	Player(source).state['ox_inventory:maxweight'] = math.floor(weight)


	local player = {source = source, identifier = user_id, name = id.firstname .. " " .. id.name, groups = groups}
	server.setPlayerData(player)
	server.GetPlayerFromId = salrp.getUserId
	--local users = SAL:getUsers()
	--[[for uid,src in pairs(users) do
		local inventory = salrp.getInventory(uid)
		local id = salrp.getUserIdentity(uid)
		server.setPlayerInventory({source = src, identifier = uid, name = id.firstname .. " " .. id.name})
	end]]



	server.setPlayerInventory(player)
end)

AddEventHandler("salrp:playerSpawn", function(user_id, source, first_spawn)
	if first_spawn then
		-- {"source":3,"name":"Douglas Washington","identifier":71}
		local id = salrp.getUserIdentity(user_id)

		local g = salrp.getUserGroups(user_id) or {}

		local groups = {
			--[player.job.name] = player.job.grade
		}

		for k,v in pairs(g) do
			groups[k] = 1
			--print("groups", k, 1)
		end

		local jobdata = Player(source).state["salife_oxinv:jobdata"]
		while jobdata == nil do jobdata = Player(source).state["salife_oxinv:jobdata"] Wait(0) end

		for k,v in pairs(jobdata.jobs)do
			groups[k] = v.rank
		end

		local weight = 30000
		if Player(source).state["salplus"] and Player(source).state["salplus"] > 0 then
			weight = weight + 30000
		end
		--local str = exports.salife_oxinv:getSkillLvl(source, 'strength')
		--weight = weight + (str * 200)
		Player(source).state['ox_inventory:maxweight'] = math.floor(weight)


		local player = {source = source, identifier = user_id, name = id.firstname .. " " .. id.name, groups = groups}
		server.setPlayerData(player)
		server.GetPlayerFromId = salrp.getUserId
		--local users = SAL:getUsers()
		--[[for uid,src in pairs(users) do
			local inventory = salrp.getInventory(uid)
			local id = salrp.getUserIdentity(uid)
			server.setPlayerInventory({source = src, identifier = uid, name = id.firstname .. " " .. id.name})
		end]]



		server.setPlayerInventory(player)
	end
end)

AddEventHandler('salrp:playerJoinGroup', function(user_id, group, gtype)
	local source = salrp.getUserSource(user_id)
	if source then
		local id = salrp.getUserIdentity(user_id)
		local g = salrp.getUserGroups(user_id) or {}

		local groups = {
			--[player.job.name] = player.job.grade
		}

		for k,v in pairs(g) do
			groups[k] = 1
			--print("groups", k, 1)
		end

		local jobdata = Player(source).state["salife_oxinv:jobdata"]
		while jobdata == nil do jobdata = Player(source).state["salife_oxinv:jobdata"] Wait(0) end

		for k,v in pairs(jobdata.jobs)do
			groups[k] = v.rank
		end

		if not groups[group] then
			groups[group] = 0
		end
		local player = {source = source, identifier = user_id, name = id.firstname .. " " .. id.name, groups = groups}
		server.setPlayerData(player)
	end
end)

AddEventHandler('salrp:playerLeaveGroup', function(user_id, group, gtype)
	local source = salrp.getUserSource(user_id)
	if source then
		local id = salrp.getUserIdentity(user_id)
		local g = salrp.getUserGroups(user_id) or {}

		local groups = {
			--[player.job.name] = player.job.grade
		}

		for k,v in pairs(g) do
			groups[k] = 1
			--print("groups", k, 1)
		end

		local jobdata = Player(source).state["salife_oxinv:jobdata"]
		while jobdata == nil do jobdata = Player(source).state["salife_oxinv:jobdata"] Wait(0) end
		for k,v in pairs(jobdata.jobs)do
			groups[k] = v.rank
		end

		if groups[group] then
			groups[group] = nil
		end
		local player = {source = source, identifier = user_id, name = id.firstname .. " " .. id.name, groups = groups}
		server.setPlayerData(player)
	end
end)

lib.callback.register('ox_inventory:saveInv', function(source)
	Inventory.Save(source)
	return true
end)

lib.callback.register('ox_inventory:loadVR', function(source)
	--Inventory.Save(source)
	--print('load VR', source)
	local user_id = Player(source).state.user_id
	local id = salrp.getUserIdentity(user_id)
	local g = salrp.getUserGroups(user_id) or {}

	local groups = {
		--[player.job.name] = player.job.grade
	}

	for k,v in pairs(g) do
		groups[k] = 1
		--print("groups", k, 1)
	end

	local jobdata = Player(source).state["salife_oxinv:jobdata"]
	while jobdata == nil do jobdata = Player(source).state["salife_oxinv:jobdata"] Wait(0) end
	
	for k,v in pairs(jobdata.jobs)do
		groups[k] = v.rank
	end

	local player = {source = source, identifier = user_id, name = id.firstname .. " " .. id.name, groups = groups}
	server.setPlayerData(player)
	server.GetPlayerFromId = salrp.getUserId
	--local users = SAL:getUsers()
	--[[for uid,src in pairs(users) do
		local inventory = salrp.getInventory(uid)
		local id = salrp.getUserIdentity(uid)
		server.setPlayerInventory({source = src, identifier = uid, name = id.firstname .. " " .. id.name})
	end]]
	server.setPlayerInventory(player)
end)

---@diagnostic disable-next-line: duplicate-set-field
function server.isPlayerBoss(playerId, group, grade)
	local groupData = GlobalState[('group.%s'):format(group)]

	return groupData and grade >= groupData.adminGrade
end