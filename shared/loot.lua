-- Enable random loot in dumpsters, gloveboxes, trunks
Config.RandomLoot = true
Config.Dumpsters = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}

if Config.RandomLoot and IsDuplicityVersion() then
	Config.LootChance = { trunk = 100, glovebox = 100, dumpster = 100 }

	Config.Trash = {
		{description = 'An old rolled up newspaper', weight = 200, image = 'trash_newspaper'}, 
		{description = 'A discarded burger shot carton', weight = 50, image = 'trash_burgershot'},
		{description = 'An empty soda can', weight = 20, image = 'trash_can'},
		{description = 'A mouldy piece of bread', weight = 70, image = 'trash_bread'},
		{description = 'An empty ciggarette carton', weight = 10, image = 'trash_fags'},
		{description = 'A slightly used pair of panties', weight = 20, image = 'panties'},
		{description = 'An empty coffee cup', weight = 20, image = 'trash_coffee'},
		{description = 'A crumpled up piece of paper', weight = 5, image = 'trash_paper'},
		{description = 'An empty chips bag', weight = 5, image = 'trash_chips'},
	}

	Config.Loot = {
		['water'] = {trunk = 6, glovebox = 8, dumpster = 4, min= 1, max = 2},
		['cola'] = {trunk = 5, glovebox = 7, min = 1, max = 2},
		['bandage'] = {trunk = 6, glovebox = 8, dumpster = 2, min = 1, max = 3},
		['lockpick'] = {trunk = 2, glovebox = 3, dumpster = 2, min = 1, max = 2},
		['phone'] = {trunk = 1, glovebox = 3, min = 1, max = 1},
		['garbage'] = {trunk = 3, glovebox = 2, dumpster = 80, min = 1, max = 6}
	}

	GenerateTrash = function(metadata)
		local metadata = metadata
		local weight = 50
		local trashType = math.random(1,#Config.Trash)
		metadata.description = Config.Trash[trashType].description
		weight = Config.Trash[trashType].weight
		metadata.image = Config.Trash[trashType].image
		return metadata, weight
	end

	GenerateDatastore = function(type)
		local returnData = {}
		if type == 'trunk' or type == 'glovebox' or type == 'dumpster' then
			local chance = Config.LootChance[type]
			if chance and math.random(1,100) <= chance then 
				for k,v in pairs(Config.Loot) do
					local item = Items[k]
					chance = Config.Loot[k][type]
					if chance then 
						if math.random(1,100) <= chance then 
							local lootMin, lootMax = Config.Loot[k].min, Config.Loot[k].max
							local count = math.random(lootMin,lootMax)
							if k ~= 'garbage' and item.stackable then
								local slot = #returnData + 1
								if item.metadata == nil then item.metadata = {} end
								returnData[slot] = {name = item.name , label = Items[item.name].label, weight = Items[item.name].weight, slot = slot, count = count, description = Items[item.name].description, metadata = item.metadata, stackable = Items[item.name].stackable}
							else
								for i=1, count, 1 do 
									local slot = #returnData + 1
									local metadata = {}
									local weight = Items[item.name].weight
									if item.name == 'garbage' then metadata, weight = GenerateTrash(metadata) end
									returnData[slot] = {name = item.name , label = Items[item.name].label, weight = weight, slot = slot, count = 1, description = Items[item.name].description, metadata = metadata, stackable = Items[item.name].stackable}
								end 
							end
						end
					end
				end 
			end
		end
		return returnData
	end
end
