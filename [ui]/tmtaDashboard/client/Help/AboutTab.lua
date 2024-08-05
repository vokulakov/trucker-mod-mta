AboutTab = {}

function AboutTab.create(posX, posY, width, height, wnd)
    if not isElement(wnd) then
        return
    end

    AboutTab.tab = guiCreateTab("О проекте", wnd)
    AboutTab.browser = guiGetBrowser(guiCreateBrowser(sW*((10) /sDW), sH*((10) /sDH), sW*((width-40) /sDW), sH*((height-110) /sDH), true, true, false, AboutTab.tab))
    addEventHandler("onClientBrowserCreated", AboutTab.browser, 
	    function()
            loadBrowserURL(source, "http://mta/local/assets/public_html/about.html")
	    end
    )
end