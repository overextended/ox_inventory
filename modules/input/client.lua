local p = nil

local function Input(header, rows)

	if p then return end
	
	p = promise.new()

	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'openInput',
		data = {
			header = header,
			rows = rows
		}
	})

	return Citizen.Await(p)
end

exports('Keyboard', Input)

RegisterNUICallback('inputData', function(data, cb)
	cb(1)
	if not p then return end
	if not data then p:resolve() else p:resolve(data) end
	SetNuiFocus(false, false)
	p = nil
end)

--[[ Example:
RegisterCommand('test', function()
	local data = Keyboard.Input('Evidence Locker', {'Locker number', 'Locker name'})
	print(ESX.DumpTable(data)) -- data[1] first input field, data[2] second, etc...
end)
]]--

return {
	Input = Input
}