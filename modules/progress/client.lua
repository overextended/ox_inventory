local Disable = {}
local Active = false

local canCancel, anim, scenario, progressCallback = false, false, false, nil
local prop = table.create(2, 0)

local PlayerReset = function()
    if anim or scenario then
        ClearPedTasks(ESX.PlayerData.ped)
		Disable = table.wipe(Disable)
    end
	for i=1, #prop do
		local entity = NetToObj(prop[i])
		DetachEntity(entity, 1, 1)
		DeleteEntity(entity)
	end
	prop = table.wipe(prop)
	Active = false
end

local Completed = function()
	if Active then
		progressCallback(false)
		PlayerReset()
	end
end

local Cancelled = function()
	if Active and canCancel then
		progressCallback(true)
		PlayerReset()
		SendNUIMessage({ action = 'cancelProgress', })
	end
end

local Start = function(options, completed)
	if Active == false then
		progressCallback = completed
		if not IsEntityDead(ESX.PlayerData.ped) or options.useWhileDead then
			Active = true
			anim = false

			canCancel = options.canCancel or false

			SendNUIMessage({
				action = 'startProgress',
				data = {
					text = options.label,
					duration = options.duration
				}
			})

			if options.anim then
				if options.anim.dict then
					RequestAnimDict(options.anim.dict)

					while not HasAnimDictLoaded(options.anim.dict) do Wait(0) end

					if options.anim.flag == nil then options.anim.flag = 1 end
					TaskPlayAnim(ESX.PlayerData.ped, options.anim.dict, options.anim.clip, 3.0, 1.0, -1, options.anim.flag, 0, false, false, false)
					anim = true
				end

				if options.anim.scenario and not options.anim.dict then
					TaskStartScenarioInPlace(ESX.PlayerData.ped, options.anim.scenario, 0, true)
					scenario = true
				end

				RemoveAnimDict(options.anim.dict)
			end

			for i=1, 2 do
				local option = i==1 and options.prop or options.propTwo
				if option then

					local model = option.model
					model = type(model) == 'string' and joaat(model) or model

					RequestModel(model)
					while not HasModelLoaded(model) do Wait(0) end

					local pCoords = GetOffsetFromEntityInWorldCoords(ESX.PlayerData.ped, 0.0, 0.0, 0.0)
					local modelSpawn = CreateObject(model, pCoords.x, pCoords.y, pCoords.z, true, true, true)

					local netid = ObjToNet(modelSpawn)
					SetNetworkIdExistsOnAllMachines(netid, true)
					NetworkSetNetworkIdDynamic(netid, true)
					SetNetworkIdCanMigrate(netid, false)

					AttachEntityToEntity(modelSpawn, ESX.PlayerData.ped, GetPedBoneIndex(ESX.PlayerData.ped, option.bone or 60309), option.pos.x or 0.0, option.pos.y or 0.0, option.pos.z or 0.0, option.rot.x or 0.0, option.rot.y or 0.0, option.rot.z or 0.0, 1, 1, 0, 1, 0, 1)
					prop[i] = netid

					SetModelAsNoLongerNeeded(model)
				end
			end
			Disable = options.disable or table.wipe(Disable)
		end
	end
end

exports('Progress', Start)
exports('CancelProgress', Cancelled)
exports('ProgressActive', function() return Active end)

RegisterNUICallback('progressComplete', function(data, cb)
    Completed()
	cb(1)
end)

RegisterCommand('cancelprogress', function()
    if Active and canCancel then
        Cancelled()
    end
end)

RegisterKeyMapping('cancelprogress', 'Cancel current progress bar', 'keyboard', 'x')
TriggerEvent('chat:removeSuggestion', '/cancelprogress')

return {
	Active = Active, Disable = Disable, Start = Start
}