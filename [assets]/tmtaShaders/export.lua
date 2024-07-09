Shaders = {}
Shaders.created = {}

Shaders.list = {
	['mask3d'] 		= 'shaders/mask3d.fx',
	['texreplace'] 	= 'shaders/texreplace.fx',
	['blur'] 		= 'shaders/blur.fx',
	['damage']		= 'shaders/damage.fx',
}

function Shaders.create(name, ... )
	local shaderUrl = Shaders.list[name]
	if type(name) ~= "string" or not shaderUrl then
		return false
	end

	local shader = dxCreateShader(shaderUrl, ...)
	if not shader then 
		return false
	end

	if sourceResource then
		if not Shaders.created[sourceResource] then
			Shaders.created[sourceResource] = {}
		end
		table.insert(Shaders.created[sourceResource], shader)
	end

	return shader
end

addEventHandler("onClientResourceStop", root,
	function(stoppedRes)
		local shaders = Shaders.created[stoppedRes]
		if not shaders then
			return
		end

		for _, shader in ipairs(shaders) do
			if isElement(shader) then
				destroyElement(shader)
			end
		end
		
		Shaders.created[stoppedRes] = nil
	end
)

-- Exports
createShader = Shaders.create