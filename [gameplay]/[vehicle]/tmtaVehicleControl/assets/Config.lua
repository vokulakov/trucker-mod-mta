local vehicleNoBelt = {
    [581] = true,
    [509] = true,
    [481] = true,
    [462] = true,
    [521] = true,
    [463] = true,
    [510] = true,
    [522] = true,
    [461] = true,
    [448] = true,
    [468] = true,
    [586] = true,
    [417] = true,
    [425] = true,
    [447] = true,
    [460] = true,
    [464] = true,
    [465] = true,
    [469] = true,
    [476] = true,
    [487] = true,
    [488] = true,
    [497] = true,
    [501] = true,
    [511] = true,
    [512] = true,
    [513] = true,
    [519] = true,
    [520] = true,
    [548] = true,
    [553] = true,
    [563] = true,
    [577] = true,
    [592] = true,
    [593] = true,
    [430] = true,
    [446] = true,
    [452] = true,
    [453] = true,
    [454] = true,
    [472] = true,
    [473] = true,
    [484] = true,
    [493] = true,
    [530] = true,
    [531] = true,
    [537] = true,
    [538] = true,
    [569] = true,
    [570] = true,
    [571] = true,
    [574] = true,
    [590] = true,

    -- прицепы
    [435] = true,
    [450] = true,
    [591] = true,
    [584] = true,
}

function isVehicleHaveBelt (model)
    return vehicleNoBelt[model] or false
end
