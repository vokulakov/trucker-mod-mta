local DISABLED_UI_FROM_WEAPON = {
    [43] = true,
    [34] = true,
}

local function onPlayerAimWeapon(_, state)
    local playerWeapon = getPedWeapon(localPlayer)
    if not DISABLED_UI_FROM_WEAPON[playerWeapon] then
        return
    end

    if (state == "down") then
        exports.tmtaUI:setPlayerComponentVisible("all", false)
        showChat(false)
    else
        exports.tmtaUI:setPlayerComponentVisible("all", true)
        showChat(true)
    end
end

addEventHandler('onClientResourceStart', resourceRoot,
	function() 
		bindKey('aim_weapon', 'both', onPlayerAimWeapon)
	end
)
	
addEventHandler('onClientResourceStop', resourceRoot,
	function()
		unbindKey('aim_weapon', 'both', onPlayerAimWeapon)
	end
)