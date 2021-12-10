local Interface = {}
local input

--[[ Example:
RegisterCommand('test', function()
	local data = Keyboard.Input('Evidence Locker', {'Locker number', 'Locker name'})
	print(ESX.DumpTable(data)) -- data[1] first input field, data[2] second, etc...
end)
]]--

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

local progress = {
	mouse = {1, 2, 106},
	move = {21, 30, 31, 36},
	car = {63, 64, 71, 72, 75},
	combat = {25},
	disable = {},
	anim = false,
	scenario = false,
	callback = false,
	prop1 = false,
	prop2 = false,
	canCancel = false
}

Interface.ProgressActive = false

local DisableControlActions = import 'controls'

local function ResetPlayer()
	if progress.anim or progress.scenario then
		ClearPedTasks(PlayerData.ped)
	end

	for i=1, 2 do
		local prop = progress['prop'..i]
		if prop then
			prop = NetToObj(prop)
			DetachEntity(prop)
			DeleteEntity(prop)
		end
	end

	if #progress.disable > 0 then DisableControlActions:Remove(progress.disable) end
	table.wipe(progress.disable)
	Interface.ProgressActive = false
	progress.anim = false
end

local function Complete(cancel)
	if Interface.ProgressActive then
		if cancel and progress.canCancel then
			progress.callback(true)
			SendNUIMessage({ action = 'cancelProgress', })
		elseif not cancel then
			progress.callback(false)
		end
		ResetPlayer()
	end
end

function Interface.Progress(options, completed)
	if Interface.ProgressActive == false then
		progress.callback = completed
		if not IsEntityDead(PlayerData.ped) or options.useWhileDead then
			if options.disable then
				local count = 0
				for k in pairs(options.disable) do
					local keys = progress[k]
					for i=1, #keys do
						count += 1
						progress.disable[count] = keys[i]
					end
				end
				if count > 0 then DisableControlActions:Add(progress.disable) end
			end

			Interface.ProgressActive = true
			progress.canCancel = options.canCancel or false

			SendNUIMessage({
				action = 'startProgress',
				data = {
					text = options.label,
					duration = options.duration
				}
			})

			if options.anim then
				if options.anim.dict then
					lib:requestAnimDict(options.anim.dict)
					TaskPlayAnim(PlayerData.ped, options.anim.dict, options.anim.clip, 3.0, 1.0, -1, options.anim.flag or 1, 0, false, false, false)
					progress.anim = true
				end

				if options.anim.scenario and not options.anim.dict then
					TaskStartScenarioInPlace(PlayerData.ped, options.anim.scenario, 0, true)
					progress.scenario = true
				end
			end

			for i=1, 2 do
				local option = i==1 and options.prop or options.propTwo
				if option then
					local model = option.model
					model = type(model) == 'string' and joaat(model) or model

					lib:requestModel(model)

					local pCoords = GetOffsetFromEntityInWorldCoords(PlayerData.ped, 0.0, 0.0, 0.0)
					local modelSpawn = CreateObject(model, pCoords.x, pCoords.y, pCoords.z, true, true, true)

					local netid = ObjToNet(modelSpawn)
					SetNetworkIdExistsOnAllMachines(netid, true)
					NetworkSetNetworkIdDynamic(netid, true)
					SetNetworkIdCanMigrate(netid, false)

					AttachEntityToEntity(modelSpawn, PlayerData.ped, GetPedBoneIndex(PlayerData.ped, option.bone or 60309), option.pos.x or 0.0, option.pos.y or 0.0, option.pos.z or 0.0, option.rot.x or 0.0, option.rot.y or 0.0, option.rot.z or 0.0, 1, 1, 0, 1, 0, 1)
					progress['prop'..i] = netid
					SetModelAsNoLongerNeeded(model)
				end
			end
		end
	end
end

exports('Progress', Interface.Progress)
exports('CancelProgress', function() Complete(true) end)
exports('ProgressActive', function() return Interface.ProgressActive end)

RegisterNUICallback('progressComplete', function(data, cb)
	Complete()
	cb(1)
end)

RegisterCommand('cancelprogress', function()
	if Interface.ProgressActive and progress.canCancel then
		Complete(true)
	end
end)

RegisterKeyMapping('cancelprogress', 'Cancel current progress bar', 'keyboard', 'x')
TriggerEvent('chat:removeSuggestion', '/cancelprogress')

client.interface = Interface