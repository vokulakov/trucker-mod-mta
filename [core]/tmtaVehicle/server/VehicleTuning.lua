VehicleTuning = {}

VehicleTuning.defaultTuningTable = {
    -- Цвета
    BodyColor 		        = {255, 255, 255},	-- Цвет кузова
    BodyColorAdditional     = false,            -- Цвет кузова (дополнительный)
    BodyPaintType           = 0,                -- Тип покраски
    BodyTexture 	        = false,			-- Текстура кузова

    WheelsColorR 	        = {255, 255, 255},	-- Цвет задних дисков
    WheelsColorF 	        = {255, 255, 255},	-- Цвет передних дисков

    NeonColor 		        = false,			-- Цвет неона
    HeadLightColor	        = {255, 255, 255},	-- Цвет фар

    NumberFrame		        = false, -- Номерная рамка
	NumberCurtain	        = false, -- Номерная шторка

    CarAlarm                = false, -- Сигнализация
	CarSound                = false, -- Автозвук

    --[[TODO: так же должны быть параметры 
        по турбине и т.д. из системы звука двигателя
        загрязнение транспорта
        радар-детектор
        дополнительный бак
    ]]

    -- Колёса
    WheelsAngleF 	        = 0, -- Развал передних колёс
    WheelsAngleR 	        = 0, -- Развал задних колёс
    WheelsSize		        = 0.69, -- Размер 
    WheelsWidthF 	        = 0, -- Толщина передних колёс
    WheelsWidthR	        = 0, -- Толщина задних колёс
    WheelsOffsetF	        = 0, -- Вынос передних колёс
    WheelsOffsetR	        = 0, -- Вынос задних колёс
    WheelsF 		        = 0, -- Передние диски
    WheelsR 		        = 0, -- Задние диски

    Suspension 		        = 0.4, -- Высота подвески

    -- Компоненты
    Components              = false,
}

function VehicleTuning.applyToVehicle(vehicle, tuningJSON, stickersJSON)
    if (not isElement(vehicle)) then
		return false
	end
end