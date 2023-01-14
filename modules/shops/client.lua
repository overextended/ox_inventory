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
	DrawMarker(2, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30
		, 222, false, false, 0, true, false, false, false)

	if point.isClosest and point.currentDistance < 1.2 and IsControlJustReleased(0, 38) then
		client.openInventory('shop', { id = point.invId, type = point.type })
	end
end

function client.refreshShops()
	for i = 1, #shops do
		local shop = shops[i]
    
		if shop.zoneId then
			exports.ox_target:removeZone(shop.zoneId)
		end

		if shop.pedId then
			exports.ox_target:removeLocalEntity(shop.pedId, 'openShop')
			DeleteEntity(shop.pedId)
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
					exports.ox_target:removeModel(shop.model, 'ox_inventory:openShop:Model')
					exports.ox_target:addModel(shop.model, {
						{
							name = 'ox_inventory:openShop:Model',
							icon = 'fas fa-shopping-basket',
							label = shop.label or locale('open_label', shop.name),
							onSelect = function()
								client.openInventory('shop', { type = type })
							end,
							distance = 2
						},
					})
				end

				if shop.targets then
					for i = 1, #shop.targets do
						local target = shop.targets[i]
						id += 1

						local options = {
							{
								name = type .. '-' .. i,
								icon = 'fas fa-shopping-basket',
								label = shop.label or locale('open_label', shop.name),
								onSelect = function()
									client.openInventory('shop', { id = i, type = type })
								end,
								distance = target.distance or 2.0,
								groups = shop.groups or nil
							}
						}

						local shopid = exports.ox_target:addBoxZone({
							coords = target.loc,
							size = vec3(target.length or 0.5, target.width or 0.5, target.maxZ - target.minZ),
							rotation = target.heading or 0.0,
							debug = target.debug,
							drawSprite = target.drawSprite,
							options = options
						})
						shops[id] = {
							zoneId = shopid,
							blip = blip and createBlip(blip, target.loc)
						}
					end
				end

				if shop.peds then
					for i = 1, #shop.peds do
						local ped = shop.peds[i]
						i += #shop.targets
						id += 1

						lib.requestModel(ped.ped)
						local PedId = CreatePed(0, ped.ped, ped.loc.x, ped.loc.y, ped.loc.z - 1, ped.loc.w, false, false) -- true)
						TaskStartScenarioInPlace(PedId, ped.scenario, 0, true)
						FreezeEntityPosition(PedId, true)
						SetEntityInvincible(PedId, true)
						SetBlockingOfNonTemporaryEvents(PedId, true)
						local options = {
							{
								name = 'openShop',
								type = 'client',
								icon = 'fas fa-shopping-basket',
								label = shop.label or locale('open_label', shop.name),
								onSelect = function()
									client.openInventory('shop', { id = i, type = type })
								end,
								distance = ped.distance or 2.0
							}
						}
						if shop.groups then
							options.groups = {}
							for k, _ in pairs(shop.groups) do
								options.groups[#options.groups + 1] = k
							end
						end
						exports.ox_target:addLocalEntity(PedId, options)
						shops[id] = {
							pedId = PedId,
							blip = blip and createBlip(blip, ped.loc)
						}
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

			if shop.locations then
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

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for i = 1, #shops do
			local shop = shops[i]

			if shop.zoneId then
				exports.ox_target:removeZone(shop.zoneId)
			end

			if shop.pedId then
				exports.ox_target:removeLocalEntity(shop.pedId, 'openShop')
				DeleteEntity(shop.pedId)
			end
		end
	end
end)
