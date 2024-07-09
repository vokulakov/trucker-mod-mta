local handlingsTable = {}

handlingsTable['izh_2715'] = "SADLER 1700 4500 2.7 0 0 -0.05 75 0.65 0.7 0.5 5 70 5 20 r d 8.5 0.5 false 35 0.8 0.08 3 0.25 -0.15 0.4 0.4 0.26 0.2 26000 200040 104004 0 1 0"
handlingsTable['izh_oda_2717'] = "FBITRUCK 4000 10000 2 0 0 -0.2 85 0.65 0.85 0.54 5 170 10 25 r d 6 0.4 false 30 0.8 0.1 0 0.3 -0.12 0.4 0 0.32 0.16 40000 4001 0 0 1 13"
handlingsTable['gazel_3302'] = "MULE 3500 14000 4 0 0 0.1 80 0.55 0.85 0.46 5 140 7.2 20 r d 4.5 0.6 false 30 2 0.07 5 0.3 -0.15 0.5 0 0.46 0.53 22000 4088 4048400 0 3 0"

function getVehicleHandlingConfig(vehicleName)
    local handlingString = handlingsTable[vehicleName]
    if (not handlingString or type(handlingString) ~= 'string') then
        return false
    end
    return importHandling(handlingString)
end