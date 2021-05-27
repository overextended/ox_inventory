CreateInventory = function(id, name, type, slots, weight, maxWeight, owner, inventory)
	local self = {}

	self.id = id
	self.name = name
	self.type = type
	self.slots = slots
	self.weight = weight
	self.maxWeight = maxWeight
	self.owner = owner
	self.inventory = inventory or {}
	self.open = false

	if self.type == 'player' then
		self.player = function() return ESX.GetPlayerFromId(self.id) end
	end

	self.set = function(k, v)
		self[k] = v
	end

	self.get = function(k, v)
		return self[k]
	end

	self.save = function()
		local inventory, count = {}, 0
		for k, v in pairs(self.inventory) do
			if v.name and v.count > 0 then
				count = count + 1
				inventory[count] = {
					name = v.name,
					count = v.count,
					metadata = v.metadata,
					slot = k
				}
			end
		end
		if self.type == 'player' then
			exports.ghmattimysql:execute('UPDATE `users` SET `inventory` = @inventory WHERE identifier = @identifier', {
				['@inventory'] = json.encode(inventory),
				['@identifier'] = self.identifier
			})
		else
			SaveItems(self.type, self.id, self.owner, json.encode(self.inventory))
		end
	end

	return self
end
