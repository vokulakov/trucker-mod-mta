DonateTab = {}

function DonateTab.create(posX, posY, width, height, wnd)
    if not isElement(wnd) then
        return
    end

    DonateTab.tab = guiCreateTab("Донат", wnd)
    DonateTab.browser = guiGetBrowser(guiCreateBrowser(sW*((10) /sDW), sH*((10) /sDH), sW*((width-40) /sDW), sH*((height-110) /sDH), true, true, false, DonateTab.tab))
    addEventHandler("onClientBrowserCreated", DonateTab.browser, 
	    function()
            loadBrowserURL(source, "http://mta/local/webview/donat.html")
	    end
    )

end