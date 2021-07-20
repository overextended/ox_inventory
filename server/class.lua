CreateInventory = function(id, name, type, slots, weight, maxWeight, owner, inventory)
	local self = {}

	self.id = id							-- unique id or identifier
	self.name = name						-- name or label to display
	self.type = type						-- player, stash, bag, etc.
	self.slots = slots						-- slot count
	self.weight = weight					-- current weight
	self.maxWeight = maxWeight				-- maximum weight
	self.owner = owner						-- identifier of the owner, if one exists
	self.inventory = inventory or {}		-- stored items
	self.open = false						-- playerid of whoever is using the inventory

	if self.type == 'player' then			-- reference the xPlayer without having to specifically call for it
		self.player = function() return ESX.GetPlayerFromId(self.id) end
	else
		self.changed = false				-- have the inventory contents have changed or moved
		self.timeout = false				-- is the inventory waiting to save
	end

	self.get = function(k, v)
		return self[k]
	end

	self.set = function(k, v)
		self[k] = v
		if k == 'open' and v == false then
			if self.type == 'admin' then self.type = 'player' end
			if self.changed == true and self.timeout == false then
				self.timer()				-- when inventory closes set a timer
			end
		end
	end

	self.timer = function()
		self.set('timeout', true)
		SetTimeout(30000, function()		-- save the inventory after 30 seconds
			if self.open == false then		-- unless it is open when the save should trigger
				self.save()
			end
			self.set('timeout', false)
		end)
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
			SaveItems(self.type, self.id, self.owner, json.encode(inventory))
			if self.type ~= 'stash' then Inventories[self.id] = nil end
		end
	end

	return self
end
