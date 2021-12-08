if ox.logs then
	local io = io
	local os = os
	local day, month, year = string.strsplit('-', os.date('%d-%B-%Y'))
	local path = GetResourcePath(ox.resource):gsub('//', '/')
	path = ('%s/modules/logs'):format(path)

	local strformat = string.format

	local function init()
		local file = strformat('%s-%s-%s.log', year, month, day)
		local system = os.getenv('OS')
		if system and system:match('Windows') then
			path = path:gsub('/', '\\')
			os.execute(strformat('mkdir %s\\%s\\%s', path, year, month))
			return io.open(strformat('%s\\%s\\%s\\%s', path, year, month, file), 'a+')
		else
			os.execute(strformat('mkdir -p %s/%s/%s', path, year, month))
			return io.open(strformat('%s/%s/%s/%s', path, year, month, file), 'a+')
		end
	end

	local file = init()

	if file then
		month = month:sub(0, 3)
		local osdate = os.date
		local time = '%H:%M:%S'
		local message = strformat('\r{"date": "%s/%s/%s", "time": "%s", "source": "%s", "target": "%s", "content": "%s"}', day, month, year, '%s', '%s', '%s', '%s')
		local none = 'n/a'

		local function write(source, target, ...)
			local content = string.strjoin(' ', string.tostringall(...))
			file:write(strformat(message, osdate(time), source, target or none, content))
		end

		server.logs = write
		return
	end
	ox.warning('Unable to initilise logging module')
end

function server.logs() end