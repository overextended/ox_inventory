if not lib then return end

local shopTypes = {}
local shops = {}
local createBlip = require 'modules.utils.client'.CreateBlip

for shopType, shopData in pairs(data('shops') --[[@as table<string, OxShop>]]) do
	local shop = {
		name = shopData.name,
		groups = shopData.groups or shopData.jobs,
		blip = shopData.blip,
		label = shopData.label,
	}

	if shared.target then
		shop.model = shopData.model
		shop.targets = shopData.targets
	else
		shop.locations = shopData.locations
	end

	shopTypes[shopType] = shop
	local blip = shop.blip

	if blip then
		blip.name = ('ox_shop_%s'):format(shopType)
		AddTextEntry(blip.name, shop.name or shopType)
	end
end

---@param point CPoint
local function nearbyShop(point)
	---@diagnostic disable-next-line: param-type-mismatch
	DrawMarker(2, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, 0, true, false, false, false)

	if point.isClosest and point.currentDistance < 1.2 and IsControlJustReleased(0, 38) then
		client.openInventory('shop', { id = point.invId, type = point.type })
	end
end

---@param point CPoint
local function onEnterShop(point)
	if not point.entity then
		local model = lib.requestModel(point.ped)

		if not model then return end

		local entity = CreatePed(0, model, point.coords.x, point.coords.y, point.coords.z, point.heading, false, true)

		if point.scenario then TaskStartScenarioInPlace(entity, point.scenario, 0, true) end

		SetModelAsNoLongerNeeded(model)
		FreezeEntityPosition(entity, true)
		SetEntityInvincible(entity, true)
		SetBlockingOfNonTemporaryEvents(entity, true)

		exports.qtarget:AddTargetEntity(entity, {
			options = {
				{
					icon = point.icon or 'fas fa-shopping-basket',
					label = point.label,
					job = point.groups,
					action = function()
						client.openInventory('shop', { id = point.invId, type = point.type })
					end,
					iconColor = point.iconColor,
				}
			},

			distance = point.shopDistance or 2.0
		})

		point.entity = entity
	end
end

local Utils = require 'modules.utils.client'

local function onExitShop(point)
	local entity = point.entity

	if not entity then return end

	exports.qtarget:RemoveTargetEntity(entity, point.label)
	Utils.DeleteEntity(entity)

	point.entity = nil
end

local function hasShopAccess(shop)
	return not shop.groups or client.hasGroup(shop.groups)
end

local function wipeShops()
	for i = 1, #shops do
		local shop = shops[i]

		if shop.zoneId then
            pcall(exports.qtarget.RemoveZone, nil, shop.zoneId)
		end

		if shop.remove then
			if shop.entity then onExitShop(shop) end

			shop:remove()
		end

		if shop.blip then
			RemoveBlip(shop.blip)
		end
	end

	table.wipe(shops)
end

local function refreshShops()
	wipeShops()

	local id = 0

	for type, shop in pairs(shopTypes) do
		local blip = shop.blip
		local label = shop.label or locale('open_label', shop.name)

		if shared.target then
			if shop.model then
				if not hasShopAccess(shop) then goto skipLoop end

				exports.qtarget:RemoveTargetModel(shop.model, label)
				exports.qtarget:AddTargetModel(shop.model, {
					options = {
						{
							icon = shop.icon or 'fas fa-shopping-basket',
							label = label,
							action = function()
								client.openInventory('shop', { type = type })
							end
						},
					},
					distance = 2
				})
			elseif shop.targets then
				for i = 1, #shop.targets do
					local target = shop.targets[i]
					local shopid = ('%s-%s'):format(type, i)

					if target.ped then
						id += 1

						shops[id] = lib.points.new({
							coords = target.loc,
							heading = target.heading,
							distance = 60,
							inv = 'shop',
							invId = i,
							type = type,
							blip = blip and hasShopAccess(shop) and createBlip(blip, target.loc),
							ped = target.ped,
							scenario = target.scenario,
							label = label,
							groups = shop.groups,
							icon = shop.icon,
							iconColor = target.iconColor,
							onEnter = onEnterShop,
							onExit = onExitShop,
							shopDistance = target.distance,
						})
					elseif target.loc then
						if not hasShopAccess(shop) then goto nextShop end

						id += 1

						shops[id] = {
							zoneId = shopid,
							blip = blip and createBlip(blip, target.loc)
						}

						exports.qtarget:AddBoxZone(shopid, target.loc, target.length or 0.5, target.width or 0.5, {
							name = shopid,
							heading = target.heading or 0.0,
							debugPoly = target.debug,
							minZ = target.minZ,
							maxZ = target.maxZ,
							drawSprite = target.drawSprite,
						}, {
							options = {
								{
									icon = 'fas fa-shopping-basket',
									label = label,
									job = shop.groups,
									action = function()
										client.openInventory('shop', { id = i, type = type })
									end,
									iconColor = target.iconColor,
								},
							},
							distance = target.distance or 2.0
						})
					end

					::nextShop::
				end
			end
		elseif shop.locations then
			if not hasShopAccess(shop) then goto skipLoop end

			for i = 1, #shop.locations do
				local coords = shop.locations[i]
				id += 1

				shops[id] = lib.points.new(coords, 16, {
					coords = coords,
					distance = 16,
					inv = 'shop',
					invId = i,
					type = type,
					nearby = nearbyShop,
					blip = blip and createBlip(blip, coords)
				})
			end
		end

		::skipLoop::
	end
end

return {
	refreshShops = refreshShops,
	wipeShops = wipeShops,
}
