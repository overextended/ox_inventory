local M = data 'evidence'

local OpenEvidence = function()
	TriggerEvent('ox_inventory:openInventory', 'policeevidence')
end

setmetatable(M, {
	__call = function()
		for _, evidence in pairs(M) do
			if Config.Target then
				exports.qtarget:RemoveZone(evidence.target.name)
				exports.qtarget:AddBoxZone(evidence.target.name, evidence.target.loc, evidence.target.length or 0.5, evidence.target.width or 0.5,
				{
					name=evidence.target.name,
					heading=evidence.target.heading or 0.0,
					debugPoly=false,
					minZ=evidence.target.minZ,
					maxZ=evidence.target.maxZ
				}, {
					options = {
						{
							icon = "fas fa-warehouse",
							label = "Open Police Evidence",
							job = 'police',
							action = function()
								OpenEvidence()
							end
						},
					},
					distance = evidence.target.distance or 3.0
				})
			end
		end
	end
})

return M