if not lib then return end

local Utils = {}

local webHook = GetConvar('inventory:webhook', '')

if webHook ~= '' then
	local validExtensions = {
		['png'] = true,
		['apng'] = true,
		['webp'] = true,
	}

	local headers = { ['Content-Type'] = 'application/json' }

	function Utils.IsValidImageUrl(url)
        local isUri = url:match("^nui://.+")
        if isUri then
            local resource, extension = url:match('^nui://([^/]+)/.-%.(%l+)$')

            if not resource or not extension then return false end

            local resourceState = GetResourceState(resource)
            if resourceState ~= 'started' then return false end

            return validExtensions[extension]
        end

        local isUrl = url:match("^https?://.+")
        if isUrl then
            local host, extension = url:match('^https?://([^/]+).+%.([%l]+)')

            if not host or not extension then return false end

            return server.validhosts[host] and validExtensions[extension]
        end

        return false
	end

	---@param title string
	---@param message string
	---@param image string
	function Utils.DiscordEmbed(title, message, image, color)
		PerformHttpRequest(webHook, function() end, 'POST', json.encode({
			username = 'ox_inventory', embeds = {
				{
					title = title,
					color = color,
					footer = {
						text = os.date('%c'),
					},
					description = message,
					thumbnail = {
						url = image,
						width = 100,
					}
				}
			}
		}), headers)
	end
end

return Utils
