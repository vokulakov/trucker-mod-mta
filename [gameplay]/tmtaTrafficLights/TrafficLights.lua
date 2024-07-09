local TrafficLights = {}
	
TrafficLights.Config = {}

TrafficLights.Config.TIME_LIGHTS_GREEN  = 20000 	-- время фиксирования зеленого сигнала (20 секунд)
TrafficLights.Config.TIME_LIGHTS_YELLOW = 3000 	    -- время фиксирования желтого сигнала (3 секунды)
TrafficLights.Config.TIME_LIGHTS_RED    = 4000 	    -- время фиксирования красного сигнала (4 секунды)

TrafficLights.Status = false -- состояние сфетоворов (включены\выключены)

-- Установить светофор в режим "неисправный" (нерегулируемый перекресток)
function TrafficLights.setOutOfOrder()
    local lightsOff = getTrafficLightState() == 9
    if lightsOff then
        setTrafficLightState(6)
    else
        setTrafficLightState(9)
    end
end

-- Обычный режим работы светофоров
function TrafficLights.updateState()
	setTrafficLightState(2)
	for _, k in ipairs(TrafficLights.Config.States) do
		k.isTimer = setTimer(setTrafficLightState, k.timer_time, 1, k.state)
	end
end

function TrafficLights.calculateTime()
	-- Таблица порядка переключения состояний светофоров [https://wiki.multitheftauto.com/wiki/Traffic_light_states]
	TrafficLights.Config.States = { 
		{ state = 1, stop_time = TrafficLights.Config.TIME_LIGHTS_YELLOW }, -- СЕВЕР - ЮГ (желтые) (горит 3 секунды) ЧЕРЕЗ 4 секунд
		{ state = 0, stop_time = TrafficLights.Config.TIME_LIGHTS_GREEN }, -- СЕВЕР - ЮГ (зеленые) (горит 20 секунд) ЧЕРЕЗ 7 секунд
		{ state = 1, stop_time = TrafficLights.Config.TIME_LIGHTS_YELLOW }, -- СЕВЕР - ЮГ (желтые) (горит 3 секунды) ЧЕРЕЗ 27 секунд
		{ state = 2, stop_time = TrafficLights.Config.TIME_LIGHTS_RED }, -- СЕВЕР - ЮГ и ЗАПАД - ВОСТОК (все красные) (горит 4 секунды) ЧЕРЕЗ 30 секунд
		{ state = 4, stop_time = TrafficLights.Config.TIME_LIGHTS_YELLOW }, -- ЗАПАД - ВОСТОК (желтый) (горит 3 секунды) ЧЕРЕЗ 34 секунды
		{ state = 3, stop_time = TrafficLights.Config.TIME_LIGHTS_GREEN }, -- ЗАПАД - ВОСТОК (зеленый) (горит 20 секунд) ЧЕРЕЗ 37 секунд
		{ state = 4, stop_time = TrafficLights.Config.TIME_LIGHTS_YELLOW }, -- ЗАПАД - ВОСТОК (желтый) (горит 3 секунды) ЧЕРЕЗ 57 секунды
	}

	local currentTime = TrafficLights.Config.TIME_LIGHTS_RED

	for _, k in ipairs(TrafficLights.Config.States) do
		k.timer_time = currentTime
		currentTime = currentTime + k.stop_time
	end

	return currentTime
end

function TrafficLights.start() -- включить светофоры
	if isTimer(TrafficLights.isTimerUpdate) or TrafficLights.status then
		return
	end

	TrafficLights.isTimerUpdate = setTimer(
		function()
			local isTimerOutOfOrder = TrafficLights.isTimerOutOfOrder

			if isTimer(isTimerOutOfOrder) then
				killTimer(isTimerOutOfOrder)
				TrafficLights.isTimerOutOfOrder = nil
			end

			TrafficLights.updateState()
		end, 
		TrafficLights.calculateTime(), 
		0
	)

	TrafficLights.Status = true
end

function TrafficLights.stop() -- выключить светофоры
	if isTimer(TrafficLights.isTimerOutOfOrder) then
		return
	end
	
	local isTimerUpdate = TrafficLights.isTimerUpdate

	if isTimer(isTimerUpdate) then
		killTimer(isTimerUpdate)
		TrafficLights.isTimerUpdate = nil

		for _, k in ipairs(TrafficLights.Config.States) do
			if isTimer(k.isTimer) then
				killTimer(k.isTimer)
				k.isTimer = nil
			end
		end
	end


	TrafficLights.isTimerOutOfOrder = setTimer(
		TrafficLights.setOutOfOrder, 
		1000, 
		0
	)

	TrafficLights.Status = false
end

-- EVENTS --
addEventHandler("onResourceStart", resourceRoot, function()
	setTrafficLightState("disabled")
	
	TrafficLights.stop()
	TrafficLights.start()
end)

addEventHandler("onResourceStop", resourceRoot, function()
	setTrafficLightState("disabled")
end)

-- COMMANDS --
--addCommandHandler('tloff', TrafficLights.stop)
--addCommandHandler('tlon', TrafficLights.start)