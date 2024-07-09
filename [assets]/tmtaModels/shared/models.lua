--[[
1025, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 
1084, 1085, 1097, 1098, 1004, 1005, 1006, 1051, 1011, 1012, 1013, 1017,
1024, 1026, 1027, 1030, 1031, 1032, 1033, 1035, 1036, 1038, 1039, 1040,
1041, 1042, 1043, 1044, 1047, 1048, 1062, 1052, 1053, 1054, 1055, 1056,
1057, 1061, 1063, 1067, 1068, 1088,
]]

ReplacedModels = {

    -- Vehicles
    ['vehicles/cars/bmw/bmw_m4_g82']      = 402,
    ['vehicles/cars/bmw/bmw_m8']          = 587,
    ['vehicles/cars/bmw/bmw_m3_touring']  = 479,

    ['vehicles/trailers/435']  = 435,
    ['vehicles/trailers/450']  = 450,
    ['vehicles/trailers/584']  = 584,
    ['vehicles/trailers/591']  = 591,

    -- trucks
    ['vehicles/trucks/izh_2715'] = 605,
    ['vehicles/trucks/izh_2717'] = 543,
    ['vehicles/trucks/izh_oda_2717'] = 528,

    ['vehicles/trucks/gazel_3302'] = 414,
    ['vehicles/trucks/raf_2203'] = 478,
    ['vehicles/trucks/gaz_53'] = 455,
    ['vehicles/trucks/gazon_next'] = 499,
    ['vehicles/trucks/vw_transporter'] = 609,
    ['vehicles/trucks/mercedes_benz_sprinter'] = 482,

    ['vehicles/trucks/iveco_stralis_500'] = 544,
    ['vehicles/trucks/volvo_fh12'] = 578,
    ['vehicles/trucks/scania_r700'] = 433,
    ['vehicles/trucks/kamaz_54115'] = 573,
    
    ['vehicles/trucks/freightliner_columbia'] = 403,
    ['vehicles/trucks/kamaz_54901'] = 515,
    ['vehicles/trucks/volvo_fh_460'] = 514,
    
    -- Objects
    ['objects/otdelPolice/park']        = 900, 
    ['objects/otdelPolice/vorota']      = 901,
    ['objects/otdelPolice/parkovka']    = 7696,
    ['objects/otdelPolice/flag']        = 915,
    ['objects/otdelPolice/otdel']       = 916,
    ['objects/otdelPolice/1']           = 917,
    ['objects/otdelPolice/hkaf']        = 918,
    ['objects/otdelPolice/okno']        = 919,
    ['objects/otdelPolice/plakat']      = 920,
    ['objects/otdelPolice/2']           = 921,

    ['objects/other/case'] = 1210,
	
	['objects/interiors/paint_garage'] = 1872,
	['objects/interiors/tuning_garage/Mesh_01'] = 1000,
	['objects/interiors/tuning_garage/Mesh_02'] = 1001,
	['objects/interiors/tuning_garage/Mesh_03'] = 1002,
	['objects/interiors/tuning_garage/Mesh_04'] = 1003,
	['objects/interiors/tuning_garage/Mesh_05'] = 1014,
	['objects/interiors/tuning_garage/Mesh_06'] = 1015,
	
}

OverwriteFiles = {
    ['objects/interiors/tuning_garage/Mesh_02'] = { txd = "objects/interiors/tuning_garage/Mesh_01" },
	['objects/interiors/tuning_garage/Mesh_03'] = { txd = "objects/interiors/tuning_garage/Mesh_01" },
	['objects/interiors/tuning_garage/Mesh_04'] = { txd = "objects/interiors/tuning_garage/Mesh_01" },
	['objects/interiors/tuning_garage/Mesh_05'] = { txd = "objects/interiors/tuning_garage/Mesh_01" },
	['objects/interiors/tuning_garage/Mesh_06'] = { txd = "objects/interiors/tuning_garage/Mesh_01" },
}

function getReplacedModel(name)
    if not name then
        return
    end
    return ReplacedModels[name]
end
