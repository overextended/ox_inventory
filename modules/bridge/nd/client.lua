RegisterNetEvent("ND:setCharacter", function(character)
    local groups = {}
    for group, info in pairs(character.groups) do
        groups[group] = info.lvl
    end
    OnPlayerData("groups", groups)
end)