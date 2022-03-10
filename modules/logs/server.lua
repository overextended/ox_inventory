local key = GetConvar('datadog:key', '')

if key ~= '' then
	local site = ('https://http-intake.logs.%s/api/v2/logs'):format(GetConvar('datadog:site', 'datadoghq.com'))

	local response = {
		[400] = 'bad request',
		[401] = 'unauthorized',
		[403] = 'forbidden',
		[408] = 'request timeout',
		[413] = 'payload too large',
		[429] = 'too many requests',
		[500] = 'internal server error',
		[503] = 'service unavailable'
	}

	function server.logs(message, source, ...)
		local ddtags = string.strjoin(',', string.tostringall(...))
		PerformHttpRequest(site, function(status)
			if status ~= 202 then
				print(('unable to submit logs to %s (%s)'):format(site, response[status]))
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
end

if not server.logs then
	function server.logs() end
end
