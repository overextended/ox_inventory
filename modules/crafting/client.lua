if not lib then return end

local CraftingBenches = {}
local Items = client.items
local locations = shared.target and 'zones' or 'points'

local function createBlip(name, coords, settings)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, settings.id)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, settings.scale)
	SetBlipColour(blip, settings.colour)
	SetBlipAsShortRange(blip, true)
	AddTextEntry(name, name)
	BeginTextCommandSetBlipName(name)
	EndTextCommandSetBlipName(blip)
end

---@param id number
---@param data table
local function createCraftingBench(id, data)
	CraftingBenches[id] = {}
	local benchLocations = data[locations]
	local recipes = data.items

	if recipes and benchLocations then
		data.slots = #recipes

		for i = 1, data.slots do
			local recipe = recipes[i]
			local item = Items[recipe.name]
			recipe.weight = item.weight
			recipe.slot = i
		end

		if shared.target then
			data.points = nil

			for i = 1, #data.zones do
				local zone = data.zones[i]
				zone.name = ("craftingbench_%s:%s"):format(id, i)
				zone.id = id
				zone.index = i
				zone.options = {
					{
						label = 'Open Crafting Bench',
						canInteract = data.groups and function()
							return client.hasGroup(data.groups)
						end or nil,
						onSelect = function()
							client.openInventory('crafting', { id = id, index = i })
						end
					}
				}

				exports.ox_target:addBoxZone(zone)

				if data.blip then
					createBlip(data.label or locale('crafting_bench'), zone.coords, data.blip)
				end
			end
		else
			data.zones = nil

			---@param point CPoint
			local function nearbyBench(point)
				---@diagnostic disable-next-line: param-type-mismatch
				DrawMarker(2, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 150, 30, 30, 222, false, false, 0, true, false, false, false)
			end

			for i = 1, #data.points do
				local coords = data.points[i]

				lib.points.new({
					coords = coords,
					distance = 16,
					id = id,
					index = i,
					inv = 'crafting',
					nearby = nearbyBench
				})

				if data.blip then
					createBlip(data.label or locale('crafting_bench'), coords, data.blip)
				end
			end
		end

		CraftingBenches[id] = data
	end
end

for id, data in pairs(data('crafting')) do createCraftingBench(id, data) end

client.craftingBenches = CraftingBenches
