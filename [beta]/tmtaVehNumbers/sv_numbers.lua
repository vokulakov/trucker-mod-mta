db = exports.tmtaSQLite:dbGetConnection()
--dbExec(db, "DROP TABLE Numbers")
dbExec(db, "CREATE TABLE IF NOT EXISTS Numbers (ID, Model, Number)")

function initNumberWindow(ply)
	local accName = getAccountName ( getPlayerAccount ( ply ) )
    if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" ) ) then
    	triggerClientEvent( ply, "initNewNumberWindow", ply, true )
    end
end
addCommandHandler( "numbers", initNumberWindow )

function giveTransitNumber(ID, model)

	local letters = {"A","B","C","E","H","K","M","O","P","T","X","Y"}

	local sym_1 = letters[math.random(#letters)]
	local sym_2 = letters[math.random(#letters)]
	local sym_3 = letters[math.random(#letters)]

	local numbers = string.format("%03d", math.random(1,999))
	local region = string.format("%02d", math.random(#regions['Russia']))

	local plate = {
		"tr",
		string.format("%s%s%s%s%s", sym_1, sym_2, numbers, sym_3, region)
	}

	local result = dbPoll(dbQuery(db, "SELECT * FROM Numbers WHERE Number = ?", toJSON(plate)), -1)

	if #result < 1 then
		dbExec(db, "INSERT INTO Numbers VALUES (?,?,?)", ID, model, toJSON(plate))
		return plate
	end

	return giveTransitNumber()
end

--addCommandHandler("num",  giveTransitNumber)

function buyNumberPlate(ntype,text,price)
	local num = toJSON({ntype,text})
	local result = dbPoll(dbQuery(db, "SELECT * FROM Numbers WHERE Number = ?",num),-1)
	if #result < 1 then
		local veh = getPedOccupiedVehicle(source)
		if veh then
			if exports.tmtaMoney:getPlayerMoney(source) >= price then
				exports.tmtaMoney:takePlayerMoney(source,price)
				setElementData(veh,"numberType",ntype)
				setElementData(veh,"number:plate",text)
				local id = getElementData(veh, "ID")
				
				exports.tmtaNotification:showInfobox(
					source, 
					"info", 
					"#FFA07AГосавтоинсекция", 
					"#FFFFFFВы приобрели номерной знак #FFA07A"..text.."|"..ntype.."|#FFFFFF за #FFA07A"..price.." #FFFFFF₽", 
					_, 
					{240, 146, 115}
				)

				saveNumbers(veh)
				
				local result2 = dbPoll(dbQuery(db, "SELECT * FROM Numbers WHERE ID = ?", getElementData(veh,"ID")),-1)
				if result2 and type(result2) == "table" and #result2 >= 1 then
					dbExec(db,"UPDATE Numbers SET Number = ? WHERE ID = ?",num,getElementData(veh,"ID"))
				else
					dbExec(db,"INSERT INTO Numbers VALUES (?,?,?)",getElementData(veh,"ID"),getElementModel(veh),num)
				end 
				
			else
				exports.tmtaNotification:showInfobox(
					source, 
					"info", 
					"#FFA07AГосавтоинспекция", 
					"У вас недостаточно денежных средств", 
					_, 
					{240, 146, 115}
				)
			end
		else
			exports.tmtaNotification:showInfobox(
				source, 
				"info", 
				"#FFA07AГосавтоинсекция", 
				"Вы должны находиться в транспортном средстве", 
				_, 
				{240, 146, 115}
			)
		end
	else
		outputChatBox("Такие номера уже существуют!",source)
	end
end
addEvent("buyNumberPlate", true)
addEventHandler("buyNumberPlate", root, buyNumberPlate)

function removeNumberData(id) -- Called when vehicles has been erased from database
	dbExec(db,"DELETE FROM Numbers WHERE ID = ?",id)
	--outputChatBox("DELETED")
end
addEvent("removeNumberData",true)
addEventHandler("removeNumberData",root,removeNumberData)

function saveNumbers(veh)
	local result = dbPoll(dbQuery(db, "SELECT * FROM Numbers WHERE ID = ?", getElementData(veh,"ID")),-1)
	local num = toJSON({getElementData(veh,"numberType"),getElementData(veh,"number:plate")})
	if result and type(result) == "table" and #result >= 1 then
		dbExec(db,"UPDATE Numbers SET Number = ? WHERE ID = ?",num,getElementData(veh,"ID"))
	else
		dbExec(db,"INSERT INTO Numbers VALUES (?,?,?)",getElementData(veh,"ID"),getElementModel(veh),num)
	end 
end
addEvent("saveNumbers",true)
addEventHandler("saveNumbers",root,saveNumbers)

addEventHandler("onElementDataChange",getRootElement(),function(data)
	if data == "ID" and getElementType(source) == "vehicle" then
		local result = dbPoll(dbQuery(db, "SELECT * FROM Numbers WHERE ID = ?", getElementData(source,"ID")),-1)
		if result and type(result) == "table" and #result >= 1 then
			--outputChatBox(result[1]["Model"])
			if result[1]["Model"] == getElementModel(source) then
				local num = fromJSON(result[1]["Number"])
				--outputChatBox(num[1].." "..num[2])
				setElementData(source,"numberType",num[1])
				setElementData(source,"number:plate",num[2])
			else
				removeNumberData(getElementData(source,"ID"))
			end
		end
	end
end)