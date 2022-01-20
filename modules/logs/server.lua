local key = GetConvar('datadog:key', '')

if key ~= '' then
	local site = GetConvar('datadog:site', 'datadoghq.com')

	function server.logs(message, source, ...)
		local ddtags = string.strjoin(',', string.tostringall(...))
		print(service, message, ddtags)
		PerformHttpRequest('https://http-intake.logs.'.. site ..'/api/v2/logs', function(status, text, header)
			if status == 202 then return end
			print(json.encode(text, {indent=true}), '\n')
			print(json.encode(header, {indent=true}), '\n')
		end, 'POST', json.encode({
			hostname = 'FXServer',
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