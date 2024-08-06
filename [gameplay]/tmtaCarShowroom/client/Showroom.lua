Showroom = {}

function Showroom.createInterior()
    local txd = engineLoadTXD('assets/object/interiorShowroom.txd', true)
    engineImportTXD(txd, Config.showroomObjectId)

    local dff = engineLoadDFF('assets/object/interiorShowroom.dff', 0)
    engineReplaceModel(dff, Config.showroomObjectId)

    local col = engineLoadCOL('assets/object/interiorShowroom.col')
    engineReplaceCOL(col, Config.showroomObjectId)
    
    Showroom.objectInterior = createObject(Config.showroomObjectId, Config.showroomObjectPosition)
    engineSetModelLODDistance(Config.showroomObjectId, 50)

    Showroom.objectInterior.interior = 0
    Showroom.objectInterior.dimension = 0
end

function Showroom.updateObject(interior, dimension)
    if not isElement(Showroom.objectInterior) then
        return
    end
    Showroom.objectInterior.interior = interior
    Showroom.objectInterior.dimension = dimension
end

function Showroom.enter()
    setTime(12, 0)
    setMinuteDuration(2147483647)
    ShowroomGUI.show()
end

function Showroom.exit()
    exports.tmtaTimecycle:syncPlayerGameTime()
    ShowroomGUI.hide()
end

-- Test
bindKey('F3', 'down', 
    function()
        if not isElement(ShowroomGUI.wnd) then
            Showroom.enter()
        else
            Showroom.exit()
        end
    end
)