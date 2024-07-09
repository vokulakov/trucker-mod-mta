Utils = {}

Utils.screenDefaultWidth = 1280
Utils.screenDefaultHeight = 720

function Utils.getScreenScale(val)
    local screenWidth, screenHeight = guiGetScreenSize()
	if screenWidth < Utils.screenDefaultWidth then
		return val * screenWidth / Utils.screenDefaultWidth
	end
	return val
end

function Utils.getLimitedScreenSize()
	local w, h = guiGetScreenSize()
	if w < Utils.screenDefaultWidth then
		h = h * Utils.screenDefaultWidth / w
		w = Utils.screenDefaultWidth
	end
	return w, h
end

function Utils.getDefaultScreenSize()
    return Utils.screenDefaultWidth, Utils.screenDefaultHeight
end

-- Exports
getScreenSize = Utils.getLimitedScreenSize
getScreenScale = Utils.getScreenScale
getDefaultScreenSize = Utils.getDefaultScreenSize