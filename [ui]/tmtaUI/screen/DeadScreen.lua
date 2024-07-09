local screenX, screenY = guiGetScreenSize()
local screenSource = dxCreateScreenSource(screenX, screenY)
local damageShader = exports.tmtaShaders:createShader('damage')

local screenDamageShow = false

local impactSoundVolume = 0
local heartSound
local tinnitusSound
local blurStrength = 0
local colorFadeValue = 0

local function deadScreen()
	if (damageShader) then
		dxUpdateScreenSource(screenSource)

		blurStrength = blurStrength - 0.1
		
		if (blurStrength <= 0) then
			blurStrength = 0
		end
		
		colorFadeValue = colorFadeValue - 0.0025
		
		if (colorFadeValue <= 0) then
			colorFadeValue = 0
		end

		-- sounds --
		impactSoundVolume = impactSoundVolume - 0.005
		
		if (impactSoundVolume <= 0) then
			impactSoundVolume = 0
			
			if (heartSound) and (isElement(heartSound)) then
				heartSound:stop()
			end
		end
		
		if (heartSound) and (isElement(heartSound)) then
			heartSound:setVolume(impactSoundVolume * 3)
		end
		
		if (tinnitusSound) and (isElement(tinnitusSound)) then
			tinnitusSound:setVolume(impactSoundVolume)
		end
		------------

		dxSetShaderValue(damageShader, "screenSource", screenSource)
		dxSetShaderValue(damageShader, "blurStrength", blurStrength)
		dxSetShaderValue(damageShader, "colorFadeValue", colorFadeValue)

		dxDrawImage(0, 0, screenX, screenY, damageShader)
	end
end

local function showDeadScreen()
	addEventHandler("onClientPreRender", root, deadScreen)

	blurStrength = _blurStrength or 20
	colorFadeValue = 1
	impactSoundVolume = 1

	screenDamageShow = true

	exports.tmtaSounds:playSound('wasted')
	heartSound = exports.tmtaSounds:playSound('heart', true)
	tinnitusSound = exports.tmtaSounds:playSound('tinnitus', false)
end

local function destroyDeadScreen()
	removeEventHandler("onClientPreRender", root, deadScreen)

	screenDamageShow = false

	if (heartSound) and (isElement(heartSound)) then
		heartSound:stop()
	end

	if (tinnitusSound) and (isElement(tinnitusSound)) then
		tinnitusSound:stop()
	end
end

setPlayerDeadScreen = function(state)
	if screenDamageShow and state then 
		destroyDeadScreen()
	end

	if state then
		showDeadScreen()
	else
		destroyDeadScreen()
	end
end