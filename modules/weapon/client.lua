if not lib then return end

local Weapon = {}
local Items = client.items
local Utils = client.utils
client.weapon = Weapon

-- generic group animation data
local anims = {}
anims[`GROUP_MELEE`] = { 'melee@holster', 'unholster', 200, 'melee@holster', 'holster', 600 }
anims[`GROUP_PISTOL`] = { 'reaction@intimidation@cop@unarmed', 'intro', 400, 'reaction@intimidation@cop@unarmed', 'outro', 450 }
anims[`GROUP_STUNGUN`] = anims[`GROUP_PISTOL`]

local function vehicleIsCycle(vehicle)
	local class = GetVehicleClass(vehicle)
	return class == 8 or class == 13
end

function Weapon.Equip(item, data)
	local playerPed = cache.ped

	if client.weaponanims then
		if cache.vehicle and vehicleIsCycle(cache.vehicle) then
			goto skipAnim
		end

		local coords = GetEntityCoords(playerPed, true)
		local anim = data.anim or anims[GetWeapontypeGroup(data.hash)]

		if anim == anims[`GROUP_PISTOL`] and not client.hasGroup(shared.police) then
			anim = nil
		end

		local sleep = anim and anim[3] or 1200

		Utils.PlayAnimAdvanced(sleep*2, anim and anim[1] or 'reaction@intimidation@1h', anim and anim[2] or 'intro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 50, 0.1)
		Wait(sleep)
	end

	::skipAnim::

	SetPedAmmo(playerPed, data.hash, 0)
	GiveWeaponToPed(playerPed, data.hash, 0, false, true)

	if item.metadata.tint then SetPedWeaponTintIndex(playerPed, data.hash, item.metadata.tint) end

	if item.metadata.components then
		for i = 1, #item.metadata.components do
			local components = Items[item.metadata.components[i]].client.component
			for v=1, #components do
				local component = components[v]
				if DoesWeaponTakeWeaponComponent(data.hash, component) then
					if not HasPedGotWeaponComponent(playerPed, data.hash, component) then
						GiveWeaponComponentToPed(playerPed, data.hash, component)
					end
				end
			end
		end
	end

	item.hash = data.hash
	item.ammo = data.ammoname
	item.melee = (not item.throwable and not data.ammoname) and 0
	item.timer = 0

	if data.throwable then item.throwable = true end

	SetCurrentPedWeapon(playerPed, data.hash, true)
	SetPedCurrentWeaponVisible(playerPed, true, false, false, false)
	AddAmmoToPed(playerPed, data.hash, item.metadata.ammo or 100)
	Wait(0)
	RefillAmmoInstantly(playerPed)
	SetWeaponsNoAutoswap(true)

	if data.hash == `WEAPON_PETROLCAN` or data.hash == `WEAPON_HAZARDCAN` or data.hash == `WEAPON_FIREEXTINGUISHER` then
		item.metadata.ammo = item.metadata.durability
		SetPedInfiniteAmmo(playerPed, true, data.hash)
	end

	TriggerEvent('ox_inventory:currentWeapon', item)
	Utils.ItemNotify({item.metadata.label or item.label, item.metadata.image or item.name, 'ui_equipped'})

	return item
end

function Weapon.Disarm(currentWeapon, noAnim)
	if source == '' then
		TriggerServerEvent('ox_inventory:updateWeapon')
	end

	if currentWeapon then
		SetPedAmmo(cache.ped, currentWeapon.hash, 0)

		if client.weaponanims and not noAnim then
			if cache.vehicle and vehicleIsCycle(cache.vehicle) then
				goto skipAnim
			end

			ClearPedSecondaryTask(cache.ped)

			local item = Items[currentWeapon.name]
			local coords = GetEntityCoords(cache.ped, true)
			local anim = item.anim or anims[GetWeapontypeGroup(currentWeapon.hash)]

			if anim == anims[`GROUP_PISTOL`] and not client.hasGroup(shared.police) then
				anim = nil
			end

			local sleep = anim and anim[6] or 1400

			Utils.PlayAnimAdvanced(sleep, anim and anim[4] or 'reaction@intimidation@1h', anim and anim[5] or 'outro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(cache.ped), 8.0, 3.0, -1, 50, 0)
			Wait(sleep)
		end

		::skipAnim::

		Utils.ItemNotify({currentWeapon.metadata.label or currentWeapon.label, currentWeapon.metadata.image or currentWeapon.name, 'ui_holstered'})
		TriggerEvent('ox_inventory:currentWeapon')
	end

	Utils.WeaponWheel()
	RemoveAllPedWeapons(cache.ped, true)
end

function Weapon.ClearAll(currentWeapon)
	Weapon.Disarm(currentWeapon)

	if client.parachute then
		local chute = `GADGET_PARACHUTE`
		GiveWeaponToPed(cache.ped, chute, 0, true, false)
		SetPedGadget(cache.ped, chute, true)
	end
end

Utils.Disarm = Weapon.Disarm
Utils.ClearWeapons = Weapon.ClearAll
