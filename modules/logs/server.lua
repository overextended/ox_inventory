local io = io
local os = os
local day, month, year = string.strsplit('-', os.date('%d-%B-%Y'))
local path = GetResourcePath(ox.name):gsub('//', '/')
path = ('%s/modules/logs'):format(path)

local l = os.getenv('OS')
if not l or not l:match('Windows') then
	l = '/' else l = '\\'
end

local _format = string.format
local function format(str, ...)
	str = _format(str, ...):gsub('/', l)
	return str
end

os.execute(format('mkdir %s%s%s%s%s', path, l, year, l, month))

local fml = ('%s-%s-%s.json'):format(year, month, day)
local file = io.open(format('%s%s%s%s%s%s%s', path, l, year, l, month, l, fml), 'a+')

local time = '%H:%M:%S'
local string = _format([[{ "date": "%s/%s/%s", "time": "%s", "content": "%s" },
]], day, month:sub(0, 3), year, '%s', '%s')

local write = function(message)
	file:write(_format(string, os.date(time), message))
end

return write