if not lib then return end

local CraftingBenches = {}
local Items = server.items
local Inventory = server.inventory

---@param id number
---@param data table
local function createCraftingBench(id, data)
	CraftingBenches[id] = {}
	local locations = shared.qtarget and data.zones or data.points
	local recipes = data.items

	if recipes and locations then
		for i = 1, #recipes do
			local recipe = recipes[i]
			local item = Items(recipe.name)
			recipe.weight = item.weight
			recipe.slot = i
		end

		if shared.qtarget then
			data.points = nil
		else
			data.zones = nil
		end

		CraftingBenches[id] = data
	end
end

for id, data in pairs(data('crafting')) do createCraftingBench(id, data) end

lib.callback.register('ox_inventory:openCraftingBench', function(source, id, index)
	local left, bench = Inventory(source), CraftingBenches[id]

	if bench then
		local groups = bench.groups
		local coords = shared.qtarget and bench.zones[index].coords or bench.points[index]

		if groups and not server.hasGroup(left, groups) then return end
		if #(GetEntityCoords(GetPlayerPed(source)) - coords) > 10 then return end

		left.open = true
	end

	return { label = left.label, type = left.type, slots = left.slots, weight = left.weight, maxWeight = left.maxWeight }
end)

lib.callback.register('ox_inventory:craftItem', function(source, id, index, recipeId)
	local left, bench = Inventory(source), CraftingBenches[id]

	if bench then
		local groups = bench.groups
		local coords = shared.qtarget and bench.zones[index].coords or bench.points[index]

		if groups and not server.hasGroup(left, groups) then return end
		if #(GetEntityCoords(GetPlayerPed(source)) - coords) > 10 then return end

		local recipe = bench.items[recipeId]

		if recipe then
			print(source, id, index, recipeId)
			print(json.encode(recipe, {indent=true}))

			---@todo check if item can be crafted, add and remove necessary items

			return true, { weight = left.weight, items = {} }
		end
	end
end)
