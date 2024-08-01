-- РАЗМЫТИЕ --
local sx, sy = guiGetScreenSize()
local myScreenSource = dxCreateScreenSource(sx, sy)
local BLUR_SHADER = exports.tmtaShaders:createShader('blur')
local blurShow = false

local function blurShaderShow()
    dxUpdateScreenSource(myScreenSource)     
    dxSetShaderValue(BLUR_SHADER, "ScreenSource", myScreenSource)
	dxSetShaderValue(BLUR_SHADER, "BlurStrength", 6);
	dxSetShaderValue(BLUR_SHADER, "UVSize", sx, sy);
    dxDrawImage(-10, -10, sx+10, sy+10, BLUR_SHADER)
end

local function blurShaderStart()
	if blurShow then return end
	addEventHandler("onClientPreRender", getRootElement(), blurShaderShow)
	blurShow = true
end

local function blurShaderStop()
	if not blurShow then return end
	removeEventHandler("onClientPreRender", getRootElement(), blurShaderShow)
	blurShow = false
end

--Exports
setPlayerBlurScreen = function(state)
    if state then
        blurShaderStart()
    else
        blurShaderStop()
    end
end