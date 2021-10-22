if Config.Logs then
	local io = io
	local os = os
	local day, month, year = string.strsplit('-', os.date('%d-%B-%Y'))
	local path = GetResourcePath(ox.name):gsub('//', '/')
	path = ('%s/modules/logs'):format(path)

	local _format = string.format

	local function init()
		local file = _format('%s-%s-%s.json', year, month, day)
		local system = os.getenv('OS')
		if system and system:match('Windows') then
			path = path:gsub('/', '\\')
			os.execute(_format('mkdir %s\\%s\\%s', path, year, month))
			return io.open(_format('%s\\%s\\%s\\%s', path, year, month, file), 'a+')
		else
			os.execute(_format('mkdir -p %s/%s/%s', path, year, month))
			return io.open(_format('%s/%s/%s/%s', path, year, month, file), 'a+')
		end
	end

	local file = init()

	if file then
		local time = '%H:%M:%S'
		local message = _format('\r{ "date": "%s/%s/%s", "time": "%s", "source": "%s", "content": "%s" },', day, month:sub(0, 3), year, '%s', '%s [%s] - %s', '%s')

		local write = function(inv, target, ...)
			local content = string.strjoin(' ', string.tostringall(...))
			file:write(_format(message, os.date(time), inv.label, inv.id, target or inv.owner or inv.name, content))
		end

		return write
	end
	ox.warning('Unable to initilise logging module')
end

local function write() return end
return write