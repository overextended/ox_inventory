local onLogout = ...

RegisterNetEvent('ox:playerLogout', onLogout)

RegisterNetEvent('ox:setGroup', function(name, grade)
	PlayerData.groups[name] = grade
	OnPlayerData('groups')
end)

function client.setPlayerStatus(values)
	for name, value in pairs(values) do
		-- Thanks to having status values setup out of 1000000 (matching esx_status's standard)
		-- we need to awkwardly change the value
		if value > 100 or value < 100 then value *= 0.0001 end

		if value > 0 then
			player.removeStatus(name, value)
		else
			player.addStatus(name, value)
		end
	end
end
