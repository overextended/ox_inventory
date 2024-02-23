local onLogout = ...

RegisterNetEvent('salrp:playerLeave', client.onLogout)
RegisterNetEvent('salrp:playerLeave:client', client.onLogout)

function client.setPlayerStatus(values)
	for name, value in pairs(values) do
		if value > 0 then
			value = value * -1
		end
		if name == "hunger" then
			TriggerServerEvent("salife-survival:varyHunger", GetPlayerServerId(PlayerId()), value)
		end
		if name == "thirst" then
			TriggerServerEvent("salife-survival:varyThirst", GetPlayerServerId(PlayerId()),value)
		end
		if name == "drunk" then
			TriggerServerEvent("salife-survival:varyDrunk", GetPlayerServerId(PlayerId()),value)
		end
		if name == "highness" then
			TriggerServerEvent("salife-survival:varyHigh", GetPlayerServerId(PlayerId()),value)
		end
	end
end

function client.hasGroup(group)
	local group = group
	local rank = exports.salife_oxinv:CheckForJobsRanks(group)
	return rank
end