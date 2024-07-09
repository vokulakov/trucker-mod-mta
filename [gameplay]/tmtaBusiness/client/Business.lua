Business = {}

local streamedBusiness = {}

function Business.isStreamed(businessMarker)
    return streamedBusiness[businessMarker]
end

function Business.getStreamedAll()
    return streamedBusiness
end

function Business.onStreamIn(businessMarker)
	if (getElementType(businessMarker) ~= "marker" or not businessMarker:getData('isBusinessMarker')) then
		return
	end
    
	if (streamedBusiness[businessMarker]) then
        Business.onStremOut(businessMarker)
	end

    local businessData = BusinessMarker.getData(businessMarker)
    BusinessBlip.add(businessMarker, businessData.bussinesId, businessData.userId)

    streamedBusiness[businessMarker] = businessData
end

function Business.onStremOut(businessMarker)
	if (getElementType(businessMarker) ~= "marker" or not businessMarker:getData('isBusinessMarker')) then
		return
	end
    if not streamedBusiness[businessMarker] then
        return
    end

    streamedBusiness[businessMarker] = nil
end

addEventHandler("onClientElementStreamIn", root, 
	function()
        Business.onStreamIn(source)
	end
)

addEventHandler("onClientElementStreamOut", root, 
    function()
        Business.onStremOut(source)
    end
)

addEventHandler("onClientElementDestroy", root, 
    function()
        Business.onStremOut(source)
    end
)

addEventHandler("onClientElementDataChange", root, 
	function(dataName)
		local businessMarker = source
		if (getElementType(businessMarker) ~= "marker" or dataName ~= 'businessData') then
			return
		end
		Business.onStreamIn(businessMarker)
	end
)

addEvent("tmtaBusiness.addBusinessResponse", true)
addEventHandler("tmtaBusiness.addBusinessResponse", root,
    function(success)
        local typeNotice, typeMessage = 'error', 'Ошибка создания бизнеса'
        if success then
            CreateBusinessGUI.reset()
            CreateBusinessGUI.closeWindow()
            typeNotice, typeMessage = 'success', 'Бизнес создан'
        end
        Utils.showNotice(typeNotice, typeMessage)
    end
)

function Business.buy(businessId)
    if (type(businessId) ~= "number") then
        return false
    end
    triggerServerEvent("tmtaBusiness.onPlayerBuyBusiness", resourceRoot, businessId)
end

function Business.sell(businessId)
    if (type(businessId) ~= "number") then
        return false
    end
    triggerServerEvent("tmtaBusiness.onPlayerSellBusiness", resourceRoot, businessId)
end

function Business.takeMoney(businessId)
    if (type(businessId) ~= "number") then
        return false
    end
    triggerServerEvent("tmtaBusiness.onPlayerTakeMoneyFromBusiness", resourceRoot, businessId)
end

addEvent('tmtaBusiness.onBusinessUpdate', true)
addEventHandler('tmtaBusiness.onBusinessUpdate', resourceRoot,
    function(businessData)
        BusinessBlip.update(source)
    end
)