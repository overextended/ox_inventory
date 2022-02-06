if server.versioncheck then
	CreateThread(function()
		Wait(1000)
		local resource = GetCurrentResourceName()
		local url = GetResourceMetadata(resource, 'repository', 0)
		local version = GetResourceMetadata(resource, 'version', 0)

		PerformHttpRequest(('%s/master/fxmanifest.lua'):format(url:gsub('github.com', 'raw.githubusercontent.com')), function(status, response)
			if response and status == 200 then
				local latest = response:match('%d%.%d+%.%d+')
				if version < latest then
					print(('^3An update is available for ox_inventory - please download the latest release (current version: %s)'):format(latest, version))
					print('^3	- https://github.com/overextended/ox_inventory/releases^0')
				end
			end
		end, 'GET')
	end)
end
