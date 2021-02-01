# hsn-inventory
Advanced Inventory System for Fivem

Setup / EN

Setup / TR
Stabil çalışması için es_extended v1 final kullanmak zorundasınız.
https://cdn.discordapp.com/attachments/800735373965525076/805815461932433408/unknown.png -- es_extended/server/main.lua
Üstteki satırları bulup benim eklediğim yere "TriggerEvent("hsn-inventory:setplayerInventory",xPlayer.identifier,xPlayer.inventory)" eventini eklemelisiniz.

https://cdn.discordapp.com/attachments/800735373965525076/805815947080106034/Screenshot_1.png -- es_extended/server/main.lua

üstteki kodların hepsini yorum satırına çevirin.

es_extended/server/functions.luada ESX.SavePlayer fonksiyonunu bulup bu şekilde çevirin.
ESX.SavePlayer = function(xPlayer, cb)
	local asyncTasks = {}
	local inv = {}
	TriggerEvent("hsn-inventory:getplayerInventory",function(inventory)
		inv = inventory
	end,xPlayer.identifier)
	table.insert(asyncTasks, function(cb2)
		MySQL.Async.execute('UPDATE users SET accounts = @accounts, job = @job, job_grade = @job_grade, `group` = @group, loadout = @loadout, position = @position, inventory = @inventory WHERE identifier = @identifier', {
			['@accounts'] = json.encode(xPlayer.getAccounts(true)),
			['@job'] = xPlayer.job.name,
			['@job_grade'] = xPlayer.job.grade,
			['@group'] = xPlayer.getGroup(),
			['@loadout'] = json.encode(xPlayer.getLoadout(true)),
			['@position'] = json.encode(xPlayer.getCoords()),
			['@identifier'] = xPlayer.getIdentifier(),
			['@inventory'] = json.encode(inv)
		}, function(rowsChanged)
			cb2()
		end)
	end)

	Async.parallel(asyncTasks, function(results)
		print(('[es_extended] [^2INFO^7] Saved player "%s^7"'):format(xPlayer.getName()))

		if cb then
			cb()
		end
	end)
end
