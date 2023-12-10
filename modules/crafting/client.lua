if not lib then return end

local CraftingBenches = {}
local Items = require 'modules.items.client'
local createBlip = require 'modules.utils.client'.CreateBlip

---@param id number
---@param data table
local function createCraftingBench(id, data)
	CraftingBenches[id] = {}
	local recipes = data.items

	if recipes then
		data.slots = #recipes

		for i = 1, data.slots do
			local recipe = recipes[i]
			local item = Items[recipe.name]

			if item then
				recipe.weight = item.weight
				recipe.slot = i
			else
				warn(('failed to setup crafting recipe (bench: %s, slot: %s) - item "%s" does not exist'):format(id, i, recipe.name))
			end
		end

		local blip = data.blip

		if blip then
			blip.name = blip.name or ('ox_crafting_%s'):format(data.label and id or 0)
			AddTextEntry(blip.name, data.label or locale('crafting_bench'))
		end

		if shared.target then
			data.points = nil
            if data.zones then
    			for i = 1, #data.zones do
    				local zone = data.zones[i]
    				zone.name = ("craftingbench_%s:%s"):format(id, i)
    				zone.id = id
    				zone.index = i
    				zone.options = {
    					{
    						label = zone.label or locale('open_crafting_bench'),
    						canInteract = data.groups and function()
    							return client.hasGroup(data.groups)
    						end or nil,
    						onSelect = function()
    							client.openInventory('crafting', { id = id, index = i })
    						end,
    						distance = zone.distance or 2.0,
    						icon = zone.icon or 'fas fa-wrench',
    					}
    				}

    				exports.ox_target:addBoxZone(zone)

    				if blip then
    					createBlip(blip, zone.coords)
    				end
    			end
            end
		elseif data.points then
			data.zones = nil

			---@param point CPoint
			local function nearbyBench(point)
				---@diagnostic disable-next-line: param-type-mismatch
				DrawMarker(2, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 150, 150, 30, 222, false, false, 0, true, false, false, false)

				if point.isClosest and point.currentDistance < 1.2 and IsControlJustReleased(0, 38) then
					client.openInventory('crafting', { id = point.benchid, index = point.index })
				end
			end

			for i = 1, #data.points do
				local coords = data.points[i]

				lib.points.new({
					coords = coords,
					distance = 16,
					benchid = id,
					index = i,
					inv = 'crafting',
					nearby = nearbyBench
				})

				if blip then
					createBlip(blip, coords)
				end
			end
		end

		CraftingBenches[id] = data
	end
end

for id, data in pairs(lib.load('data.crafting')) do createCraftingBench(id, data) end

return CraftingBenches
