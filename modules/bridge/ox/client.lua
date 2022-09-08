local onLogout = ...

RegisterNetEvent('ox:playerLogout', onLogout)

RegisterNetEvent('ox:setGroup', function(name, grade)
	PlayerData.groups[name] = grade
	OnPlayerData('groups')
end)
