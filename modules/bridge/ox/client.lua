local onLogout = ...

RegisterNetEvent('ox:playerLogout', onLogout)

RegisterNetEvent('ox:setGroup', function(name, grade)
	PlayerData.groups[name] = grade
	OnPlayerData('groups')
end)

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
	for name, value in pairs(values) do
		-- Thanks to having status values setup out of 1000000 (matching esx_status's standard)
		-- we need to awkwardly change the value
		if value > 100 or value < -100 then
			-- Hunger and thirst start at 0 and go up to 100 as you get hungry/thirsty (inverse of ESX)
			if (name == 'hunger' or name == 'thirst') then
				value = -value
			end

			value = value * 0.0001
		end

		---@diagnostic disable-next-line: undefined-global
		player.addStatus(name, value)
	end
end
