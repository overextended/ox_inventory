
local Blips = {}
local Stores = data('shops')

local CreateLocationBlip = function(name, blip, location)
	local blipId = #Blips
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

local CreateShopLocations = function()
	if next(Blips) then
		for i=1, #Blips do RemoveBlip(i) end
		table.wipe(Blips)
	end
	for type, shop in pairs(Stores) do
		if shop.jobs == nil or (shop.jobs[ESX.PlayerData.job.name] and ESX.PlayerData.job.grade >= shop.jobs[ESX.PlayerData.job.name]) then
			if Config.Target then
				local OpenShop = function(data)
					TriggerEvent('ox_inventory:openInventory', 'shop', data)
				end
				for id=1, #shop.targets do
					local target = shop.targets[id]
					local shopid = type..'-'..id
					if shop.blip then CreateLocationBlip(shop.name, shop.blip, target.loc) end
					exports.qtarget:AddBoxZone(id, target.loc, target.length or 0.5, target.width or 0.5, {
						name=shopid,
						heading=target.heading or 0.0,
						debugPoly=false,
						minZ=target.minZ,
						maxZ=target.maxZ
					}, {
						options = {
							{
								icon = "fas fa-shopping-basket",
								label = "Open " .. shop.name,
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
					CreateLocationBlip(shop.name, shop.blip, shop.locations[i])
				end
			end
		end
	end
end

return {
	CreateShopLocations = CreateShopLocations,
	Stores = Stores
}