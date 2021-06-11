if Config.CheckVersion then
	local resource = GetCurrentResourceName()
	local version, latest = GetResourceMetadata(resource, 'version')
	local outdated = '^3[version]^7 You can upgrade to ^2v%s^7 (currently using ^1v%s^7 - refresh after updating)'

	VersionCheck = function()
		PerformHttpRequest(GetResourceMetadata(resource, 'versioncheck'), function (errorCode, resultData, resultHeaders)
			if errorCode ~= 200 then print("Returned error code:" .. tostring(errorCode)) else
				local data, version = tostring(resultData)
				for line in data:gmatch("([^\n]*)\n?") do
					if line:find('^version ') then version = line:sub(10, (line:len(line) - 2)) break end
				end         
				latest = version
			end
		end)
		if latest then 
			if version ~= latest then
				print(outdated:format(latest, version))
			end
		end

		SetTimeout(60000*Config.CheckVersionDelay, VersionCheck)
	end

	SetTimeout(5000, VersionCheck)
end
