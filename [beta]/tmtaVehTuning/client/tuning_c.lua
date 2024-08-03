Tuning = {}

window = {}

window["Main_Menu"] = guiCreateWindow(0.005,0.005,0.185,0.32,"Компоненты", true)
window["Main_Grid"] = guiCreateGridList(0,0.1,1,1,true, window["Main_Menu"])
guiGridListAddColumn(window["Main_Grid"],"Название", 0.85)
guiWindowSetSizable(window["Main_Menu"], false)
guiSetVisible(window["Main_Menu"], false)

window["Main_Close"] = guiCreateButton(0.2,0.005,0.1,0.05,"Выход", true)
guiSetVisible(window["Main_Close"], false)
window["Comp_Menu"] = guiCreateWindow(0.005,0.33,0.185,0.35,"Детали", true)
window["Comp_Grid"] = guiCreateGridList(0,0.1,1,0.73,true, window["Comp_Menu"])
window["Comp_Buy"] = guiCreateButton(0,0.85,1,0.5,"Купить", true, window["Comp_Menu"])
guiSetEnabled(window["Comp_Buy"], false)
guiGridListAddColumn(window["Comp_Grid"],"Название", 0.65)
guiGridListAddColumn(window["Comp_Grid"],"Цена", 0.35)
guiWindowSetSizable(window["Comp_Menu"], false)
guiSetVisible(window["Comp_Menu"], false)

function openGUITunning(src)
    if src ~= localPlayer then return end
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    if getPedOccupiedVehicleSeat(src) ~= 0 then return end
    
    upgrades = getVehicleUpgrades ( veh )
    for upgradeKey, upgradeValue in ipairs ( upgrades ) do
        if item[1] == upgradeValue then
            oldKey = key
        end
    end
    
    for _,element in pairs(window) do
        guiSetVisible(element, true)
        guiSetVisible(window["Comp_Menu"], false)
    end
    
    --showCursor(true)
    id = getVehicleID(veh)
    guiGridListClear(window["Main_Grid"])
    for names,comp in pairs(componentsFromData) do
        if getVehicleComponentPosition(veh, names..tostring(1)) then
            row = guiGridListAddRow(window["Main_Grid"])
            guiGridListSetItemText(window["Main_Grid"], row, 1, comp, false, true)
            guiGridListSetItemData(window["Main_Grid"], row, 1, names)
        end
    end
   
end

