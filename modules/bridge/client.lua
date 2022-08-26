if not lib then return end

function client.setPlayerData(key, value)
	PlayerData[key] = value
	OnPlayerData(key, value)
end

function client.hasGroup(group)
	if not PlayerData.loaded then return end

	if type(group) == 'table' then
		for name, rank in pairs(group) do
			local groupRank = PlayerData.groups[name]
			if groupRank and groupRank >= (rank or 0) then
				return name, groupRank
			end
		end
	else
		local groupRank = PlayerData.groups[group]
		if groupRank then
			return group, groupRank
		end
	end
end

local Utils = client.utils
local Weapon = client.weapon

local function onLogout()
	if not PlayerData.loaded then return end

	if client.parachute then
		Utils.DeleteObject(client.parachute)
		client.parachute = false
	end

	client.closeInventory()
	PlayerData.loaded = false
	ClearInterval(client.interval)
	ClearInterval(client.tick)
	Weapon.Disarm()
end

if shared.framework == 'ox' then
	RegisterNetEvent('ox:playerLogout', onLogout)

	RegisterNetEvent('ox:setGroup', function(name, grade)
		PlayerData.groups[name] = grade
		OnPlayerData('groups')
	end)

elseif shared.framework == 'esx' then
	local ESX = table.create(0, 2)
	setmetatable(ESX, {
		__index = function(_, index)
			local obj = exports.es_extended:getSharedObject()
			ESX.SetPlayerData = obj.SetPlayerData
			ESX.PlayerLoaded = obj.PlayerLoaded
			return ESX[index]
		end
	})

	function client.setPlayerData(key, value)
		PlayerData[key] = value
		ESX.SetPlayerData(key, value)
	end

	function client.setPlayerStatus(values)
		for name, value in pairs(values) do
			if value > 0 then TriggerEvent('esx_status:add', name, value) else TriggerEvent('esx_status:remove', name, -value) end
		end
	end

	RegisterNetEvent('esx:onPlayerLogout', onLogout)

	AddEventHandler('esx:setPlayerData', function(key, value)
		if not PlayerData.loaded or GetInvokingResource() ~= 'es_extended' then return end

		if key == 'job' then
			key = 'groups'
			value = { [value.name] = value.grade }
		end

		PlayerData[key] = value
		OnPlayerData(key, value)
	end)

	RegisterNetEvent('esx_policejob:handcuff', function()
		PlayerData.cuffed = not PlayerData.cuffed
		LocalPlayer.state:set('invBusy', PlayerData.cuffed, false)

		if not PlayerData.cuffed then return end

		Weapon.Disarm()
	end)

	RegisterNetEvent('esx_policejob:unrestrain', function()
		PlayerData.cuffed = false
		LocalPlayer.state:set('invBusy', PlayerData.cuffed, false)
	end)

elseif shared.framework == 'qb' then
	RegisterNetEvent('QBCore:Client:OnPlayerUnload', onLogout)

	RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
		if source == '' or not PlayerData.loaded then return end

		if data.metadata.isdead ~= PlayerData.dead then
			PlayerData.dead = data.metadata.isdead
			OnPlayerData('dead', PlayerData.dead)
		end

		local groups = PlayerData.groups

		if not groups[data.job.name] or not groups[data.gang.name] or groups[data.job.name] ~= data.job.grade.level or groups[data.gang.name] ~= data.gang.grade.level then
			PlayerData.groups = {
				[data.job.name] = data.job.grade.level,
				[data.gang.name] = data.gang.grade.level,
			}

			OnPlayerData('groups', PlayerData.groups)
		end
	end)

	RegisterNetEvent('police:client:GetCuffed', function()
		PlayerData.cuffed = not PlayerData.cuffed
		LocalPlayer.state:set('invBusy', PlayerData.cuffed, false)

		if not PlayerData.cuffed then return end

		Weapon.Disarm()
	end)
end
