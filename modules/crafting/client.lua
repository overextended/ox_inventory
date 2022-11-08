if not lib then return end

local CraftingBenches = {}
local Items = client.items
local locations = shared.qtarget and 'zones' or 'points'

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

		if shared.qtarget then
			data.points = nil

			for i = 1, #data.zones do
				exports.ox_target:addBoxZone({
					name = ("craftingbench_%s:%s"):format(id, i),
					coords = vec3(-1146.2, -2002.05, 13.2),
					size = vec3(3.8, 1.05, 0.15),
					rotation = 315.0,
					id = id,
					index = i,
					options = {
						{
							label = 'Open Crafting Bench',
							onSelect = function()
								client.openInventory('crafting', { id = id, index = i })
							end
						}
					}
				})
			end
		else
			data.zones = nil
		end

		CraftingBenches[id] = data
	end
end

for id, data in pairs(data('crafting')) do createCraftingBench(id, data) end

client.craftingBenches = CraftingBenches
