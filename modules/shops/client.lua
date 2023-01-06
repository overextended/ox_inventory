if not lib then return end

local shopTypes = {}
local shops = {}
local createBlip = client.utils.CreateBlip

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

function client.refreshShops()
	for i = 1, #shops do
		local shop = shops[i]

		if shop.zoneId then
			exports.qtarget:RemoveZone(shop.zoneId)
		end

		if shop.remove then
			shop:remove()
		end

		if shop.blip then
			RemoveBlip(shop.blip)
		end
	end

	table.wipe(shops)
	local id = 0

	for type, shop in pairs(shopTypes) do
		if not shop.groups or client.hasGroup(shop.groups) then
			local blip = shop.blip

			if shared.target then
				if shop.model then
					local label = shop.label or locale('open_label', shop.name)

					exports.qtarget:RemoveTargetModel(shop.model, label)
					exports.qtarget:AddTargetModel(shop.model, {
						options = {
							{
								icon = 'fas fa-shopping-basket',
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
						local shopid = type..'-'..i
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
									label = shop.label or locale('open_label', shop.name),
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
				end
			elseif shop.locations then
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
		end
	end
end
