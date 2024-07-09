ControlsTab = {}

function ControlsTab.create(posX, posY, width, height, wnd)
    if not isElement(wnd) then
        return
    end

    ControlsTab.tab = guiCreateTab("Управление", wnd)
    ControlsTab.browser = guiGetBrowser(guiCreateBrowser(sW*((10) /sDW), sH*((10) /sDH), sW*((width-40) /sDW), sH*((height-110) /sDH), true, true, false, ControlsTab.tab))
    addEventHandler("onClientBrowserCreated", ControlsTab.browser, 
	    function()
            loadBrowserURL(source, "http://mta/local/webview/controls.html")
	    end
    )

    return ControlsTab.tab
end