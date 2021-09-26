local Disable = {}
local Active = false

local canCancel, anim, scenario, prop, propTwo, progressCallback = false, false, false, false, false, nil

local PlayerReset = function()
    if anim or scenario then
        ClearPedTasks(ESX.PlayerData.ped)
		Disable = {}
    end
    if prop and NetToObj(prop) ~= 0 and NetToObj(prop) ~= nil then
        DetachEntity(NetToObj(prop), 1, 1)
        DeleteEntity(NetToObj(prop))
        prop = false
    end
    if propTwo and NetToObj(propTwo) ~= 0 and NetToObj(propTwo) ~= nil then
        DetachEntity(NetToObj(propTwo), 1, 1)
        DeleteEntity(NetToObj(propTwo))
    	propTwo = false
    end
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
			prop = false
			propTwo = false

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

			if options.prop ~= nil and not prop then
				local model = options.prop.model

				RequestModel(model)

				local modelHash = joaat(model)
				while not HasModelLoaded(modelHash) do
					Wait(0)
				end

				local pCoords = GetOffsetFromEntityInWorldCoords(ESX.PlayerData.ped, 0.0, 0.0, 0.0)
				local modelSpawn = CreateObject(modelHash, pCoords.x, pCoords.y, pCoords.z, true, true, true)

				local netid = ObjToNet(modelSpawn)
				SetNetworkIdExistsOnAllMachines(netid, true)
				NetworkSetNetworkIdDynamic(netid, true)
				SetNetworkIdCanMigrate(netid, false)


				if options.prop.bone == nil then
					options.prop.bone = 60309
				end

				if options.prop.pos == nil then
					options.prop.pos = { x = 0.0, y = 0.0, z = 0.0 }
				end

				if options.prop.rot == nil then
					options.prop.rot = { x = 0.0, y = 0.0, z = 0.0 }
				end

				AttachEntityToEntity(modelSpawn, ESX.PlayerData.ped, GetPedBoneIndex(ESX.PlayerData.ped, options.prop.bone), options.prop.pos.x, options.prop.pos.y, options.prop.pos.z, options.prop.rot.x, options.prop.rot.y, options.prop.rot.z, 1, 1, 0, 1, 0, 1)
				prop = netid

				SetModelAsNoLongerNeeded(model)
			end

			if options.propTwo ~= nil then
				local model = options.propTwo.model

				RequestModel(model)

				local modelHash = joaat(model)
				while not HasModelLoaded(modelHash) do
					Wait(0)
				end

				local pCoords = GetOffsetFromEntityInWorldCoords(ESX.PlayerData.ped, 0.0, 0.0, 0.0)
				local modelSpawn = CreateObject(modelHash, pCoords.x, pCoords.y, pCoords.z, true, true, true)

				local netid = ObjToNet(modelSpawn)
				SetNetworkIdExistsOnAllMachines(netid, true)
				NetworkSetNetworkIdDynamic(netid, true)
				SetNetworkIdCanMigrate(netid, false)
				if options.propTwo.bone == nil then
					options.propTwo.bone = 60309
				end

				if options.propTwo.pos == nil then
					options.propTwo.pos = { x = 0.0, y = 0.0, z = 0.0 }
				end

				if options.propTwo.rot == nil then
					options.propTwo.rot = { x = 0.0, y = 0.0, z = 0.0 }
				end

				AttachEntityToEntity(modelSpawn, ESX.PlayerData.ped, GetPedBoneIndex(ESX.PlayerData.ped, options.propTwo.bone), options.propTwo.coords.x, options.propTwo.coords.y, options.propTwo.coords.z, options.propTwo.rotation.x, options.propTwo.rotation.y, options.propTwo.rotation.z, 1, 1, 0, 1, 0, 1)
				propTwo = netid

				SetModelAsNoLongerNeeded(model)
			end
			Disable = options.disable or table.wipe(Disable)
		end
	end
end

exports('Progress', Start)
exports('CancelProgress', Cancelled)
exports('ProgressActive', function() return Active end)

RegisterNUICallback('progressComplete', function()
    Completed()
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