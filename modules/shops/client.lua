local shops = {}

local function createShopBlip(name, data, location)
	local blip = AddBlipForCoord(location.x, location.y, location.z)
	SetBlipSprite(blip, data.id)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, data.scale)
	SetBlipColour(blip, data.colour)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)

	return blip
end

local function openShop(data)
	client.openInventory('shop', data)
end

client.shops = setmetatable(data('shops'), {
	__call = function(self)
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

		for type, shop in pairs(self) do
			if shop.jobs then shop.groups = shop.jobs end

			if not shop.groups or client.hasGroup(shop.groups) then
				if shared.qtarget then
					if shop.model then
						exports.qtarget:AddTargetModel(shop.model, {
							options = {
								{
									icon = 'fas fa-shopping-basket',
									label = shop.label or shared.locale('open_shop', shop.name),
									action = function()
										openShop({type=type})
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
								blip = shop.blip and createShopBlip(shop.name, shop.blip, target.loc)
							}

							exports.qtarget:AddBoxZone(shopid, target.loc, target.length or 0.5, target.width or 0.5, {
								name = shopid,
								heading = target.heading or 0.0,
								debugPoly = false,
								minZ = target.minZ,
								maxZ = target.maxZ
							}, {
								options = {
									{
										icon = 'fas fa-shopping-basket',
										label = shop.label or shared.locale('open_shop', shop.name),
										job = shop.groups,
										action = function()
											openShop({id=i, type=type})
										end
									},
								},
								distance = target.distance or 2.0
							})
						end
					end
				elseif shop.locations then
					for i = 1, #shop.locations do
						id += 1
						local coords = shop.locations[i]
						local point = lib.points.new(coords, 16, { inv = 'shop', invId = i, type = type })

						function point:nearby()
							DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, false, true, false, false, false)

							if self.currentDistance < 1.2 and lib.points.closest().id == self.id and IsControlJustReleased(0, 38) then
								client.openInventory('shop', { id = self.invId, type = self.type })
							end
						end

						if shop.blip then
							point.blip = createShopBlip(shop.name, shop.blip, coords)
						end

						shops[id] = point
						shop.target = nil
						shop.model = nil
					end
				end
			end
		end
	end
})
