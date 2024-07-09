local gRoot = getRootElement();
local screen = {guiGetScreenSize()};

----	[[ GUI ]]
window = guiCreateWindow((screen[1]/2)-(520/2), (screen[2]/2)-(400/2), 520, 400, "Manager position (by eweest)", false);	-- Окно
guiWindowSetSizable(window, false)
guiSetVisible(window, false)

tabPanel = guiCreateTabPanel(0, 30, 500, 360, false, window)
tabPos = guiCreateTab("Copy Pos", tabPanel)

Text = guiCreateMemo(10, 10, 480, 240, "", false, tabPos)	-- Окно с позициями
guiMemoSetReadOnly(Text, false)

enterName = guiCreateEdit(10, 260, 200, 30, "name_enter", false, tabPos)	-- Ввод Название
enterCtgr = guiCreateEdit(220, 260, 200, 30, "ctgr_enter", false, tabPos)	-- Ввод Категория

buttonCopy = guiCreateButton(10, 295, 410, 30, "Save position (FOR EXEL TABLE)", false, tabPos)	-- Кнопка Установки позиции
guiSetProperty (buttonCopy, "NormalTextColour", "FF99ff99")
guiSetProperty (buttonCopy, "HoverTextColour", "FF008000")
buttonClear = guiCreateButton(425, 260, 65, 65, "CLEAR \n(ALL)", false, tabPos)	-- Кнопка Очистить
guiSetProperty (buttonClear, "NormalTextColour", "FFff6666")
guiSetProperty (buttonClear, "HoverTextColour", "FFff0000")
----	[[ END ]]

----	[[ SHOWGUI ]]
bindKey("f10", "down",
	function ()
		guiSetVisible(window, not guiGetVisible(window));
		showCursor(not isCursorShowing());
	end)
----	[[ END ]]

----	[[ ADD POSITION ]]
a={}
c={}
function addPos()
	local x,y,z=getElementPosition(getLocalPlayer())
	local lct 	= getZoneName(x, y, z, true)
	local lct_c = getZoneName(x, y, z, false)

	local name = guiGetText(enterName)
	local ctgr = guiGetText(enterCtgr)

	--local pos="LOCATION: "..lct..","..lct_c..", NAME: "..name..", CATEGORY: "..ctgr..", POS: "..x..","..y..","..z 											-- Text
	local pos=lct..", " ..lct_c.."	"..ctgr.."	"..name.."	"..x..", "..y..", "..z 																												-- EXEL
	--local pos="{location = \""..lct..", "..lct_c.."\", category = \""..ctgr.."\", name = \""..name.."\", "..x..", "..y..", "..z.."}," 	-- Code
	local r=math.random(0,255)
	local g=math.random(0,255)
	local b=math.random(0,255)
	local theMarker = createMarker ( x, y, z, "checkpoint", 1, r, g, b, 170 )
	table.insert(a, pos)
	table.insert(c, theMarker)
	--outputChatBox(("•••• #EEEEEEПозиция добавлена в список."), 0, 255, 0, true)
	guiSetText(Text,"")
	for i,pos in ipairs(a) do
		local text=guiGetText(Text)
		guiSetText(Text,text..pos)
	end
end
addEventHandler("onClientGUIClick", buttonCopy, addPos)
----	[[ END ]]

----	[[ CLEAR POSITION IN MENU ]]
function ClearPossitions()
	for i, v in ipairs ( a ) do
		while a[ i ] and not tonumber( a[ i ] ) do
			table.remove( a, i )
		end
	end
	for i,m in ipairs ( c ) do
		destroyElement(m)
	end
	for i, v in ipairs ( c ) do
		while c[ i ] and not tonumber( c[ i ] ) do
			table.remove( c, i )
		end
	end
	guiSetText(Text,"")
	--outputChatBox(("•••• #EEEEEEВсе позиции удалены. Список очищен."), 255, 0, 0, true)
end
addEventHandler("onClientGUIClick", buttonClear, ClearPossitions)
----	[[ END ]]