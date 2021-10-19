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
	local string = _format([[{ "date": "%s/%s/%s", "time": "%s", "content": "%s" },
	]], day, month:sub(0, 3), year, '%s', '%s')

	local write = function(message)
		file:write(_format(string, os.date(time), message))
	end

	return write
else
	ox.warning('Unable to initilise logging module')
	local function write() return end
	return write
end