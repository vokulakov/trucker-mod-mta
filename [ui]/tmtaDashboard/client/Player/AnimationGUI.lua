AnimationGUI = {}
AnimationGUI.visible = false

local width, height
local posX, posY

local ANIMATION_CATEGORY = {
    [1] = "Приветствие",
    [2] = "Танцы",
    [3] = "Лежать-Сидеть",
    [4] = "Машина",
    [5] = "Разное",
}

local ANIMATION_LIST = {
	{"BD_FIRE", "BD_GF_Wave", ANIMATION_CATEGORY[1], "Hello!"},
	{"BD_FIRE", "Grlfrd_Kiss_03", ANIMATION_CATEGORY[1], "Kiss"},
    {"ON_LOOKERS", "wave_loop", ANIMATION_CATEGORY[1], "Здарова!!"},
		
    {"STRIP", "strip_A", ANIMATION_CATEGORY[2], "Стриптиз #1"},
    {"STRIP", "strip_B", ANIMATION_CATEGORY[2], "Стриптиз #2"},
    {"STRIP", "strip_C", ANIMATION_CATEGORY[2], "Стриптиз #3"},
    {"STRIP", "strip_D", ANIMATION_CATEGORY[2], "Стриптиз #4"},
    {"STRIP", "strip_E", ANIMATION_CATEGORY[2], "Стриптиз #5"},
    {"STRIP", "strip_F", ANIMATION_CATEGORY[2], "Стриптиз #6"},
    {"STRIP", "strip_G", ANIMATION_CATEGORY[2], "Стриптиз #7"},
    {"DANCING", "bd_clap", ANIMATION_CATEGORY[2], "Танцы #1"},
    {"DANCING", "dance_loop", ANIMATION_CATEGORY[2], "Танцы #2"},
    {"DANCING", "DAN_Down_A", ANIMATION_CATEGORY[2], "Танцы #3"},
    {"DANCING", "DAN_Left_A", ANIMATION_CATEGORY[2], "Танцы #4"},
    {"DANCING", "DAN_Loop_A", ANIMATION_CATEGORY[2], "Танцы #5"},
    {"DANCING", "DAN_Right_A", ANIMATION_CATEGORY[2], "Танцы #6"},
    {"DANCING", "DAN_Up_A", ANIMATION_CATEGORY[2], "Танцы #7"},
    {"DANCING", "dnce_M_a", ANIMATION_CATEGORY[2], "Танцы #8"},
    {"DANCING", "dnce_M_b", ANIMATION_CATEGORY[2], "Танцы #9"},
    {"DANCING", "dnce_M_c", ANIMATION_CATEGORY[2], "Танцы #10"},
    {"DANCING", "dnce_M_d", ANIMATION_CATEGORY[2], "Танцы #11"},
    {"DANCING", "dnce_M_e", ANIMATION_CATEGORY[2], "Танцы #12"},
	
    {"BEACH", "bather", ANIMATION_CATEGORY[3], "Прилечь #1"},
    {"BEACH", "Lay_Bac_Loop", ANIMATION_CATEGORY[3], "Прилечь #2"},
    {"BEACH", "ParkSit_M_loop", ANIMATION_CATEGORY[3], "Прилечь #3"},
    {"BEACH", "ParkSit_W_loop", ANIMATION_CATEGORY[3], "Прилечь #4"},
    {"BEACH", "SitnWait_loop_W", ANIMATION_CATEGORY[3], "Прилечь #5"},
    {"CRACK", "crckidle1", ANIMATION_CATEGORY[3], "Поза #1"},
    {"CRACK", "crckidle3", ANIMATION_CATEGORY[3], "Поза #2"},
    {"CRACK", "crckidle4", ANIMATION_CATEGORY[3], "Поза #3"},
    {"BIKED", "BIKEd_Ride", ANIMATION_CATEGORY[3], "Поза #4"},
    {"CRACK", "crckidle2", ANIMATION_CATEGORY[3], "Спать"},
    
    {"CAR", "Fixn_Car_Loop", ANIMATION_CATEGORY[4], "Смотреть"},
    {"CAR", "Fixn_Car_Out", ANIMATION_CATEGORY[4], "Вылезти"},
    {"CAR", "flag_drop", ANIMATION_CATEGORY[4], "Подать старт"},
    {"CAR", "Tyd2car_low", ANIMATION_CATEGORY[4], "На капоте"},
    
    {"BOMBER", "BOM_Plant", ANIMATION_CATEGORY[5], "Бомба"},
    {"CRACK", "crckdeth2", ANIMATION_CATEGORY[5], "Судороги"},
    {"DEALER", "DEALER_IDLE", ANIMATION_CATEGORY[5], "Охрана #1"},
    {"DEALER", "DEALER_IDLE_01", ANIMATION_CATEGORY[5], "Охрана #2"},
    {"FAT", "IDLE_tired", ANIMATION_CATEGORY[5], "Уставший"},
    {"MISC", "plyr_shkhead", ANIMATION_CATEGORY[5], "Ой, д....."},
    {"PARK", "Tai_Chi_Loop", ANIMATION_CATEGORY[5], "Кунг фу"},
    {"PAULNMAC", "Piss_loop", ANIMATION_CATEGORY[5], "Писать"},
   -- {"PAULNMAC", "wank_loop", ANIMATION_CATEGORY[5], "Наяривать"},
    {"ped", "cower", ANIMATION_CATEGORY[5], "Руки за голову!"},
    {"ped", "gang_gunstand", ANIMATION_CATEGORY[5], "Рука вперед"},
    {"ped", "SEAT_idle", ANIMATION_CATEGORY[5], "Присесть"},
    {"SMOKING", "M_smklean_loop", ANIMATION_CATEGORY[5], "Курить #1"},
    {"GANGS", "smkcig_prtl_F", ANIMATION_CATEGORY[5], "Курить #2"},
    {"SWEET", "Sweet_injuredloop", ANIMATION_CATEGORY[5], "Что-то искать"},
    {"RAPPING", "RAP_C_Loop", ANIMATION_CATEGORY[5], "Бить по коленям"},
    {"RAPPING", "RAP_B_Loop", ANIMATION_CATEGORY[5], "Йоу, йоу"},
    {"RAPPING", "RAP_A_Loop", ANIMATION_CATEGORY[5], "Махать руками"},
    {"BD_FIRE", "BD_Panic_03", ANIMATION_CATEGORY[5], "Паника"},
    {"ped", "fucku", ANIMATION_CATEGORY[5], "Пошёл на ***"},
    {"GANGS", "prtial_gngtlkC", ANIMATION_CATEGORY[5], "Разговор №1"},
    {"GANGS", "prtial_gngtlkH", ANIMATION_CATEGORY[5], "Разговор №2"},
    {"ped", "phone_talk", ANIMATION_CATEGORY[5], "Разговор по тел."},
    {"BAR", "dnk_stndM_loop", ANIMATION_CATEGORY[5], "Выпить"},
    {"BASEBALL", "BAT_PART", ANIMATION_CATEGORY[5], "Лещь"},
   -- {"BIKED", "BIKEd_hit", ANIMATION_CATEGORY[5], "Рок-н-ролл"},
  --  {"BIKELEAP", "bk_jmp", ANIMATION_CATEGORY[5], "Легуха"},
   -- {"BSKTBALL", "BBALL_Net_Dnk_O", ANIMATION_CATEGORY[5], "Полный Пи*"},
    {"CAMERA", "camcrch_cmon", ANIMATION_CATEGORY[5], "Подойди"},
    {"CASINO", "manwinb", ANIMATION_CATEGORY[5], "Нож в пузо"},
    {"CASINO", "manwind", ANIMATION_CATEGORY[5], "Ю-Ху"},
    {"CASINO", "Roulette_lose", ANIMATION_CATEGORY[5], "Ударить кулаком"},
    {"COP_AMBIENT", "Coplook_loop", ANIMATION_CATEGORY[5], "Я, не причём"},
    {"COP_AMBIENT", "Coplook_think", ANIMATION_CATEGORY[5], "Задуматься.."},
    {"DAM_JUMP", "DAM_Dive_Loop", ANIMATION_CATEGORY[5], "Встать на руки"},
   -- {"FINALE", "FIN_Cop1_Stomp", ANIMATION_CATEGORY[5], "Тарахан өлтіру"},
    {"FINALE", "FIN_Land_Die", ANIMATION_CATEGORY[5], "Кубарем"},
    {"GANGS", "hndshkda", ANIMATION_CATEGORY[5], "Толкнуть"},
    {"GANGS", "shake_carK", ANIMATION_CATEGORY[5], "Пнуть"},
    {"GHANDS", "gsign1LH", ANIMATION_CATEGORY[5], "Ёу"},
    {"GYMNASIUM", "GYMshadowbox", ANIMATION_CATEGORY[5], "Апперкот"},

    {"on_lookers", "shout_01", ANIMATION_CATEGORY[5], "Крик №1"},
    {"on_lookers", "shout_02", ANIMATION_CATEGORY[5], "Крик №2"},
}

