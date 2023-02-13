local function reorderGroups(groups)
    groups = groups or {}
    for group, info in pairs(groups) do
        groups[group] = info.rank
    end
    return groups
end

SetTimeout(500, function()
	NDCore = exports["ND_Core"]:GetCoreObject()

	local character = NDCore.Functions.GetSelectedCharacter()
    if character then
    	local groups = reorderGroups(character.data.groups)
    	OnPlayerData("groups", groups)
	end
end)

RegisterNetEvent("ND:setCharacter", function(character)
    local groups = reorderGroups(character.data.groups)
    OnPlayerData("groups", groups)
end)

RegisterNetEvent("ND:jobChanged", function(job, lastJob)
    local character = NDCore.Functions.GetSelectedCharacter()
    local groups = reorderGroups(character.data.groups)
    groups[lastJob.name] = nil
    groups[job.name] = job.rank

    OnPlayerData("groups", groups)
end)

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
	for name, value in pairs(values) do
        if value == 0 then
            exports["ND_Status"]:setStatus(name, value)
        else
            exports["ND_Status"]:changeStatus(name, value)
        end
    end
end
