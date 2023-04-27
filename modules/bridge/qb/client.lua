local onLogout, Weapon = ...
local QBCore = exports['qb-core']:GetCoreObject()
local Inventory = require 'modules.inventory.client'

RegisterNetEvent('QBCore:Client:OnPlayerUnload', onLogout)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
	if source == '' or not PlayerData.loaded then return end

	if (data.metadata.isdead or data.metadata.inlaststand) ~= PlayerData.dead then
		PlayerData.dead = data.metadata.isdead or data.metadata.inlaststand
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

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
	for name, value in pairs(values) do

		-- compatibility for ESX style values
		if value > 100 or value < -100 then
			value = value * 0.0001
		end

		if name == "hunger" then
			TriggerServerEvent('consumables:server:addHunger', QBCore.Functions.GetPlayerData().metadata.hunger + value)
		elseif name == "thirst" then
			TriggerServerEvent('consumables:server:addThirst', QBCore.Functions.GetPlayerData().metadata.thirst + value)
		elseif name == "stress" then
			if value > 0 then
				TriggerServerEvent('hud:server:GainStress', value)
			else
				value = math.abs(value)
				TriggerServerEvent('hud:server:RelieveStress', value)
			end
		end
	end
end

-- taken from qbox-core (https://github.com/Qbox-project/qb-core/blob/f4174f311aae8157181a48fa2e2bd30c8d13edb1/client/functions.lua#L25)
local function hasItem(items, amount)
    amount = amount or 1

    local count = Inventory.Search('count', items)

    if type(items) == 'table' and type(count) == 'table' then
        for _, v in pairs(count) do
            if v < amount then
                return false
            end
        end

        return true
    end

    return count >= amount
end

AddEventHandler(('__cfx_export_qb-inventory_HasItem'), function(setCB)
	setCB(hasItem)
end)
