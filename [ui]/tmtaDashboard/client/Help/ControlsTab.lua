ControlsTab = {}

local playerControl = {
	{ key = 'F1', option = 'главное меню', description = '' },
	{ key = 'F3', option = 'личный транспорт (гараж)', description = '' },
	{ key = 'F5', option = 'подсказки управления', description = '' },
	{ key = 'F7', option = 'настройка игры', description = '' },
	{ key = 'F9', option = 'окно помощи', description = '' },
	{ key = 'F11', option = 'карта', description = '' },
	{ key = 'F12', option = 'скриншот', description = '' },
	{ key = 'TAB', option = 'список игроков', description = '' },
	{},
	{ key = 'F10', option = 'меню дальнобойщика', description = 'доступно в рабочем транспорте' },
	{},
	{ key = 'T, F6', option = 'чат', description = '' },
	{},
	{ key = 'X', option = 'воспроизвести звуковой фрагмент', description = '' },
}

local vehicleControl = {
	{ key = '1', option = 'завести/заглушить двигатель', description = '' },
	{ key = 'L', option = 'вкл/выкл фары', description = '' },
	{},
	{ key = ',', option = 'левый указатель поворота', description = "клавиша 'Б'" },
	{ key = '.', option = 'левый указатель поворота', description = "клавиша 'Ю'" },
	{ key = '/', option = 'аварийка', description = 'Ю' },
	{},
	{ key = '4, 5', option = 'онлайн радио', description = 'предыдущая/следующая станция соответственно' },
	{ key = '0', option = 'музыкальный плеер', description = 'онлайн музыка' },
	{},
	{ key = 'C', option = 'круиз-контроль', description = '' },
	{ key = 'H', option = 'звуковой сигнал', description = '' },
	{ key = 'J', option = 'открытие/закрытие дверей', description = '' },
	{ key = "CTRL / MOUSE1", option = 'закись азота', description = '' },
}

function ControlsTab.create(posX, posY, width, height, wnd)
    if not isElement(wnd) then
        return
    end

    ControlsTab.tab = guiCreateTab("Управление", wnd)

    local lbl = guiCreateLabel(20, 15, 265, 50, "ОСНОВНОЕ УПРАВЛЕНИЕ", false, ControlsTab.tab)
    guiSetFont(lbl, "default-bold-small")
    guiLabelSetColor(lbl, 240, 26, 33)

    for i, control in ipairs(playerControl) do
        if control.key then
		
			local offsetX = 20
			-- Клавиша
			local lbl = guiCreateLabel(offsetX, 20 + i*20, 200, 50, '[', false, ControlsTab.tab)
			guiSetAlpha(lbl, 0.4)

			offsetX = offsetX + 8
			local lbl = guiCreateLabel(offsetX, 20 + 1 + i*20, 200, 50, control.key, false, ControlsTab.tab)
			guiLabelSetHorizontalAlign(lbl, "left")
			guiSetFont(lbl, "default-bold-small")
			guiLabelSetColor(lbl, 33, 177, 255)

			offsetX = offsetX + 3.5 + guiLabelGetTextExtent(lbl)
			local lbl = guiCreateLabel(offsetX, 20 + i*20, 200, 50, ']', false, ControlsTab.tab)
			guiSetAlpha(lbl, 0.4)

			-- Тире
			offsetX = offsetX + guiLabelGetTextExtent(lbl) + 5
			local lbl = guiCreateLabel(offsetX, 20 + 1 + i*20, 200, 50, '—', false, ControlsTab.tab)
			guiLabelSetHorizontalAlign(lbl, "left")
			guiSetFont(lbl, "default-bold-small")
			guiSetAlpha(lbl, 0.4)

			-- Действие
			offsetX = offsetX + guiLabelGetTextExtent(lbl) + 5
			local lbl = guiCreateLabel(offsetX, 20 + 1 + i*20, 200, 50, control.option, false, ControlsTab.tab)
			guiLabelSetHorizontalAlign(lbl, "left")

			-- Дополнительное описание
			if control.description ~= '' then
				offsetX = offsetX + guiLabelGetTextExtent(lbl) + 5
				local lbl = guiCreateLabel(offsetX, 20 + 1 + i*20, 300, 50, '('..control.description..')', false, ControlsTab.tab)
				guiLabelSetHorizontalAlign(lbl, "left")
				guiSetAlpha(lbl, 0.4)
			end
        end
    end

	local lbl = guiCreateLabel(1024/2, 15, 365, 50, "УПРАВЛЕНИЕ ТРАНСПОРТОМ", false, ControlsTab.tab)
	guiSetFont(lbl, "default-bold-small")
	guiLabelSetColor(lbl, 240, 26, 33)

	for i, control in ipairs(vehicleControl) do
		if control.key then

			local offsetX = 1024/2
			-- Клавиша
			local lbl = guiCreateLabel(offsetX, 20 + i*20, 365, 50, '[', false, ControlsTab.tab)
			guiSetAlpha(lbl, 0.4)

			offsetX = offsetX + 8
			local lbl = guiCreateLabel(offsetX, 20 + 1 + i*20, 365, 50, control.key, false, ControlsTab.tab)
			guiLabelSetHorizontalAlign(lbl, "left")
			guiSetFont(lbl, "default-bold-small")
			guiLabelSetColor(lbl, 33, 177, 255)

			offsetX = offsetX + 3.5 + guiLabelGetTextExtent(lbl)
			local lbl = guiCreateLabel(offsetX, 20 + i*20, 365, 50, ']', false, ControlsTab.tab)
			guiSetAlpha(lbl, 0.4)

			-- Тире
			offsetX = offsetX + guiLabelGetTextExtent(lbl) + 5
			local lbl = guiCreateLabel(offsetX, 20 + 1 + i*20, 365, 50, '—', false, ControlsTab.tab)
			guiLabelSetHorizontalAlign(lbl, "left")
			guiSetFont(lbl, "default-bold-small")
			guiSetAlpha(lbl, 0.4)

			-- Действие
			offsetX = offsetX + guiLabelGetTextExtent(lbl) + 5
			local lbl = guiCreateLabel(offsetX, 20 + 1 + i*20, 365, 50, control.option, false, ControlsTab.tab)
			guiLabelSetHorizontalAlign(lbl, "left")

			-- Дополнительное описание
			if control.description ~= '' then
				offsetX = offsetX + guiLabelGetTextExtent(lbl) + 5
				local lbl = guiCreateLabel(offsetX, 20 + 1 + i*20, 365, 50, '('..control.description..')', false, ControlsTab.tab)
				guiLabelSetHorizontalAlign(lbl, "left")
				guiSetAlpha(lbl, 0.4)
			end

		end
	end
	
    return ControlsTab.tab
end