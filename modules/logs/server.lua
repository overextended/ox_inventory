local key = GetConvar('datadog:key', '')
local response = {
	[400] = 'bad request',
	[401] = 'unauthorized',
	[403] = 'forbidden',
	[404] = 'not found',
	[405] = 'method not allowed',
	[408] = 'request timeout',
	[413] = 'payload too large',
	[429] = 'too many requests',
	[500] = 'internal server error',
	[502] = 'gateway unavailable',
	[503] = 'service unavailable'
}

if key ~= '' then
	local site = ('https://http-intake.logs.%s/api/v2/logs'):format(GetConvar('datadog:site', 'datadoghq.com'))

	function server.logs(message, source, ...)
		local ddtags = string.strjoin(',', string.tostringall(...))
		PerformHttpRequest(site, function(status)
			if status ~= 202 then
				print(('unable to submit logs to %s (%s)'):format(site, response[status] or status))
			end
		end, 'POST', json.encode({
			hostname = GetConvar('datadog:hostname', 'FXServer'),
			service = shared.resource,
			message = message,
			ddsource = source,
			ddtags = ddtags
		}), {
			['Content-Type'] = 'application/json',
			['DD-API-KEY'] = key
		})
	end
else
	local webhook = GetConvar('inventory:discordWebhook', '')

	if webhook ~= '' then
		function server.logs(message, source, ...)
			PerformHttpRequest(webhook, function(status)
				if status ~= 204 then
					if status == 429 then
						print('congratulations, you\'re being rate limited by Discord after submitting too many logs')
					else
						print(('unable to submit logs to discord (%s)'):format(status))
					end
				end
			end, 'POST', json.encode({
				username = shared.resource,
				embeds = {{
					color = 16705372,
					title = source,
					description = message,
					fields = ... and {{
						name = 'Tags',
						value = string.strjoin(', ', string.tostringall(...))
					}},
					footer = {
						text = os.date(),
						icon_url = 'https://avatars.githubusercontent.com/u/88127058?s=200&v=4'
					}
				}}
			}), { ['Content-Type'] = 'application/json' })
		end
	end
end

if not server.logs then
	function server.logs() end
end
