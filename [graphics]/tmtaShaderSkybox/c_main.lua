-- Shader SKYBOX Alternative v0.52 by Ren712
-- Based on GTASA Skybox mod by Shemer
-- knoblauch700@o2.pl

-- Adjust texture size and other properties
local skydome = {
	-- object
	modelID = 3032, -- model id to replace
	objPreScale = 36, -- pre shader scale
	objRescale = {1,1,1}, -- (0.1-1) object rescale
    texRescale = {1,1}, -- (0.1-2) texture rescale
	-- transform shader
	angular = true, -- should the texture be transformed
    texScale = 1, -- texture scale
	texAspect = 1, -- texture aspect
	texTransform = {1,1,1}, -- transform view
	-- fog
	fogEnable = true, -- enable fog effect
	fogPow = 0.8, -- (1-2) fog effect intensity power
	fogMul = 1, -- (0-1) fog effect intensity multiplier
	-- texture color
	textureColorMul = {1,1,1,1}, -- (0-1) multiply color values
	textureColorPow = 1, -- (1-2) contrast power
    textureColorAlpha = 1, -- (0-1) alpha multiplier
	-- other
	enableIngameClouds = true, -- enable GTA clouds
	enableCloudTextures = true, -- enable smog/clouds textures

	shader = nil, transform = nil, clear = nil,
	object = nil, txd = nil, dff = nil, 
	rTarget = nil, cloudsEnabled = false
}

function start()
	if salEffectEnabled then return end
 
	skydome.txd = engineLoadTXD( 'models/skydome_object.txd' )
	engineImportTXD( skydome.txd, skydome.modelID)
	skydome.dff = engineLoadDFF( 'models/skydome_object.dff', skydome.modelID )
	engineReplaceModel( skydome.dff, skydome.modelID, true ) 
	
	local camX, camY, camZ = getCameraMatrix()
	skydome.object = createObject ( skydome.modelID, camX, camY, camZ, 0, 0, 0, true )
	setObjectScale( skydome.object, skydome.objPreScale) 
	setElementAlpha( skydome.object, 1 )
	skydome.shader = dxCreateShader ( "fx/skydome.fx", 0, 0, false, "object" )
	skydome.clear = dxCreateShader ( "fx/shader_clear.fx", 0, 0, false )

	if skydome.angular then
		skydome.transform = dxCreateShader ( "fx/transform.fx", 0, 0, false )
	end

	skydome.texture_morning = dxCreateTexture( "images/skydome_morning.jpg", "dxt5" )
	skydome.texture_day = dxCreateTexture( "images/skydome.jpg", "dxt5" )
	skydome.texture_evening = dxCreateTexture( "images/skydome_evening.jpg", "dxt5" )

	if not skydome.shader or not skydome.clear or not skydome.texture_day or not skydome.texture_evening then
		return
	end
	
	dxSetShaderValue ( skydome.shader, "gRescale", skydome.objRescale )
	dxSetShaderValue ( skydome.shader, "gTexScale",skydome.texRescale )

	dxSetShaderValue ( skydome.shader, "fFogEnable", skydome.fogEnable )
	dxSetShaderValue ( skydome.shader, "fFogMul", skydome.fogMul )
	dxSetShaderValue ( skydome.shader, "fFogMul", skydome.fogPow )
	
	dxSetShaderValue ( skydome.shader, "gColorMul", skydome.textureColorMul )
	dxSetShaderValue ( skydome.shader, "gColorPow", skydome.textureColorPow )
	dxSetShaderValue ( skydome.shader, "gColorAlpha", skydome.textureColorAlpha )

	ProcessByTime( )
	engineApplyShaderToWorldTexture ( skydome.shader, "skybox_tex", skydome.object )
	
	skydome.cloudsEnabled = getCloudsEnabled()
	setCloudsEnabled( skydome.enableIngameClouds )
	
	engineApplyShaderToWorldTexture ( skydome.clear, "coronamoon" )
	if not skydome.enableCloudTextures then
		engineApplyShaderToWorldTexture ( skydome.clear, "cloudmasked" )	
	end	
	salEffectEnabled = true	
	addEventHandler ( "onClientPreRender", getRootElement (), renderSphere )

	skydome.timer = setTimer( ProcessByTime, 1000, 0 )
end

