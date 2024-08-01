sW, sH = guiGetScreenSize()
sDW, sDH = Utils.getLimitedScreenSize()

Texture = {}
Font = {}

addEventHandler('onClientHUDRender', root, 
    function()
        dxSetBlendMode("modulate_add")
            Rectangle.render()
            KeyPanel.render()
        dxSetBlendMode("blend")
    end, true, 'low-4'
)

addEventHandler('onClientResourceStart', resourceRoot,
    function()
        -- Particles
        Texture['partDot']          = exports.tmtaTextures:createTexture('part_dot')
        Texture['partRound1']       = exports.tmtaTextures:createTexture('part_round1')
        Texture['partRound2']       = exports.tmtaTextures:createTexture('part_round2')
        Texture['partRound3']       = exports.tmtaTextures:createTexture('part_round3')
        Texture['partRound4']       = exports.tmtaTextures:createTexture('part_round4')	

        -- Keys
        Texture['keyMouseDown']     = exports.tmtaTextures:createTexture('keyMouseDown')
        Texture['keyMouseLeft']     = exports.tmtaTextures:createTexture('keyMouseLeft')
        Texture['keyMouseRight']    = exports.tmtaTextures:createTexture('keyMouseRight')
        Texture['keyMouseUp']       = exports.tmtaTextures:createTexture('keyMouseUp')
	    Texture['keyMouseWheel']    = exports.tmtaTextures:createTexture('keyMouseWheel')
	    Texture['keyMouse']         = exports.tmtaTextures:createTexture('keyMouse')

        Texture['keyE'] 		    = exports.tmtaTextures:createTexture('keyE')
        Texture['keyEnter'] 		= exports.tmtaTextures:createTexture('keyEnter')
        Texture['keyF11'] 			= exports.tmtaTextures:createTexture('keyF11')
        Texture['keySpace'] 		= exports.tmtaTextures:createTexture('keySpace')

        for _, texture in pairs(Texture) do
            dxSetTextureEdge(texture, "clamp")
        end
      
        -- Font
        Font['RR_10'] = exports.tmtaFonts:createFontDX("RobotoRegular", 10)
    end
)

addEventHandler('onClientElementDestroy', root, 
    function()
        if (source.type ~= 'gui-label') then
            return
        end
        Rectangle.destroy(source)
        KeyPanel.destroy(source)
    end
)