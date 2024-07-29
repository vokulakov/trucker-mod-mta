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
	if not streamedBusiness[businessMarker] then
		local businessData = businessMarker:getData('businessData')
		if not businessData then
			return
		end
		businessData.formattedPrice = tostring(exports.tmtaUtils:formatMoney(businessData.price))

        local blipColor = businessData.owner and tocolor(0, 153, 255, 255) or tocolor(0, 255, 0, 255)
		BusinessBlip.add(businessMarker, businessData.houseId, blipColor)

		streamedBusiness[businessMarker] = businessData
	end
end

function Business.onStremOut(businessMarker)
	if (getElementType(businessMarker) ~= "marker" or not businessMarker:getData('isBusinessMarker')) then
		return
	end
    if streamedBusiness[businessMarker] then
        BusinessBlip.remove(businessMarker)
        streamedBusiness[businessMarker] = nil
    end
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
    BusinessGUI.closeWindow()
    triggerServerEvent("tmtaBusiness.onPlayerBuyBusiness", resourceRoot, businessId)
end

function Business.sell(businessId)
    if (type(businessId) ~= "number") then
        return false
    end
end