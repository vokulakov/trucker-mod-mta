local Modules = {
    'callBack',
	'Animation',
}

local includedModules = {}

local function readFile(path)
	local content = ''

	local file = fileExists(path) and fileOpen(path) or false
	if file then
		content = fileRead( file, fileGetSize(file) )
	end
	fileClose(file)

	return content
end

for _, moduleName in pairs(Modules) do
	includedModules[moduleName] = readFile(string.format('modules/%s.module', moduleName))
end

function include(moduleName)
    local module = includedModules[moduleName]
    if (not module) then
        outputDebugString("include: module `"..moduleName.."` not find", 1)
        return 
    end 

    return module
end