local function isPlayerHasAnimation()
    return (type(getPedAnimation(localPlayer)) == 'string') and true or false
end

function AnimationGUI.create()
    width, height = 280, sDH-170-80
    posX, posY = 250 + 30, 20

    AnimationGUI._posX = posX
    AnimationGUI._posY = posY

    AnimationGUI.wnd = guiCreateWindow(sW*((posX) /sDW), sH*((posY) /sDH), sW*((width) /sDW), sH*((height) /sDH), 'Анимации', false)
    guiWindowSetSizable(AnimationGUI.wnd, false)
    --AnimationGUI.wnd.movable = false
    AnimationGUI.wnd.visible = false

    AnimationGUI.categoryList = guiCreateGridList(0, sH*((30) /sDH), sW*((width-15) /sDW), sH*((140) /sDH), false, AnimationGUI.wnd)
    guiGridListSetSortingEnabled(AnimationGUI.categoryList, false)
    guiGridListAddColumn(AnimationGUI.categoryList, 'Категории анимаций', 0.8)
    addEventHandler('onClientGUIClick', AnimationGUI.categoryList, 
        function()
            AnimationGUI.updateAnimationList(guiGridListGetItemText(source, guiGridListGetSelectedItem(source), 1))
        end, false)

    for _, categoryName in pairs(ANIMATION_CATEGORY) do
        local row = guiGridListAddRow(AnimationGUI.categoryList)
        guiGridListSetItemText(AnimationGUI.categoryList, row, 1, categoryName, false, false)
    end

    AnimationGUI.animList = guiCreateGridList(0, sH*((140+40) /sDH), sW*((width-15) /sDW), sH*((height-140-40-85) /sDH), false, AnimationGUI.wnd)
    guiGridListSetSortingEnabled(AnimationGUI.animList, false)
    guiGridListAddColumn(AnimationGUI.animList, 'Анимации', 0.8)
    addEventHandler('onClientGUIDoubleClick', AnimationGUI.animList, AnimationGUI.onPlayerStartAnimation, false)
    addEventHandler('onClientGUIClick', AnimationGUI.animList, AnimationGUI.updateBtnAnimationAction, false)

    AnimationGUI.btnAnimAction = guiCreateButton(0, sH*((height-75) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), 'Применить анимацию', false, AnimationGUI.wnd)
    guiSetFont(AnimationGUI.btnAnimAction, Font['RR_10'])
    AnimationGUI.btnAnimAction.enabled = false
    guiSetProperty(AnimationGUI.btnAnimAction, 'NormalTextColour', 'FF21b1ff')
    addEventHandler('onClientGUIClick', AnimationGUI.btnAnimAction, AnimationGUI.onPlayerClickAnimationAction, false)

    AnimationGUI.btnClose = guiCreateButton(0, sH*((height-40) /sDH), sW*((width-15) /sDW), sH*((30) /sDH), 'Закрыть', false, AnimationGUI.wnd)
    guiSetFont(AnimationGUI.btnClose, Font['RR_10'])
    addEventHandler('onClientGUIClick', AnimationGUI.btnClose, 
        function()
            AnimationGUI.setVisible()
            guiSetPosition(AnimationGUI.wnd, AnimationGUI._posX, AnimationGUI._posY, false)
        end, false)

    PlayerGUI.addLinkedWindow(AnimationGUI.wnd, AnimationGUI.setVisible, AnimationGUI.getVisible)
