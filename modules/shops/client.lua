local shops = {}

local function vytvoritObchodVykyv(name, data, location)
	local blip = AddBlipForCoord(location.x, location.y)
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

local function otevritObchod(data)
	client.otevritInventar('shop', data)
end

client.shops = setmetatable(data('shops'), {
	__call = function(self)
		if next(shops) then
			for i = 1, #shops do
				local shop = shops[i]

				if Obchod.point then
					shop:remove()
				end

				if Obchod.blip then
					RemoveBlip(Obchod.blip)
				end
			end

			table.wipe(shops)
		end

		local id = 0

		for type, shop in pairs(self) do
			if Obchod.jobs then Obchod.groups = Obchod.jobs end

			if not Obchod.groups or client.maSkupinu(Obchod.groups) then
				if shared.qtarget then
					if Obchod.model then
						exports.qtarget:AddTargetModel(Obchod.model, {
							options = {
								{
									icon = 'fas fa-shopping-basket',
									label = Obchod.label or shared.locale('open_shop', Obchod.name),
									action = function()
										otevritObchod({type=type})
									end
								},
							},
							distance = 2
						})
					elseif Obchod.targets then
						for i = 1, #Obchod.targets do
							local target = Obchod.targets[i]
							local shopid = type..'-'..i
							id += 1

							if Obchod.blip then
								shops[id] = { blip = vytvoritObchodVykyv(Obchod.name, Obchod.blip, target.loc) }
							end

							exports.qtarget:RemoveZone(shopid)
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
										label = Obchod.label or shared.locale('open_shop', Obchod.name),
										job = Obchod.groups,
										action = function()
											otevritObchod({id=i, type=type})
										end
									},
								},
								distance = target.distance or 3.0
							})
						end
					end
				elseif Obchod.locations then
					for i = 1, #Obchod.locations do
						id += 1
						local coords = Obchod.locations[i]
						local point = lib.points.new(coords, 16, { inv = 'shop', invId = i, type = type })

						function point:nearby()
							DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, false, true, false, false, false)

							if self.currentDistance < 1.2 and lib.points.closest().id == self.id and IsControlJustReleased(0, 38) then
								client.otevritInventar('shop', { id = self.invId, type = self.type })
							end
						end

						if Obchod.blip then
							point.blip = vytvoritObchodVykyv(Obchod.name, Obchod.blip, coords)
						end

						shops[id] = point
						Obchod.target = nil
						Obchod.model = nil
					end
				end
			end
		end
	end
})
