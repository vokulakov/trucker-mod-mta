local shaders = {	
	deletenitro = dxCreateShader('assets/shaders/deletenitro.fx', 1, 0, true),
}

local color = {255/255, 150/255, 250/255, 1}
dxSetShaderValue(shaders.deletenitro, 'color', color)
addEventHandler('onClientResourceStart', resourceRoot, function()	
	engineApplyShaderToWorldTexture(shaders['deletenitro'], 'smoke', nil, true)
	--engineApplyShaderToWorldTexture(shaders['deletenitro_2'], 'smoke')
end)