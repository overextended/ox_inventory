-- Clean up ox_inventory table in the database
-- Used when upgrading to 2.5.0 from a previous release

CreateThread(function()
	local result = MySQL.query.await("SELECT owner, name FROM ox_inventory WHERE NOT owner = ''")
	local parameters = {}

	for i = 1, #result do
		local data = result[i]
		local snip = data.name:sub(-#data.owner, #data.name)

		if data.owner == snip then
			data.name = data.name:sub(0, #data.name - #snip)
			parameters[i] = { data.name, snip }
		end
	end

	if #parameters > 1 then
		MySQL.prepare.await("UPDATE ox_inventory SET name = ? WHERE owner = ?", parameters)
	else
		print("Remove 'setup/dbcleanup.lua' from fxmanifest.lua")
	end
end)
