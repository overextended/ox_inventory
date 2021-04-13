--[[
	Delete this file if you do not require it! If you have converted your database you can delete this file
	Remember to backup your database in the event of errors

	This will only convert items where inventories are stored as a table in `users`
	If you are using a `user_inventory` table this won't do anything

	ExtendedMode has a migratedb function of its own that you could try before using this
	https://github.com/extendedmode/extendedmode/blob/master/server/dbmigrate.lua
	
	This conversion method is based on the above file
]]

local start = false
local running = false
local totalCount = 0
local currentCount = 0
local identifier = {}
local inventory = {}
local loadout = {}

RegisterCommand('convertinventory', function(source, args)
	if source == 0 then
		if not running then
			if start then
				RetrieveUsers()
			else
				print('^8	=================================================================^0')
				print('^3	ENSURE NO PLAYERS ARE ONLINE AND YOUR DATABASE HAS BEEN BACKED UP^0')
				print('^3	ENTER THE COMMAND AGAIN TO BEGIN CONVERSION^0')
				print('^8	=================================================================^0')
				start = true
			end
		end
	end
end)

RetrieveUsers = function()
	running = true
	local result = exports.ghmattimysql:executeSync('SELECT identifier, inventory, loadout FROM users', {})
	if result then
		for k, v in pairs(result) do
			if (v.inventory ~= nil and v.inventory ~= '' and v.inventory ~= '[]') or (v.loadout ~= nil and v.loadout ~= '' and v.loadout ~= '[]') then
				if v.inventory:find('"slot":') == nil then
					local count = #identifier+1
					identifier[count] = v.identifier
					inventory[count] = json.decode(v.inventory)
					loadout[count] = json.decode(v.loadout)
				end
			end
		end
		totalCount = #identifier
		if totalCount == 0 then 
			print('^8	=================================================================^0')
			print('^3	THERE ARE NO PLAYERS WITH INVENTORIES TO CONVERT^0')
			print('^8	=================================================================^0')
			return
		end
		print('^8	=================================================================^0')
		print('^3	FOUND '..totalCount..' PLAYERS WITH OLD INVENTORY DATA^0')
		print('^3	STARTING CONVERSION - WAIT UNTIL THE PROCESS IS COMPLETE^0')
		print('^8	=================================================================^0')
		BeginConversion()
	else
		print('^8	=================================================================^0')
		print('^3	NO RESULTS FOUND, DATABASE MUST INCLUDE IDENTIFIER AND INVENTORY^0')
		print('^8	=================================================================^0')
		return
	end
end

local newInventory = {}

BeginConversion = function()
	for i=1, #identifier do
		local newInv = {}
		Citizen.Wait(200)
		local loop = 0
		if loadout[i] then
			for k, v in pairs(loadout[i]) do
				local xItem = Items[k]
				if xItem then
					loop = loop + 1
					v = {slot=loop, name=k, count=1}
					v.metadata = {}
					if Config.Throwable[k] then
						v.metadata = {throwable=1}
					elseif Config.Melee[k] or Config.Miscellaneous[k] then
						if not vmetadata.durability then vmetadata.durability = 100 end
					else
						if not v.metadata.durability then v.metadata.durability = 100 end
						if Items[k].ammoType then v.metadata.ammo = 0 end
						if not v.metadata.components then v.metadata.components = {} end
						v.metadata.serial = GenerateSerial()
					end
				end
				newInv[loop] = v
			end
		end
		if inventory[i] then
			for k, v in pairs(inventory[i]) do
				local xItem = Items[k]
				if xItem and v > 0 then
					loop = loop + 1
					v = {slot=loop, name=k, count=v, metadata={}}
					newInv[loop] = v
				end
			end
		end
		newInventory[i] = json.encode(newInv)
		exports.ghmattimysql:execute('UPDATE users SET inventory = @inventory WHERE identifier = @identifier', {
			['@inventory'] = newInventory[i],
			['@identifier'] = identifier[i]
		}, function(result)
			currentCount = currentCount + 1
			print('^2 Updated '..currentCount..' of '..totalCount..' players^0')
		end)
	end
end
