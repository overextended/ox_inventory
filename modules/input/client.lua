local M = {}
local p = nil

M.Input = function(header, rows)

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

exports('Keyboard', M.Input)

RegisterNUICallback('ox_inventory:inputData', function(data, cb)
    if not data then p:resolve() else p:resolve(data) end
    print('focus set')
    SetNuiFocus(false, false)
    p = nil
    cb({})
end)

--[[ Example:
RegisterCommand('test', function()
	local data = Keyboard.Input('Evidence Locker', {'Locker number', 'Locker name'})
	print(ESX.DumpTable(data)) -- data[1] first input field, data[2] second, etc...
end)
]]--

return M