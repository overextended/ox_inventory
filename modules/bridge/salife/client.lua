local Tunnel = module("salrp", "lib/Tunnel")
local Proxy = module("salrp", "lib/Proxy")

salrpi = {}
salrp = Proxy.getInterface("salrp")
salrpclient = Tunnel.getInterface("salrp", "ox_inventory")
Iclient = Tunnel.getInterface("ox_inventory")
Tunnel.bindInterface("ox_inventory",salrpi)
Proxy.addInterface("ox_inventory",salrpi)


local onLogout = ...

RegisterNetEvent('salrp:playerLeave', onLogout)

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