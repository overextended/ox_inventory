local path, timestamp, date, time = GetResourcePath(Config.Resource)
path = path:gsub('//', '/')..'/'

local logsType = 'discord' -- okay if your server is small
Citizen.CreateThread(function()
	while Status ~= 'ready' do Citizen.Wait(1000) end
	if logsType ~= 'discord' then
		local ok, error, code = os.rename(path..'logs', path..'logs')
		if not ok then
			Config.Logs = false
			if code == 2 then print('^1[warning]^3 Unable to start logging, as the directory does not exist ('..path..'logs/'..')^7')
			elseif code == 13 then print('^1[warning]^3 Unable to start logging, insufficient permissions to write to ('..path..'logs/'..')^7') end
		end
	end
	while true do
		timestamp = os.date('%Y-%m-%d | %I:%M:%S %p')
		if logsType ~= 'discord' then date, time = timestamp:match("([^ |]+) | ([^| ]+)") end
		Citizen.Wait(1000)
	end
end)

local NewFile = function(type)
	local file = "logs/"..date.."-"..type..".txt"
	Logs[type] = io.open(path..file, 'a')
end

local _ = function(str)
	return str:sub(1,1):upper()..str:sub(2)
end

local Logs = {}

local Discord = {
	bag		 = "https://discord.com/api/webhooks/",
	drop	 = "https://discord.com/api/webhooks/",
	dumpster = "https://discord.com/api/webhooks/",
	glovebox = "https://discord.com/api/webhooks/",
	player	 = "https://discord.com/api/webhooks/",
	stash	 = "https://discord.com/api/webhooks/",
	trunk	 = "https://discord.com/api/webhooks/",

	-- Set types of shops to be logged in the buyitem event
	shop	 = "https://discord.com/api/webhooks/",
}

local Webhook = function(type, output, identifier)
	local url = Discord[type]
	if url then
		local embed = {
			{
				["color"] = "7419530",
				["title"] = output,
				["description"] = identifier,
				["footer"] = {
					["text"] = timestamp,
					["icon_url"] = "https://probot.media/ECZ8THPFXX.png",
				},
			}
		}
		local user = _(type)..' Logs'
		PerformHttpRequest(url, function(err, text, headers)
			end, 'POST', json.encode({ username = user, embeds = embed}), { ['Content-Type'] = 'application/json' }
		)
	end
end

if logsType ~= 'discord' then
	CreateLog = function(playerId, targetId, message, type)
		local xPlayer, xTarget = Inventories[playerId], targetId and Inventories[targetId] or false
		if xPlayer and message then
			Citizen.CreateThread(function()
				if not Logs[type] then NewFile(type) end
				io.output(Logs[type])
				if not type then type = 'log' end
				if xTarget ~= false then
					output = ('[%s]	[%s] %s (%s) %s [%s] %s (%s)\n'):format(timestamp, xPlayer.id, xPlayer.name, xPlayer.identifier, message, xTarget.id, xTarget.name, xTarget.identifier)
				else
					output = ('[%s]	[%s] %s (%s) %s\n'):format(timestamp, xPlayer.id, xPlayer.name, xPlayer.identifier, message)
				end
				io.write(output)
			end)
		end
	end
else
	CreateLog = function(playerId, targetId, message, type)
		if Discord[type] then
			local xPlayer, xTarget = Inventories[playerId], targetId and Inventories[targetId] or false
			if xPlayer and message then
				Citizen.CreateThread(function()
					if xTarget then
						local output = ('[%s] %s\n%s\n[%s] %s'):format(xPlayer.id, xPlayer.name, message, xTarget.id, xTarget.name)
						Webhook(type, output, xPlayer.identifier..'\n'..xTarget.identifier)
					else
						local output = ('[%s] %s\n%s'):format(xPlayer.id, xPlayer.name, message)
						Webhook(type, output, xPlayer.identifier)
					end
				end)
			end
		end
	end
end
