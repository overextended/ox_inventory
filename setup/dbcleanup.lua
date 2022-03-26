-- Clean up ox_inventory table in the database
-- Used when upgrading to 2.5.0 from a previous release

CreateThread(function()
	local result = MySQL.query.await("SELECT owner, name FROM ox_inventory WHERE NOT owner = ''")
	local parameters = {}
	local count = 0

	for i = 1, #result do
		local data = result[i]
		local snip = data.name:sub(-#data.owner, #data.name)

		if data.owner == snip then
			local name = data.name:sub(0, #data.name - #snip)

			count += 1
			parameters[count] = { query = 'UPDATE ox_inventory SET `name` = ? WHERE `owner` = ? AND `name` = ?', values = { name, data.owner, data.name } }
		end
	end

	if #parameters > 0 then
		MySQL.transaction(parameters)
	elseif lib then
		print("Remove 'setup/dbcleanup.lua' from fxmanifest.lua")
	end
end)
