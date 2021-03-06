mysql = exports.mysql
shape = {}
marker = {}

acc_name = { -- YETKİ AYARLAMA KISMI
	['Client'] = true,
}

addCommandHandler("otopark", function(player, cmd, command, ID)
    if acc_name[getElementData(player, 'account:username')] then
        if not command then 
            outputChatBox("[!] #E0E0E0/"..cmd.." [olustur/sil] ", player, 109, 160, 101, true)
        return end
        if command == "olustur" then 
			local x, y, z = getElementPosition(player)
			local id = SmallestID()
            if dbExec(mysql:getConnection(), "INSERT INTO vOtopark SET id = '".. id .."', x = '".. x .."', y = '".. y .."', z = '".. z .."'") then 
                otoparkKayit(id, x, y, z)
				outputChatBox("[!]#E0E0E0 Başarıyla otopark bölgesi oluşturdun. ID: "..id, player, 109, 160, 101, true)
            end
        elseif command == "sil" then
            if type(tonumber(ID)) ~= 'number' then 
				outputChatBox('[!]#E0E0E0 /'..cmd..' sil [ID] ', player, 109, 160, 101, true)
			return end 
			if dbExec(mysql:getConnection(), "DELETE FROM vOtopark WHERE id = ?", tonumber(ID)) then 
				
                destroyElement(getElementData(shape[tonumber(ID)], 'otopark.obje'))
                destroyElement(shape[tonumber(ID)])
			    shape[tonumber(ID)] = nil

				outputChatBox('[!]#E0E0E0 Başarıyla '..ID..' numaralı otopark bölgesi sildiniz.', player, 109, 160, 101, true)
			else 
				outputChatBox('[!]#E0E0E0 Otopark silenemedi.', player, 109, 160, 101, true)
			end 
        end
    end
end
)

otoparkKayit = function (id, x, y, z)
	shape[id] = createColSphere(x, y, z, 3)
	setElementData(shape[id], 'otopark.command', true)
	setElementData(shape[id], 'otopark.ID', tonumber(id))
	marker[id] = createMarker(x, y, z-1, "cylinder", 3, 109, 160, 101, 150)
	setElementData(shape[id], 'otopark.obje', marker[id])
end 

addEventHandler('onResourceStart', resourceRoot, function()
	dbQuery(function(qh)
	local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then 
			for key, row in ipairs(res) do 
				otoparkKayit(tonumber(row.id), row.x, row.y, row.z)
			end 
		end 
	end, mysql:getConnection(), 'SELECT * FROM vOtopark')
end)

oMarker = getResourceRootElement()
araclar = {}
addEventHandler("onMarkerHit", oMarker, function(player)
	if isElement(player) then
		if getElementType(player) == "vehicle" then
		    local vehicleController = getVehicleController(player)
            if getVehicleController(player) then
                otoparkYolla(vehicleController)
            end
	    else
            araclar = {}
	        for i, veh in ipairs(getElementsByType ( "vehicle" )) do
		        if getElementData(veh, "owner") == getElementData(player, "dbid") or getElementData(veh,"faction") == getElementData(player,"faction") then 
                    if getElementData(veh, "owner") ~= getElementData(player, "dbid") and getElementData(player, "faction") == -1 then
                    else
                        if getElementData(veh, 'otopark') == 1 then
                            model = getVehicleName(veh)
                            dbid = getElementData(veh, "dbid")
                            table.insert(araclar, {model=model, dbid=dbid, otoparkveh=veh})
                        end
                    end
                end
            end
		    triggerClientEvent(player, "otopark > acilis", player, player, araclar)
	    end
	end
end
)

addEventHandler("onMarkerLeave", oMarker, function(player)
	if isElement(player) then
	    triggerClientEvent(player, 'otopark > kapanis', player)
    end
end
)

otoparkYolla = function (player)
    veh = getPedOccupiedVehicle(player)
    id = getElementData(veh, "dbid")
    dimension = 3162
    if getElementData(veh, "owner") == getElementData(player, "dbid") or getElementData(veh, "faction") == getElementData(player, "faction") then
        if getElementData(veh, "owner") ~= getElementData(player, "dbid") then
            outputChatBox('[!]#E0E0E0 Araç size ait değil.', player, 109, 160, 101, true)
        else
            removePedFromVehicle(player)
            dbExec(mysql:getConnection(), "UPDATE vehicles SET dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "', otopark='" .. 1 .. "' WHERE id='" .. (getElementData(veh,"dbid")) .. "'")
            setElementDimension(veh, dimension)
            outputChatBox('[!]#E0E0E0 Başarıyla aracınızı otoparka gönderdiniz.', player, 109, 160, 101, true)
            setElementData(veh, "otopark", 1)
            setElementData(veh, "dimension", dimension)
        end
    end
end

addEvent("otopark > cikar", true)
addEventHandler("otopark > cikar", root, function(element, id)
    local vehicle = exports.pool:getElement("vehicle", id)
    id = getElementData(vehicle, "dbid")
	if vehicle then
		local r = getPedRotation(element)
		local x, y, z = getElementPosition(element)
		if	(getElementHealth(vehicle) == 0) then
			spawnVehicle(vehicle, x, y, z, 0, 0, r)
			setElementData(vehicle, "otopark", 0)
			fixVehicle(vehicle)
		else
			spawnVehicle(vehicle, x, y, z, 0, 0, r)
			fixVehicle(vehicle)
			dbExec(mysql:getConnection(), "UPDATE vehicles SET otopark = 0 WHERE id='" .. id .. "'")
			setElementPosition(vehicle, x, y, z)
			setVehicleRotation(vehicle, 0, 0, r)
			setElementDimension(vehicle, 0)
			setElementInterior(vehicle, 0)
			warpPedIntoVehicle(element, vehicle, 0)
			setElementData(vehicle, "otopark", 0)
			outputChatBox('[!]#E0E0E0 Aracınızı başarılı şekilde otoparktan aldınız.', player, 109, 160, 101, true)
		end	
	end
end
)

addEventHandler("onPlayerQuit", root, function()
	if isPedInVehicle(source) then
		veh = getPedOccupiedVehicle(source)
		id = getElementData(veh, "dbid")
		dimension = 3162
		if getElementData(veh, "owner") == getElementData(source, "dbid") or getElementData(veh, "faction") == getElementData(source, "faction") then
			if getElementData(veh, "owner") ~= getElementData(source, "dbid") then
				outputChatBox('[!]#E0E0E0 Araç size ait değil.', source, 109, 160, 101, true)
			else
				removePedFromVehicle(source)
				dbExec(mysql:getConnection(), "UPDATE vehicles SET dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "', otopark='" .. 1 .. "' WHERE id='" .. (getElementData(veh,"dbid")) .. "'")
				setElementDimension(veh, dimension)
				outputChatBox('[!]#E0E0E0 Başarıyla aracınızı otoparka gönderdiniz.', source, 109, 160, 101, true)
				setElementData(veh, "otopark", 1)
				setElementData(veh, "dimension", dimension)
			end
		end
	end
end
)

SmallestID = function ()
	local query = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vOtopark AS e1 LEFT JOIN vOtopark AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

print("© HydraDVV - Otopark")