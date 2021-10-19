local io = io
local os = os
local day, month, year = string.strsplit('-', os.date('%d-%B-%Y'))
local path = GetResourcePath(ox.name):gsub('//', '/')
path = ('%s/modules/logs'):format(path)
local l = '/'

local function unix()
	local system = os.getenv('OS')
	if not system or system:match('Windows') then
		unix = false
		l = '\\'
	else unix = true end
end
unix()

local _format = string.format
local function dir(str, ...)
	str = _format(str, ...):gsub('/', l)
	return str
end

os.execute(dir('%s %s%s%s%s%s', unix and 'mkdir -p' or 'mkdir', path, l, year, l, month))

local fml = dir('%s-%s-%s.json', year, month, day)
local file = io.open(dir('%s%s%s%s%s%s%s', path, l, year, l, month, l, fml), 'a+')

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