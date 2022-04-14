local Interface = {}
local input

function Interface.Keyboard(header, rows)
	if input then return end
	input = promise.new()

	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'openInput',
		data = {
			header = header,
			rows = rows
		}
	})

	return Citizen.Await(input)
end
exports('Keyboard', Interface.Keyboard)

RegisterNUICallback('inputData', function(data, cb)
	cb(1)
	if not input then return end
	if not data then input:resolve() else input:resolve(data) end
	SetNuiFocus(false, false)
	input = nil
end)

-- Replace ox_inventory progressbar with ox_lib (backwards compatibility)
exports('Progress', function(options, completed)
	local success = lib.progressBar(options)

	if completed then
		completed(success == true and false)
	end
end)

exports('CancelProgress', lib.cancelProgress)
exports('ProgressActive', lib.progressActive)

client.interface = Interface