end

function AnimationGUI.updateAnimationList(categoryName)
    if (type(categoryName) ~= 'string') then
        return
    end
    
    guiGridListClear(AnimationGUI.animList)
    for _, animationData in ipairs(ANIMATION_LIST) do
        if animationData[3] == categoryName then
            local row = guiGridListAddRow(AnimationGUI.animList)
            guiGridListSetItemText(AnimationGUI.animList, row, 1, animationData[4], false, false)
            guiGridListSetItemData(AnimationGUI.animList, row, 1, {animationData[1], animationData[2]})
        end
    end

    AnimationGUI.updateBtnAnimationAction()
end

function AnimationGUI.updateBtnAnimationAction(isAnimationStart)
    local _isPlayerHasAnimation = isPlayerHasAnimation()
    if (isAnimationStart ~= 'nil' and type(isAnimationStart) == 'boolean') then
        _isPlayerHasAnimation = not not isAnimationStart
    end

    AnimationGUI.btnAnimAction.text = _isPlayerHasAnimation and 'Остановить анимацию' or 'Применить анимацию'
    guiSetProperty(AnimationGUI.btnAnimAction, 'NormalTextColour', _isPlayerHasAnimation and 'fff01a21' or 'FF21b1ff')

    if (not _isPlayerHasAnimation) then
        AnimationGUI.btnAnimAction.enabled = (guiGridListGetSelectedItem(AnimationGUI.animList) ~= -1)
    else
        AnimationGUI.btnAnimAction.enabled = true
    end
