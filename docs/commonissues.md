**When I die I am unable to open my inventory**

- You are not triggering the proper ESX event when spawning after death. `TriggerEvent('esx:onPlayerSpawn')`
- This is likely due to an outdated esx_ambulancejob or similar

**I receive an error about calling a nil function (setAccount)**

- You have not applied the necessary modifications to ESX or are not using the Overextended fork

**Calling my inventory from another resource returns empty**

- You need to use xPlayer.getInventory() to retrieve the player inventory

**Buying items does not remove my money**

- It does. Shops take money out of bank by default.
