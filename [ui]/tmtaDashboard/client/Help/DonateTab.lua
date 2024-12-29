DonateTab = {}

function DonateTab.create(posX, posY, width, height, wnd)
    if not isElement(wnd) then
        return
    end

    DonateTab.tab = guiCreateTab("Донат", wnd)

    DonateTab.img_donate = guiCreateStaticImage(0, 0, sW*((1280) /sDW), sH*((720) /sDH), "assets/donat_banner.png", false, DonateTab.tab)
    guiSetEnabled(DonateTab.img_donate, false)

    DonateTab.btnCopySiteUrl = guiCreateButton(sW*(260 /sDW), sW*((390) /sDW), sW*((180) /sDW), sH*((25) /sDH), "Копировать адрес сайта", false, DonateTab.tab)
    guiSetFont(DonateTab.btnCopySiteUrl, Font['RB_10'])
    guiSetProperty(DonateTab.btnCopySiteUrl, "HoverTextColour", "FF21b1ff")
	
    addEventHandler("onClientGUIClick", DonateTab.btnCopySiteUrl, 
        function()
            if not DonateTab.tab.visible then 
                return
            end

            setClipboard('https://truckermta.ru/')
            DonateTab.btnCopySiteUrl:setText("Скопировано")
            guiSetEnabled(DonateTab.btnCopySiteUrl, false)

            setTimer(
                function()
                    DonateTab.btnCopySiteUrl:setText("Копировать адрес сайта")
                    guiSetEnabled(DonateTab.btnCopySiteUrl, true)
                end, 1000, 1)
        end, false)

	DonateTab.btnCopyVK = guiCreateButton(sW*(260 /sDW), sW*((435) /sDW), sW*((180) /sDW), sH*((25) /sDH), "Копировать адрес VK", false, DonateTab.tab)
    guiSetFont(DonateTab.btnCopyVK, Font['RB_10'])
	guiSetProperty(DonateTab.btnCopyVK, "HoverTextColour", "FF21b1ff")
    
    addEventHandler("onClientGUIClick", DonateTab.btnCopyVK, 
        function()
            if not DonateTab.tab.visible then 
                return
            end

            setClipboard('https://vk.com/truckermta')
            DonateTab.btnCopyVK:setText("Скопировано")
			guiSetEnabled(DonateTab.btnCopyVK, false)

            setTimer(
                function()
                    DonateTab.btnCopyVK:setText("Копировать адрес VK")
                    guiSetEnabled(DonateTab.btnCopyVK, true)
                end, 1000, 1)
        end, false)

    local lbl = guiCreateLabel(sW*(70 /sDW), sW*((480) /sDW), sW*((180) /sDW), sH*((25) /sDH), "Ваш логин: ", false, DonateTab.tab)
    guiSetFont(lbl, Font['RB_10'])
	
    local offsetX = guiLabelGetTextExtent(lbl)+5
    local lbl = guiCreateLabel(sW*((70+offsetX) /sDW), sW*((480) /sDW), sW*((180) /sDW), sH*((25) /sDH), localPlayer:getData("login"), false, DonateTab.tab)
    guiSetFont(lbl, Font['RB_10'])
    guiLabelSetColor(lbl, 255, 214, 0)
    
    DonateTab.btnCopyLogin = guiCreateButton(sW*(260 /sDW), sW*((480) /sDW), sW*((180) /sDW), sH*((25) /sDH), "Копировать логин", false, DonateTab.tab)
    guiSetFont(DonateTab.btnCopyLogin, Font['RB_10'])
    guiSetProperty(DonateTab.btnCopyLogin, "HoverTextColour", "FF21b1ff")
    
    addEventHandler("onClientGUIClick", DonateTab.btnCopyLogin, 
        function()
            if not DonateTab.tab.visible then 
                return
            end

            setClipboard(tostring(localPlayer:getData("login")))
            DonateTab.btnCopyLogin:setText("Скопировано")
            guiSetEnabled(DonateTab.btnCopyLogin, false)

            setTimer(
                function()
                    DonateTab.btnCopyLogin:setText("Копировать логин")
                    guiSetEnabled(DonateTab.btnCopyLogin, true)
                end, 1000, 1)
        end, false)

    return DonateTab.tab
end