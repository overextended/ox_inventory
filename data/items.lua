local filesToLoad = {
	-- 需要按照以下格式添加,否则不会读取文件
	'items/normal',
	'items/food',
}

local fileContents = {}

for _, fileName in ipairs(filesToLoad) do
	local content = data(fileName)
	for k, v in pairs(content) do
		fileContents[k] = v
	end
end

return fileContents