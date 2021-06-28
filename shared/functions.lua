func = {}

func.trim = function(string)
	return string:match("^%s*(.-)%s*$")
end