local path, timestamp, date, time = GetResourcePath(Config.Resource)
path = path:gsub('//', '/')..'/'

Citizen.CreateThread(function()
	while Status ~= 'ready' do Citizen.Wait(1000) end
	local ok, error, code = os.rename(path..'logs', path..'logs')
	if not ok then
		Config.Logs = false
		if code == 2 then print('^1[warning]^3 Unable to start logging, as the directory does not exist ('..path..'logs/'..')^7')
		elseif code == 13 then print('^1[warning]^3 Unable to start logging, insufficient permissions to write to ('..path..'logs/'..')^7') end
	end
	while true do
		timestamp = os.date('%Y-%m-%d | %I:%M:%S %p')
		date, time = timestamp:match("([^ |]+) | ([^| ]+)")
		Citizen.Wait(1000)
	end
end)


local Logs = {}
--local Discord = {}


local NewFile = function(type)
	local file = "logs/"..date.."-"..type..".txt"
	Logs[type] = io.open(path..file, 'a')
end

CreateLog = function(playerId, targetId, message, type)
	local xPlayer, xTarget = Inventories[playerId], targetId and Inventories[targetId] or false
	if xPlayer and message then
		Citizen.CreateThread(function()
			if not Logs[type] then NewFile(type) end
			io.output(Logs[type])
			if not type then type = 'log' end
			if xTarget ~= false then
				output = ('[%s]	[%s] %s (%s) %s [%s] %s (%s)\n'):format(timestamp, xPlayer.id, xPlayer.name, xPlayer.identifier, message, xTarget.id, xTarget.name, xTarget.identifier)
				--todo: discord logging
			else
				output = ('[%s]	[%s] %s (%s) %s\n'):format(timestamp, xPlayer.id, xPlayer.name, xPlayer.identifier, message)
				--todo: discord logging
			end
			io.write(output)
		end)
	end
end
