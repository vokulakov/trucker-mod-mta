
local files = {
	'common',
	'animations',
	'timed_animations',
	'drawing',
	'binds',
	'gui.module',
	'gui.dialog',
	'gui.fonts',
	'gui.module.utils',
}

function readFile(path)
	local content = ''
	local file = fileExists(path) and fileOpen(path) or false
	if file then
		content = fileRead( file, fileGetSize(file) )
	end
	fileClose(file)
	return content
end

local includes = {}

for _, fileName in pairs(files) do
	includes[fileName] = readFile( string.format('assets/opensources/%s.source', fileName) )
end

function include(name)
	return includes[name]
end