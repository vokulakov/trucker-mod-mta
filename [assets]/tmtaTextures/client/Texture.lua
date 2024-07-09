Texture = {}

Texture.created = {}
Texture.list = Config.IMAGE_LIST

function Texture.createStaticImage(x, y, width, height, path, relative, parent)
	local texturePath = Texture.list[path]
	if type(path) ~= "string" or not texturePath then
		return false
	end

	relative = relative or false
	parent = parent or nil

	local texture = GuiStaticImage(x, y, width, height, texturePath, relative, parent)
	if not isElement(texture) then
		return false
	end

	if sourceResource then
		if not Texture.created[sourceResource] then
			Texture.created[sourceResource] = {}
		end
		table.insert(Texture.created[sourceResource], texture)
	end

	return texture
end

function Texture.create(name, ...)
	local textureUrl = Texture.list[name]
	if type(name) ~= "string" or not textureUrl then
		return false
	end

	local texture = dxCreateTexture(textureUrl, ...)

	if sourceResource then
		if not Texture.created[sourceResource] then
			Texture.created[sourceResource] = {}
		end
		table.insert(Texture.created[sourceResource], texture)
	end

	return texture
end

addEventHandler("onClientResourceStop", root,
	function(stoppedRes)
		local textures = Texture.created[stoppedRes]
		if not textures then
			return
		end

		for _, texture in ipairs(textures) do
			if isElement(texture) then
				destroyElement(texture)
			end
		end

		Texture.created[stoppedRes] = nil
	end
)

-- Exports
createStaticImage = Texture.createStaticImage
createTexture = Texture.create