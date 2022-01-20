if server.versioncheck then
    CreateThread(function()
        Wait(1000)
        local resource = GetCurrentResourceName()
        local url = GetResourceMetadata(resource, 'repository', 0)
        local version = GetResourceMetadata(resource, 'version', 0)

        PerformHttpRequest(('%s/master/fxmanifest.lua'):format(url:gsub('github.com', 'raw.githubusercontent.com')), function(error, response)
            if error == 200 and response then
                local latest = response:match('%d%.%d+%.%d+')
                if version < latest then
                    print(('^3An update is available for ox_inventory - please download the latest release (current version: %s)'):format(latest, version))
print([[^3	- https://github.com/overextended/ox_inventory/releases
	- rebalanced weapon durability loss
	- support multiple police jobs
	- player inventories no longer "lock" after using a container
	- remove invalid durability when loading an inventory
	- all weapons are removed from players when disarming
	- various tweaks to code flow and structure
^0]])
                end
            end
        end, 'GET')
    end)
end
