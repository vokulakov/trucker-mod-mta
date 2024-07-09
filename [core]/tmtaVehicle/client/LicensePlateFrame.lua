LicensePlateFrame = {}
LicensePlateFrame.created = {}

LicensePlateFrame.texture = {
    frame0 = exports.tmtaTextures:createTexture('vehicleFrame0'),
}

local function isLicenseFrameValid(frameTextureName)
    if (not frameTextureName or type(frameTextureName) ~= 'string') then
        outputDebugString('isLicenseFrameValid: bad arguments', 1)
        return false
    end
    return not not LicensePlateFrame.texture[tostring(frameTextureName)]
end

local _createdLicenseFrameTexture = {}
local function createLicenseFrameTexture(frameTextureName)
    if (not frameTextureName or type(frameTextureName) ~= 'string' or not isLicenseFrameValid(frameTextureName)) then
        outputDebugString('createLicenseFrameTexture: bad arguments', 1)
        return false
    end

    if isElement(_createdLicenseFrameTexture[frameTextureName]) then
        return _createdLicenseFrameTexture[frameTextureName]
    end

    local renderTarget = dxCreateRenderTarget(1024, 256, true)
	if not isElement(renderTarget) then
        outputDebugString('createLicenseFrameTexture: failed create render targer', 1)
		return false
	end

    dxSetRenderTarget(renderTarget, false)
        dxDrawImage(0, 0, 1024, 256, LicensePlateFrame.texture[tostring(frameTextureName)])
    dxSetRenderTarget()

    _createdLicenseFrameTexture[frameTextureName] = dxCreateTexture(dxGetTexturePixels(renderTarget))
    destroyElement(renderTarget)
    
	return _createdLicenseFrameTexture[frameTextureName]
end

function LicensePlateFrame.setOnVehicle(vehicle)
    if (not isElement(vehicle)) then
        outputDebugString('LicensePlateFrame.setOnVehicle: bad arguments', 1)
        return false
    end

    --TODO: тут будет логика для установки разных текстур номерных рамок
    local texture = createLicenseFrameTexture(Config.DEFAULT_LICENSE_FRAME)
	if not isElement(texture) then
        outputDebugString('LicensePlateFrame.setOnVehicle: failed create texture', 1)
		return false
	end

    if not LicensePlateFrame.created[vehicle] then
		LicensePlateFrame.created[vehicle] = exports.tmtaShaders:createShader('texreplace', 0, 200, false, 'vehicle')
	end

    if (type(Config.FRAME_TEXTURE_NAME) == 'table') then
        for _, textureName in pairs(Config.FRAME_TEXTURE_NAME) do
            engineApplyShaderToWorldTexture(LicensePlateFrame.created[vehicle], textureName, vehicle)
        end
    else
        engineApplyShaderToWorldTexture(LicensePlateFrame.created[vehicle], Config.FRAME_TEXTURE_NAME, vehicle)
    end

	dxSetShaderValue(LicensePlateFrame.created[vehicle], 'TEXTURE_REMAP', texture)

    return true
end

function LicensePlateFrame.destroyFromVehicle(vehicle)
    if (not isElement(vehicle)) then
        outputDebugString('LicensePlateFrame.destroyFromVehicle: bad arguments', 1)
        return false
    end

    local frameShader = LicensePlateFrame.created[vehicle]
    if not frameShader then
        return false
    end

    if (type(Config.FRAME_TEXTURE_NAME) == 'table') then
        for _, textureName in pairs(Config.FRAME_TEXTURE_NAME) do
            engineRemoveShaderFromWorldTexture(frameShader, textureName, vehicle)
        end
    else
        engineRemoveShaderFromWorldTexture(frameShader, Config.FRAME_TEXTURE_NAME, vehicle)
    end

    destroyElement(frameShader)
	LicensePlateFrame.created[vehicle] = nil

    return true
end