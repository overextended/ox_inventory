CreateThread(function()
    local resourceName = GetCurrentResourceName()
    local currentVersion, latestVersion = GetResourceMetadata(resourceName, 'version')
    local outdated = '^3[version]^7 You can upgrade to ^2v%s^7 (currently using ^1v%s^7 - refresh after updating)'
    Citizen.Wait(2000)
    while Config.CheckVersion do
        Citizen.Wait(0)
        PerformHttpRequest(GetResourceMetadata(resourceName, 'versioncheck'), function (errorCode, resultData, resultHeaders)
            if errorCode ~= 200 then print("Returned error code:" .. tostring(errorCode)) else
                local data, version = tostring(resultData)
                for line in data:gmatch("([^\n]*)\n?") do
                    if line:find('^version ') then version = line:sub(10, (line:len(line) - 2)) break end
                end         
                latestVersion = version
            end
        end)
        if latestVersion then 
            if currentVersion ~= latestVersion then
                print(outdated:format(latestVersion, currentVersion))
            end
            Citizen.Wait(60000*Config.CheckVersionDelay)
        end
    end
end)
