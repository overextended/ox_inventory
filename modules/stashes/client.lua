local Stashes <const> = data('stashes')

local CreateStashes = function()
    for _, stash in pairs(Stashes) do
        -- print(ESX.DumpTable(stash))
        if Config.Target then
            local OpenStash = function(data) TriggerEvent('ox_inventory:openInventory', 'stash', data) end
            exports.qtarget:RemoveZone(stash.name)
            exports.qtarget:AddBoxZone(stash.name, stash.target.loc, stash.target.length or 0.5, stash.target.width or 0.5, {
                name=stash.name,
                heading=stash.target.heading or 0.0,
                debugPoly=false,
                minZ=stash.target.minZ,
                maxZ=stash.target.maxZ
            }, {
                options = {
                    {
                        icon = "fas fa-warehouse",
                        label = "Open Stash",
                        job = {['police'] = 1},
                        action = function()
                            OpenStash(stash)
                        end
                    },
                },
                distance = stash.target.distance or 3.0
            })
        end
    end
end

return {
    CreateStashes = CreateStashes,
    Stashes = Stashes
}