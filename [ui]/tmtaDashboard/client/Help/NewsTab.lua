NewsTab = {}

function NewsTab.create(posX, posY, width, height, wnd)
    if not isElement(wnd) then
        return
    end

    NewsTab.tab = guiCreateTab("Новости проекта", wnd)
    NewsTab.browser = guiGetBrowser(guiCreateBrowser(sW*((10) /sDW), sH*((10) /sDH), sW*((width-40) /sDW), sH*((height-110) /sDH), true, true, false, NewsTab.tab))
    addEventHandler("onClientBrowserCreated", NewsTab.browser, 
	    function()
            loadBrowserURL(source, "http://mta/local/webview/news.html")
	    end
    )

    return NewsTab.tab
end