end

function AnimationGUI.onPlayerClickAnimationAction()
    if isPlayerHasAnimation() then
        AnimationGUI.onPlayerStopAnimation()
	else
        AnimationGUI.onPlayerStartAnimation()
	end
end

function AnimationGUI.onPlayerStopAnimation()
    if not isPlayerHasAnimation() then
		return false
	end

	triggerServerEvent('tmtaCore.setPlayerAnimation', localPlayer)
    unbindKey('jump', 'down', AnimationGUI.onPlayerStopAnimation)
    AnimationGUI.updateBtnAnimationAction(false)

    return true
end

function AnimationGUI.onPlayerStartAnimation()
    local sel = guiGridListGetSelectedItem(AnimationGUI.animList)
    if (sel ~= -1) then
        local animation = guiGridListGetItemData(AnimationGUI.animList, sel, 1)
        if isPedInVehicle(localPlayer) then
            exports.tmtaNotification:showInfobox(
                'info', 
                "#FFA07AУведомление", 
                "Нельзя применять #FFA07Aанимацию#FFFFFF, находясь в транспортном средстве", 
                _, 
                {240, 146, 115}
            )
            return false
        end

        triggerServerEvent('tmtaCore.setPlayerAnimation', localPlayer, animation[1], animation[2])
        exports.tmtaNotification:showInfobox(
            'info', 
            "#FFA07AУведомление", 
            "Чтобы остановить анимацию выполните #FFA07A'ПРЫЖОК'", 
            _, 
            {240, 146, 115}
        )

        bindKey('jump', 'down', AnimationGUI.onPlayerStopAnimation)

        AnimationGUI.updateBtnAnimationAction(true)

        return true
    end

    return false
end

function AnimationGUI.getVisible()
    return AnimationGUI.visible
end

function AnimationGUI.setVisible(state)
    local state = (type(state) == 'boolean') and state or not AnimationGUI.visible
    AnimationGUI.wnd.visible = state
    AnimationGUI.visible = state
end