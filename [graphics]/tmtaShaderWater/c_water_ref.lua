--
-- c_water_ref.lua
--

local isDepthSupported
----------------------------------------------------------------
-- DepthBuffer error handling
----------------------------------------------------------------
function zErrorHandling()
 local info=dxGetStatus()
 local depthStatus=false
 isDepthSupported=false
    for k,v in pairs(info) do
		if string.find(k, "VideoCardName") or string.find(k, "SettingAntiAliasing") then outputChatBox(k.." : "..tostring(v)) end
		if string.find(k, "DepthBufferFormat") then
		depthStatus=true
		if tostring(v)=='unknown' then outputChatBox('DepthBuffer not supported!') 
		  else
		   isDepthSupported=true
		   outputChatBox(k.." : "..tostring(v))
		  end
		end
    end
	if depthStatus==false then 
	 isDepthSupported=false
	 outputChatBox('Resource is not compatible with this client.') 
	 outputChatBox('Please get latest 1.3.1 nightly from nightly.mtasa.com') 
	end
end


addEventHandler( "onClientResourceStart", resourceRoot,
	function()

		-- Version check
		if getVersion ().sortable < "1.3.0" then
			--outputChatBox( "Resource is not compatible with this client." )
			return
		end
		-- Check if depthbuffer is readable
		--zErrorHandling()
		-- Create shader
		myShader, tec = dxCreateShader ( "water_ref.fx" )
		--outputChatBox( "Using technique " .. tec )
		if not myShader or isDepthSupported==false then
			--outputChatBox( "Could not create shader. Please use debugscript 3" )
		else
			--outputChatBox("shader_water_refrac_test2 has started ..")
            
			-- Set textures
			local textureVol = dxCreateTexture ( "images/smallnoise3d.dds" );
			dxSetShaderValue ( myShader, "sRandomTexture", textureVol );
			dxSetShaderValue ( myShader, "normalMult", 0.55 );

			-- Apply to global txd 13
			engineApplyShaderToWorldTexture ( myShader, "waterclear256" )
			
			-- Update water color incase it gets changed by persons unknown
			setTimer(	function()
							if myShader then
								local r,g,b,a = getWaterColor()
								dxSetShaderValue ( myShader, "sWaterColor", r/255, g/255, b/255, a/255 );
							end
						end
						,100,0 )
		end
	end
)


