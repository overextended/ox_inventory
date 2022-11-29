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

			for ingredient, needs in pairs(recipe.ingredients) do
				if needs < 1 then
					item = Items(ingredient)

					if not item.durability then
						item.durability = true
					end
				end
			end
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

		if left.open and left.open ~= source then
			local inv = Inventory(left.open)

			-- Why would the player inventory open with an invalid target? Can't repro but whatever.
			if inv then
				if inv.player then
					TriggerClientEvent('ox_inventory:closeInventory', inv.owner, true)
				end

				inv:set('open', false)
			end
		end

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
			local newWeight = left.weight + (craftedItem.weight + (recipe.metadata?.weight or 0)) * (recipe.count or 1)
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
						local item = Items(name)
						local durability = slot.metadata.durability

						if durability and durability >= needs * 100 then
							if durability > 100 then
								local degrade = (slot.metadata.degrade or item.degrade) * 60
								local percentage = ((durability - os.time()) * 100) / degrade

								if percentage >= needs * 100 then
									tbl[slot.slot] = needs
									break
								end
							else
								tbl[slot.slot] = needs
								break
							end
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
						local item = Items(invSlot.name)
						local durability = invSlot.metadata.durability or 100

						if durability > 100 then
							local degrade = (invSlot.metadata.degrade or item.degrade) * 60
							durability -= degrade * count
						else
							durability -= count * 100
						end

						if invSlot.count > 1 then
							local emptySlot = Inventory.GetEmptySlot(left)

							if emptySlot then
								local newItem = Inventory.SetSlot(left, item, 1, table.deepclone(invSlot.metadata), emptySlot)

								if newItem then
									newItem.metadata.durability = durability < 0 and 0 or durability
									durability = 0

									TriggerClientEvent('ox_inventory:updateSlots', left.id, {
										{
											item = newItem,
											inventory = left.type
										}
									}, { left = left.weight })
								end
							end

							invSlot.count -= 1
						else
							invSlot.metadata.durability = durability < 0 and 0 or durability
						end

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

				Inventory.AddItem(left, craftedItem, recipe.count or 1, recipe.metadata or {}, toSlot)
			end

			return true
		end
	end
end)