addEventHandler("onClientGUIClick", getRootElement(), function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    if source == window["Main_Grid"] then
        for name, comp in pairs(componentsFromData) do
            updateVehicleTuningComponent(veh, name)
        end
        grid = window["Comp_Grid"]
        if grid then
            row = guiGridListGetSelectedItem(window["Main_Grid"])
            if row and row ~= -1 then
                componentt = guiGridListGetItemData(window["Main_Grid"], row, 1)
            end
            if componentt == "FrontLights" or componentt == "RearLights" then
                setVehicleOverrideLights ( veh, 2 )
            else
                setVehicleOverrideLights ( veh, 0 )
            end
            guiGridListClear(grid)
            id = getVehicleID(veh)
        
            if componentt == "Spoilers" then
                resetWindows()
                if tableComponents[id] then
                    local i = 0
                    while i <= 20 do
                        local name = componentt .. tostring(i)  
                        for ie,comp in pairs(tableComponents[id][componentt]) do
                            if name == comp[1] then
                                row = guiGridListAddRow(grid)
                                guiSetVisible(window["Comp_Menu"], true)
                                guiGridListSetItemText(grid, row, 1, comp[2], false, true)
                                guiGridListSetItemText(grid, row, 2, comp[3], false, true)
                                guiGridListSetItemData(grid, row, 1, comp[1])
                            end
                        end
                        if i > 0 and not getVehicleComponentPosition(veh, componentt..tostring(i)) then
                            break
                        end
                        i = i + 1
                        if i > 0 and getVehicleComponentVisible(veh,componentt..tostring(i)) ~= true then
                            break
                        end
                    end
                else
                    for i=0,20 do
                        for name,comp in pairs(componentsFromData) do
                            if i == 0 and not getVehicleComponentPosition(veh, name..tostring(i)) then
                                if name == componentt then
                                    row = guiGridListAddRow(grid)
                                    guiGridListSetItemText(grid, row, 1, comp.."(сток)", false, true)
                                    guiGridListSetItemText(grid, row, 2, "0", false, true)
                                    guiGridListSetItemData(grid, row, 1, name..i)
                                end
                            end
                            if getVehicleComponentPosition(veh, name..tostring(i)) then
                                if name == componentt then
                                    row = guiGridListAddRow(grid)
                                    guiSetVisible(window["Comp_Menu"], true)
                                    guiGridListSetItemText(grid, row, 1, comp.." "..tostring(i), false, true)
                                    guiGridListSetItemText(grid, row, 2, tostring(i+1).."000", false, true)
                                    guiGridListSetItemData(grid, row, 1, name..i)
                                end
                            end
                        end
                    end
                end
            else
                resetWindows()
                id = getVehicleID(veh)
                if tableComponents[id]then
                    local i = 0
                    while i <= 20 do
                        local name = componentt .. tostring(i)  
                        if tableComponents[id] and tableComponents[id][componentt] then
                            for ie,comp in pairs(tableComponents[id][componentt]) do
                                if name == comp[1] then
                                    row = guiGridListAddRow(grid)
                                    guiSetVisible(window["Comp_Menu"], true)
                                    guiGridListSetItemText(grid, row, 1, comp[2], false, true)
                                    guiGridListSetItemText(grid, row, 2, comp[3], false, true)
                                    guiGridListSetItemData(grid, row, 1, comp[1])
                                end
                            end
                        end
                        i = i + 1
                        if i > 0 and not getVehicleComponentPosition(veh, componentt..tostring(i)) then
                            break
                        end
                    end
                else
                    for i=0,20 do
                        for name,comp in pairs(componentsFromData) do
                            if i == 0 and not getVehicleComponentPosition(veh, name..tostring(i)) then
                                if name == componentt then
                                    row = guiGridListAddRow(grid)
                                    guiGridListSetItemText(grid, row, 1, comp.."(сток)", false, true)
                                    guiGridListSetItemText(grid, row, 2, "0", false, true)
                                    guiGridListSetItemData(grid, row, 1, name..i)
                                end
                            end
                            if getVehicleComponentPosition(veh, name..tostring(i)) then
                                if name == componentt then
                                    row = guiGridListAddRow(grid)
                                    guiSetVisible(window["Comp_Menu"], true)
                                    guiGridListSetItemText(grid, row, 1, comp.." "..tostring(i), false, true)
                                    guiGridListSetItemText(grid, row, 2, tostring(i+1).."000", false, true)
                                    guiGridListSetItemData(grid, row, 1, name..i)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if source == window["Main_Close"] then
        destroyAllMenu()
    end
    if source == window["Comp_Grid"] then
        row = guiGridListGetSelectedItem(window["Comp_Grid"])
        if row and row ~= -1 then
            component = guiGridListGetItemData(window["Comp_Grid"], row, 1) -- с циферкой
            nameComp = guiGridListGetItemData(window["Main_Grid"], guiGridListGetSelectedItem(window["Main_Grid"]), 1) -- без циферки
            if nameComp == "frame" then
                if getElementData(veh, nameComp) ~= component then
                    price = guiGridListGetItemText(window["Comp_Grid"], row, 2)
                    guiSetEnabled(window["Comp_Buy"], true)
                    guiSetText(window["Comp_Buy"], "Купить("..price.." руб.)")
                    setRamkaVehicle ( getPedOccupiedVehicle(localPlayer), component )
                else
                    setRamkaVehicle ( getPedOccupiedVehicle(localPlayer), getElementData(veh, nameComp) )
                    guiSetEnabled(window["Comp_Buy"], false)
                    guiSetText(window["Comp_Buy"], "Купить")
                end
            else
                if getElementData(veh, nameComp) ~= component then
                    updateVehicleTuningComponent(veh, nameComp, component)
                    price = guiGridListGetItemText(window["Comp_Grid"], row, 2)
                    guiSetEnabled(window["Comp_Buy"], true)
                    guiSetText(window["Comp_Buy"], "Купить("..price.." руб.)")
                else
                    guiSetEnabled(window["Comp_Buy"], false)
                    guiSetText(window["Comp_Buy"], "Купить")
                    if not getElementData(veh, nameComp) then setElementData(veh, nameComp, nameComp.."0", true) end
                    updateVehicleTuningComponent(veh, nameComp, getElementData(veh, nameComp))
                end
            end
        end
    end
    if source == window["Comp_Buy"] then
        veh = getPedOccupiedVehicle(localPlayer)
        if not veh then return end
        if price and component and nameComp then
            if exports.tmtaMoney:getPlayerMoney(localPlayer) < tonumber(price) then
                --outputChatBox("У Вас недостаточно средтсв!")
                exports.tmtaNotification:showInfobox( 
                    "info", 
                    "Внимание!", 
                    "У вас недостаточно средств", 
                    _, 
                    {240, 146, 115}
                )
                return
            end
            setElementData(veh, nameComp, component, true)
            guiSetEnabled(window["Comp_Buy"], false)
           	 guiSetText(window["Comp_Buy"], "Купить")
            triggerServerEvent("takeMoneyPly",localPlayer, tonumber(price), veh)
        end
    end
end)

