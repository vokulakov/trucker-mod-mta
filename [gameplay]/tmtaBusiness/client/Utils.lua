Utils = {}

Utils.sW, Utils.sH = guiGetScreenSize()
Utils.sDW, Utils.sDH = exports.tmtaUI:getScreenSize()

-- Шрифты
Utils.fonts = {
    ['RR_8'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 8),
    ['RR_10'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 10),
	['RR_11'] = exports.tmtaFonts:createFontGUI('RobotoRegular', 11),
    ['RB_10'] = exports.tmtaFonts:createFontGUI('RobotoBold', 10),
	['RB_11'] = exports.tmtaFonts:createFontGUI('RobotoBold', 11),

	['DX_RR_12'] = exports.tmtaFonts:createFontDX('RobotoRegular', 12),
    ['DX_RR_14'] = exports.tmtaFonts:createFontDX('RobotoRegular', 14),
	['DX_Elowen_22'] = exports.tmtaFonts:createFontDX('Elowen', 22),

	['DX_RB_12'] = exports.tmtaFonts:createFontDX('RobotoBold', 12),
}