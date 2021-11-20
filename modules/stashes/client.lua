local M = data('stashes')

setmetatable(M, {
	__call = function()
		for _, stash in pairs(M) do
			if Config.Target then
				local OpenStash = function(data) TriggerEvent('ox_inventory:openInventory', 'stash', data) end
				exports.qtarget:RemoveZone(stash.name)
				exports.qtarget:AddBoxZone(stash.name, stash.target.loc, stash.target.length or 0.5, stash.target.width or 0.5,
				{
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
							job = stash.jobs,
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
})

return M