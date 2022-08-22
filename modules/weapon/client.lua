local Weapon = {}
local Utils = client.utils
client.weapon = Weapon

function Weapon.Equip(item, data)
	local playerPed = cache.ped

	---@todo rewrite and improve animations; support different animations for weapon types
	if client.weaponanims then
		local coords = GetEntityCoords(playerPed, true)
		local sleep = (client.hasGroup(shared.police) and (GetWeapontypeGroup(data.hash) == 416676503 or GetWeapontypeGroup(data.hash) == 690389602)) and 400 or 1200

		if item.hash == `WEAPON_SWITCHBLADE` then
			Utils.PlayAnimAdvanced(sleep*2, 'anim@melee@switchblade@holster', 'unholster', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 48, 0.1)
			Wait(100)
		else
			Utils.PlayAnimAdvanced(sleep*2, sleep == 400 and 'reaction@intimidation@cop@unarmed' or 'reaction@intimidation@1h', 'intro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 50, 0.1)
			Wait(sleep)
		end
	end

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
	SetCurrentPedWeapon(playerPed, data.hash, true)
	SetPedCurrentWeaponVisible(playerPed, true, false, false, false)
	AddAmmoToPed(playerPed, data.hash, item.metadata.ammo or 100)
	Wait(0)
	RefillAmmoInstantly(playerPed)

	if data.hash == `WEAPON_PETROLCAN` or data.hash == `WEAPON_HAZARDCAN` or data.hash == `WEAPON_FIREEXTINGUISHER` then
		item.metadata.ammo = item.metadata.durability
		SetPedInfiniteAmmo(playerPed, true, data.hash)
	end

	TriggerEvent('ox_inventory:currentWeapon', item)
	Utils.ItemNotify({item.metadata.label or item.label, item.metadata.image or item.name, shared.locale('equipped')})

	return item
end