function destroyAllMenu()
    local veh = getPedOccupiedVehicle( localPlayer )
    
    for name, comp in pairs(componentsFromData) do
        updateVehicleTuningComponent(veh, name)
    end

    id = getVehicleID(veh)

    for _,element in pairs(window) do
        guiSetVisible(element, false)
    end

    guiGridListClear(window["Main_Grid"])
    guiGridListClear(window["Comp_Grid"])

    UI.setWindowVisible(true)
    --triggerServerEvent("tmtaVehTuning.onPlayerExitGarage", localPlayer)

end

function resetWindows()
    veh = getPedOccupiedVehicle(localPlayer)
    guiSetVisible(window["Comp_Menu"], false)
end

function updateVehicleTuningUpgrade(vehicle, upgradeName)
    if not isElement(vehicle) then return false end
    if type(upgradeName) ~= "string" or not upgradesFromData[upgradeName] then 
        return false 
    end

    for i, id in ipairs(upgradesFromData[upgradeName]) do
        vehicle:removeUpgrade(id)
    end

    local index = tonumber(vehicle:getData(upgradeName)) 
    if not index then
        return false
    end
    if upgradeName == "Spoilers" then
        if index > #upgradesFromData[upgradeName] then
            return updateVehicleTuningComponent(vehicle, upgradeName, index - #upgradesFromData[upgradeName])
        elseif index == 0 then
            return updateVehicleTuningComponent(vehicle, upgradeName, 0)
        else
            updateVehicleTuningComponent(vehicle, upgradeName, -1)
        end
    end
    local id = upgradesFromData[upgradeName][index]         
    if id then
        return vehicle:addUpgrade(id)
    end 
end

function updateVehicleTuningComponent(vehicle, componentName, forceId)
    if not isElement(vehicle) then return false end
    if not vehicle then return end
    if not getElementModel(vehicle) then return end
    local i = 0
    while i <= 20 do
        local name = componentName .. tostring(i)       
        setVehicleComponentVisible(vehicle, name, false)
        setVehicleComponentVisible(vehicle, componentName .. "Glass" .. tostring(i), false)
        if i > 0 and not getVehicleComponentPosition(vehicle, name) then
            break
        end
        i = i + 1
    end
    local id = 0
    if componentName == "Spoilers" then
        updateVehicleTuningUpgrade(vehicle, "Spoilers")
    end
    if type(forceId) == "number" then
        id = componentName..forceId
    elseif not forceId then
        id = getElementData(vehicle, componentName)
    else
        id = forceId
    end
    if not getElementData(vehicle, componentName)  then
        setTimer(function()
            if not isElement(vehicle) then 
                return
            end
            if not getElementData(vehicle, componentName) then
                setElementData(vehicle, componentName, componentName.."0", true)
                id = getElementData(vehicle, componentName)
            end
            if getElementData(vehicle, componentName) then
                glass = string.gsub(getElementData(vehicle, componentName), componentName, "")
                setVehicleComponentVisible(vehicle, getElementData(vehicle, componentName) , true)
                setVehicleComponentVisible(vehicle, componentName .. "Glass" .. tonumber(glass), true)
            end
        end,500,1)
        return
    end
    glass = string.gsub(id, componentName, "")
    setVehicleComponentVisible(vehicle, id, true)
    setVehicleComponentVisible(vehicle, componentName .. "Glass" .. tonumber(glass), true)
end

-- Полностью обновить тюнинг на автомобиле
function updateVehicleTuning(vehicle)
    if not isElement(vehicle) then
        return false
    end
    for name in pairs(componentsFromData) do
        if not getElementData(vehicle, name) then break end
        updateVehicleTuningComponent(vehicle, name)
    end
    for name in pairs(upgradesFromData) do
        if not getElementData(vehicle, name) then break end
        updateVehicleTuningUpgrade(vehicle, name)
    end 
    return true
end

addEventHandler( "onClientElementStreamIn", getRootElement(), function()
    if getElementType( source ) == "vehicle" then
        for name, comp in pairs(componentsFromData) do
            updateVehicleTuningComponent(source, name)
        end
        updateVehicleTuning(source)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    local vehicles = getElementsByType("vehicle")
    for k,v in pairs(vehicles) do
        if not v then return end
        updateVehicleTuning(v)
    end
end)

addEventHandler("onClientElementDataChange", root, function (nameData, oldVaue)
    if source.type == "vehicle" then
        for name in pairs(componentsFromData) do
            if name == nameData then
                updateVehicleTuning(source)
            end
        end
    end
end)