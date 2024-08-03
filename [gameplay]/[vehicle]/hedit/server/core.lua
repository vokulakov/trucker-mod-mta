addEventHandler ( "onResourceStart", resourceRoot, function ( )
    
    -- !HIGH PRIORITY!
    -- KEEP THIS IN ORDER TO LET CLIENTS SYNC THEIR SAVED HANDLINGS BETWEEN SERVERS!
    -- BY KEEPING THE DEFAULT RESOURCENAME PLAYERS CAN STORE THEIR HANDLINGS CLIENTSIDE,
    -- SO WHENEVER THEY JOIN ANOTHER SERVER, THEY WILL BE ABLE TO LOAD THEIR OWN HANDLINGS!
    
    local resName = getResourceName ( resource )
    
	setElementData(resourceRoot, "resourceVersion", getResourceInfo(resource, "version"))
	
    if resName ~= "hedit" and not DEBUGMODE then
        outputChatBox ( "Handling Editor failed to start, see the logs for more information." )
        print ( "===============================================================================" )
        print ( "[HEDIT] Please rename resource '"..resName.."' to 'hedit' in order to use the handling editor." )
        print ( "[HEDIT] This is needed to sync the handlings between clients properly." )
        print ( "[HEDIT] The handling editor will not work unless you rename the resource to 'hedit'." )
        print ( "===============================================================================" )
        return cancelEvent ( true, "Rename the handling editor resource to 'hedit' in order to use the resource." )
    end
    
    
    
    print ( "===============================================================================" )
    print ( " MTA:SA HANDLING EDITOR [hedit.googlecode.com]" )
    print ( "===============================================================================" )
    if fileExists ( "handling.cfg" ) then
        print ( " Handling.cfg found." )
        print ( " Type 'loadcfg' to load handling.cfg into the memory." )
        print ( " After this, you can import the handling into defaults.xml." )
        print ( "===============================================================================" )
    end
    
	--Parse meta settings
	parseMetaSettings()
	addEventHandler("onSettingChange", root, parseMetaSettings)
	
	for model=400,611 do
        setElementData ( root, "originalHandling."..tostring ( model ), getOriginalHandling ( model, true ) )
    end
    
    --initiateCFGLoader ( )
    loadHandlingLog ( )
    
    return true
end )





addEventHandler ( "onResourceStop", resourceRoot, function ( )
    unloadHandlingLog ( )

    -- Is this necessary? Surely resourceRoot is destroyed when the resource is stopped.
	removeElementData(resourceRoot, "resourceVersion")
	removeElementData(resourceRoot, "propertySettings")
    return true
end )




--[[
local function account_update()
    local admin = isObjectInACLGroup ( "user."..getAccountName ( getPlayerAccount ( source ) ), aclGetGroup ( "GLAdmin" ) ) -- ЧЕНДЖ
	if isResourceRunning ("vip") then
		local res = exports.vip:isPlayerVIP (source)
		if not admin then admin = res end
	end
    local canAccess = hasObjectPermissionTo(source, "resource.hedit.access", true)
    triggerClientEvent ( source, "updateClientRights", source, not isGuestAccount(getPlayerAccount(source)), admin, canAccess)
end

addEventHandler("onPlayerLogin", root, account_update)
addEventHandler("onPlayerLogout", root, account_update)
]]
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end