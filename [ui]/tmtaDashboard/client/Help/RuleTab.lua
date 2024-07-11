RuleTab = {}

function RuleTab.create(posX, posY, width, height, wnd)
    if not isElement(wnd) then
        return
    end

    RuleTab.tab = guiCreateTab("Правила сервера", wnd)
    RuleTab.browser = guiGetBrowser(guiCreateBrowser(sW*((10) /sDW), sH*((10) /sDH), sW*((width-40) /sDW), sH*((height-110) /sDH), true, true, false, RuleTab.tab))
    addEventHandler("onClientBrowserCreated", RuleTab.browser, 
	    function()
            loadBrowserURL(source, "http://mta/local/assets/public_html/rules.html")
	    end
    )

end