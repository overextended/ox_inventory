if server.versioncheck then
	SetTimeout(1000, function()
		PerformHttpRequest('https://api.github.com/repos/overextended/ox_inventory/releases/latest', function(status, response)
			if status ~= 200 then return end

			response = json.decode(response)
			if response.prerelease then return end

			local currentVersion = GetResourceMetadata(shared.resource, 'version', 0):match('%d%.%d+%.%d+')
			if not currentVersion then return end

			local latestVersion = response.tag_name:match('%d%.%d+%.%d+')
			if not latestVersion then return end

			if currentVersion >= latestVersion then return end

			print(('^3An update is available for %s (current version: %s)\r\n%s^0'):format(shared.resource, currentVersion, response.html_url))
		end, 'GET')
	end)
end
