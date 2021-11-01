local M = data('shops')

local Blips = {}
local CreateLocationBlip = function(blipId, name, blip, location)
	Blips[blipId] = AddBlipForCoord(location.x, location.y)
	SetBlipSprite(Blips[blipId], blip.id)
	SetBlipDisplay(Blips[blipId], 4)
	SetBlipScale(Blips[blipId], blip.scale)
	SetBlipColour(Blips[blipId], blip.colour)
	SetBlipAsShortRange(Blips[blipId], true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(name)
	EndTextCommandSetBlipName(Blips[blipId])
end

setmetatable(M, {
	__call = function()
		if next(Blips) then
			for i=1, #Blips do RemoveBlip(Blips[i]) end
			table.wipe(Blips)
		end
		local blipId = 0
		for type, shop in pairs(M) do
			if shop.jobs == nil or (shop.jobs[ESX.PlayerData.job.name] and ESX.PlayerData.job.grade >= shop.jobs[ESX.PlayerData.job.name]) then
				blipId += 1
				if Config.Target then
					local OpenShop = function(data)
						TriggerEvent('ox_inventory:openInventory', 'shop', data)
					end
					for id=1, #shop.targets do
						local target = shop.targets[id]
						local shopid = type..'-'..id
						exports.qtarget:RemoveZone(shopid)
						if shop.blip then CreateLocationBlip(blipId, shop.name, shop.blip, target.loc) end
						exports.qtarget:AddBoxZone(shopid, target.loc, target.length or 0.5, target.width or 0.5, {
							name=shopid,
							heading=target.heading or 0.0,
							debugPoly=false,
							minZ=target.minZ,
							maxZ=target.maxZ
						}, {
							options = {
								{
									icon = "fas fa-shopping-basket",
									label = ox.locale('open_shop', shop.name),
									job = shop.job,
									action = function()
										OpenShop({id=id, type=type})
									end
								},
							},
							distance = target.distance or 3.0
						})
					end
				elseif shop.blip then
					for i=1, #shop.locations do
						blipId += 1
						CreateLocationBlip(blipId, shop.name, shop.blip, shop.locations[i])
					end
				end
			end
		end
	end
})

return M