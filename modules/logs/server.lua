if shared.logs then
	local api = 'https://http-intake.logs.datadoghq.com/api/v2/logs'
	local key = GetConvar('datadog:key', '')

	assert(key ~= '', 'datadog:key is undefined! Ensure you have generated an API key at datadoghq.com, and set the convar.')

	function server.logs(service, message, source, ...)
		local ddtags = string.strjoin(',', string.tostringall(...))
		print(service, message, ddtags)
		PerformHttpRequest(api, function(status, text, header)
			print(202)
			if status == 202 then return end
			print(json.encode(text, {indent=true}), '\n')
			print(json.encode(header, {indent=true}), '\n')
		end, 'POST', json.encode({
			hostname = shared.resource,
			service = service,
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