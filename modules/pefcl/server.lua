--[[
	Intended for use with https://github.com/project-error/pefcl
	config.useFrameworkIntegration.resource should be set as "ox_inventory"

	This isn't intended for use with frameworks with their own accounts,
	use the proper pefcl-framework resources and ensure item/account syncing
	works on your own.
]]

local Inventory = require 'modules.inventory.server'

---@param source number
---@param amount number
exports('addCash', function(source, amount)
	Inventory.AddItem(source, 'money', amount)
end)

---@param source number
---@param amount number
exports('removeCash', function(source, amount)
	Inventory.RemoveItem(source, 'money', amount)
end)

---@param source number
---@return number
exports('getCash', function(source)
	return Inventory.GetItemCount(source, 'money')
end)

---@param source number
---@return table?
exports('getCards', function(source)
	local items = Inventory(source)?.items

	if items then
		local retval, num = {}, 0

		for _, data in pairs(items) do
			if data.name == 'mastercard' then
				num += 1
				retval[num] = {
					id = data.metadata.id,
					holder = data.metadata.holder,
					number = data.metadata.number
				}
			end
		end

		return retval
	end
end)

---@param source number
---@param card table
exports('giveCard', function(source, card)
	Inventory.AddItem(source, 'mastercard', 1, {
		id = card.id,
		holder = card.holder,
		number = card.number,
		description = ('Card Number: %s'):format(card.number)
	})
end)

---no-op
exports('getBank', function() end)

