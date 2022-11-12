if not lib then return end

local CraftingBenches = {}
local Items = server.items
local Inventory = server.inventory

---@param id number
---@param data table
local function createCraftingBench(id, data)
	CraftingBenches[id] = {}
	local locations = shared.target and data.zones or data.points
	local recipes = data.items

	if recipes and locations then
		for i = 1, #recipes do
			local recipe = recipes[i]
			local item = Items(recipe.name)
			recipe.weight = item.weight
			recipe.slot = i
		end

		if shared.target then
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
		local coords = shared.target and bench.zones[index].coords or bench.points[index]

		if groups and not server.hasGroup(left, groups) then return end
		if #(GetEntityCoords(GetPlayerPed(source)) - coords) > 10 then return end

		left.open = true
	end

	return { label = left.label, type = left.type, slots = left.slots, weight = left.weight, maxWeight = left.maxWeight }
end)

lib.callback.register('ox_inventory:craftItem', function(source, id, index, recipeId, toSlot)
	local left, bench = Inventory(source), CraftingBenches[id]

	if bench then
		local groups = bench.groups
		local coords = shared.target and bench.zones[index].coords or bench.points[index]

		if groups and not server.hasGroup(left, groups) then return end
		if #(GetEntityCoords(GetPlayerPed(source)) - coords) > 10 then return end

		local recipe = bench.items[recipeId]

		if recipe then
			local tbl, num = {}, 0

			for name in pairs(recipe.ingredients) do
				num += 1
				tbl[num] = name
			end

			local craftedItem = Items(recipe.name)
			local newWeight = left.weight + (craftedItem.weight + (recipe.metadata.weight or 0)) * (recipe.amount or 1)
			---@todo new iterator or something to accept a map
			local items = Inventory.Search(left, 'slots', tbl) or {}
			table.wipe(tbl)

			for name, needs in pairs(recipe.ingredients) do
				local slots = items[name] or items

				for i = 1, #slots do
					local slot = slots[i]

					if needs == 0 then
						if not slot.metadata.durability or slot.metadata.durability > 0 then
							break
						end
					elseif needs < 1 then
						if slot.metadata.durability >= needs * 100 then
							tbl[slot.slot] = needs
							break
						end
					elseif needs <= slot.count then
						local itemWeight = slot.weight / slot.count
						newWeight = (newWeight - slot.weight) + (slot.count - needs) * itemWeight
						tbl[slot.slot] = needs
						break
					else
						tbl[slot.slot] = slot.count
						newWeight -= slot.weight
						needs -= slot.count
					end

					if needs == 0 then break end
					-- Player does not have enough items (ui should prevent crafting if lacking items, so this shouldn't trigger)
					if needs > 0 and i == #slots then return end
				end
			end

			if newWeight > left.maxWeight then
				return false, 'cannot_carry'
			end

			local success = lib.callback.await('ox_inventory:startCrafting', source, id, recipeId)

			if success then
				for name, needs in pairs(recipe.ingredients) do
					if Inventory.GetItem(left, name, nil, true) < needs then return end
				end

				for slot, count in pairs(tbl) do
					local invSlot = left.items[slot]

					if count < 1 then
						local durability = invSlot.metadata.durability
						durability -= count * 100
						invSlot.metadata.durability = durability

						TriggerClientEvent('ox_inventory:updateSlots', source, {
							{
								item = invSlot,
								inventory = left.type
							}
						}, { left = left.weight })
					else
						local removed = invSlot and Inventory.RemoveItem(left, invSlot.name, count, nil, slot)
						-- Failed to remove item (inventory state unexpectedly changed?)
						if not removed then return end
					end
				end

				Inventory.AddItem(left, craftedItem, recipe.amount or 1, recipe.metadata or {}, toSlot)
			end

			return true
		end
	end
end)
