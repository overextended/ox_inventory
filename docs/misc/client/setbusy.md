---
title: SetBusy
---
Prevents the use of items, accessing inventories, and shooting.

!!! info
	```lua
	SetBusy(state)
	```
	```lua
	exports.ox_inventory:SetBusy(state)
	```

!!! tip "Statebag"
	In addition to updating the local variable `isBusy`, this function also sets a non-replicated statebag.

	```lua
	if LocalPlayer.state.isBusy then
		print('You are currently busy')
	end
	```