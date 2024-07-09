Font = {}

Font.created = {}
Font.list = Config.FONT_LIST

function Font.createDX(name, ...)
	local fontUrl = Font.list[name]
	if type(name) ~= "string" or not fontUrl then
		return false
	end

	local font = dxCreateFont(fontUrl, ...)

	if sourceResource then
		if not Font.created[sourceResource] then
			Font.created[sourceResource] = {}
		end
		table.insert(Font.created[sourceResource], font)
	end

	return font	
end

function Font.createGUI(name, ...)
	local fontUrl = Font.list[name]
	if type(name) ~= "string" or not fontUrl then
		return false
	end

	local font = guiCreateFont(fontUrl, ...)

	if sourceResource then
		if not Font.created[sourceResource] then
			Font.created[sourceResource] = {}
		end
		table.insert(Font.created[sourceResource], font)
	end

	return font
end

addEventHandler("onClientResourceStop", root,
	function(stoppedRes)
		local fonts = Font.created[stoppedRes]
		if not fonts then
			return
		end

		for _, font in ipairs(fonts) do
			if isElement(font) then
				destroyElement(font)
			end
		end
		
		Font.created[stoppedRes] = nil
	end
)

-- Exports
createFontDX = Font.createDX
createFontGUI = Font.createGUI