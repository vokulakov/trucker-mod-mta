local Modules = {
	'Common',
	'Animation',
	'CallBack',
	'Dimension',
	'Async',
	'Class',
	'OOP',
	'CameraManager',
}

local Helpers = {
	'TableHelper',
	'StringHelper',
}

local function readFile(path)
	local content = ''
	local file = fileExists(path) and fileOpen(path) or false
	if file then
		content = fileRead( file, fileGetSize(file) )
	end
	fileClose(file)
	return content
end

local includedModules = {}
for _, moduleName in pairs(Modules) do
	includedModules[moduleName] = readFile(string.format('modules/%s.lua', moduleName))
end

for _, moduleName in pairs(Helpers) do
	includedModules[moduleName] = readFile(string.format('helpers/%s.lua', moduleName))
end

function include(moduleName)
    local module = includedModules[moduleName]
    if (not module) then
        outputDebugString("include: module `"..moduleName.."` not find", 1)
        return 
    end

    return module
end