function ProcessByTime( )
	local h, m = getTime()
	if h >= 18 then
		if skydome.current_texture ~= skydome.texture_evening then
			skydome.current_texture = skydome.texture_evening

			local mx, my = dxGetMaterialSize( skydome.current_texture )
			createWorkingRenderTarget( mx, my )
		end
	elseif h < 6 then
		if skydome.current_texture ~= skydome.texture_morning then
			skydome.current_texture = skydome.texture_morning

			local mx, my = dxGetMaterialSize( skydome.current_texture )
			createWorkingRenderTarget( mx, my )
		end
	else
		if skydome.current_texture ~= skydome.texture_day then
			skydome.current_texture = skydome.texture_day

			local mx, my = dxGetMaterialSize( skydome.current_texture )
			createWorkingRenderTarget( mx, my )
		end
	end

	if h >= 17 then
		if h < 22 then
			local coef = ( 1 - (( h - 17 ) * 100 + m) / 500 ) * 0.75
			skydome.textureColorMul = {coef,coef,coef,1}
		else
			skydome.textureColorMul = {0.15,0.15,0.15,1}
		end
	elseif h < 6 then
		local coef = (( h - 1 ) * 100 + m) / 500 * 0.75
		skydome.textureColorMul = {coef,coef,coef,1}
	else
		skydome.textureColorMul = {0.75,0.75,0.75,1}
	end

	dxSetShaderValue ( skydome.shader, "gColorMul", skydome.textureColorMul )
end

function stop()
	if not salEffectEnabled then return end
	removeEventHandler ( "onClientPreRender", getRootElement (), renderSphere )
	engineRemoveShaderFromWorldTexture ( skydome.shader, "skybox_tex", skydome.object )
	engineRemoveShaderFromWorldTexture ( skydome.clear, "*" )
	if skydome.transform then
		destroyElement( skydome.transform )
		skydome.transform = nil
	end
	if skydome.rTarget then
		destroyElement( skydome.rTarget )
		skydome.rTarget = nil
	end
	destroyElement( skydome.clear )
	destroyElement( skydome.shader )
	destroyElement( skydome.texture_day )
	destroyElement( skydome.texture_evening )
	skydome.object = nil
	skydome.shader = nil
	skydome.clear = nil
	skydome.texture_day = nil
	skydome.texture_evening = nil
	engineRestoreModel( skydome.modelID )	
	destroyElement( skydome.dff )
	destroyElement( skydome.txd ) 
	skydome.dff = nil
	skydome.txd = nil
	setCloudsEnabled( skydome.cloudsEnabled )
	salEffectEnabled = false

	if isTimer( skydome.timer ) then
		killTimer( skydome.timer )
		skydome.timer = nil
	end
end

function getStatus()
	return salEffectEnabled
end

function toint(n)
    local s = tostring(n)
    local i = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

function createWorkingRenderTarget( mx, my, evening_alpha )
	if isElement( skydome.rTarget ) then
		destroyElement( skydome.rTarget )
	end
	outputConsole('Skybox_alt: creating '..mx..' '..my..' RT')
	if ( mx <= 20 ) or ( my <= 20 ) then 
		return false
	end
	skydome.rTarget = dxCreateRenderTarget( mx, my, true ) 
	if not skydome.rTarget then
		outputConsole('Skybox_alt: creating RT fail')
		createWorkingRenderTarget( toint( mx * 0.85 ), toint( my * 0.85 ) )
	else
		local mx, my = dxGetMaterialSize( skydome.rTarget )	
		dxSetRenderTarget( skydome.rTarget )
		dxSetShaderValue ( skydome.transform, "gScale", skydome.texScale )
		dxSetShaderValue ( skydome.transform, "gAspect", skydome.texAspect )
		dxSetShaderValue ( skydome.transform, "gTransform", skydome.texTransform )
		dxSetShaderValue ( skydome.transform, "gTexture", skydome.current_texture )
		dxDrawImage(0, 0, mx, my, skydome.transform )
		dxSetRenderTarget()
		dxSetShaderValue ( skydome.shader, "gSkyTexture", skydome.rTarget )
		return true
	end
end

function renderSphere()
	if not salEffectEnabled then return end
	local camX, camY, camZ = getCameraMatrix()
	local watLvl = getWaterLevel( camX, camY, camZ )
	local tempHeight = 60
	if watLvl then
		if ( camZ - 0.65 < watLvl ) then
			dxSetShaderValue ( skydome.shader, "gIsInWater", true )
			tempHeight = 0
		end
	end
	if not watLvl or ( camZ - 0.65 > watLvl ) then
		dxSetShaderValue ( skydome.shader, "gIsInWater", false )
	end	
	if camZ <= 100 then 
		setElementPosition ( skydome.object, camX, camY, tempHeight, false ) 
	else 
		setElementPosition ( skydome.object, camX, camY, tempHeight + ( camZ - 100 ), false )  
	end
end

addEventHandler("onClientRestore",root, function( didClearRenderTargets )
    if didClearRenderTargets then
		if not salEffectEnabled then return end
		if skydome.angular then
			outputConsole( 'Skybox_alt: Restoring RT' )
			local mx, my = dxGetMaterialSize( skydome.current_texture )
			createWorkingRenderTarget( mx, my )
		end
	end
end
)
