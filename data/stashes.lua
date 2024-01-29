---wip types

---@class OxStash
---@field name string
---@field label string
---@field owner? boolean | string | number
---@field slots number
---@field weight number
---@field groups? string | string[] | { [string]: number }
---@field blip? { id: number, colour: number, scale: number }
---@field coords? vector3
---@field target? { loc: vector3, length: number, width: number, heading: number, minZ: number, maxZ: number, distance: number, debug?: boolean, drawSprite?: boolean }

return {
	--[[{
		coords = vec3(-1.15, -1811.56, 25.35),
		target = {
			loc = vec3(-1.15, -1811.56, 25.35),
			length = 0.2,
			width = 5.6,
			heading = 0,
			minZ = 29.49,
			maxZ = 32.09,
			label = 'Open Stash'
		},
		name = 'esb_lockers',
		label = 'The Little Balla Stash',
		owner = true,
		slots = 140,
		weight = 1000000,
		groups = { ['grove'] = 0 }
	}]]
}
