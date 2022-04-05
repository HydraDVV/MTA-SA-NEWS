exports = exports
tonumber = tonumber
ipairs = ipairs
addEvent = addEvent
addEventHandler = addEventHandler
addCommandHandler = addCommandHandler
connection = exports.mysql
restrictedWeapons = {}
for i=0, 15 do
	restrictedWeapons[i] = true
end

SmallestID = function()
	local query = dbQuery(connection:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

withdrawBalance = function(player, price)
    if player and tonumber(price) then
        if player:getData('bakiye') < price then
            player:outputChat('[!]#D0D0D0 Bu özelliği satın alabilmek için gerekli bakiye: '..price..'$',195,184,116,true)
            return false
        else
            player:setData('bakiye', player:getData('bakiye') - price)
            local balance = player:getData('bakiye') or 0
            dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..player:getData('account:id').."'")
            return true
        end
    end
end

addCommandHandler('bakiyever', function(thePlayer, commandName, targetPlayer, quantity)
    if exports.integration:isPlayerDeveloper(thePlayer) then
        if targetPlayer and tonumber(quantity) then
            local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                targetPlayer:setData('bakiye', targetPlayer:getData('bakiye') + quantity)
                local balance = targetPlayer:getData('bakiye') or 0
                dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..targetPlayer:getData('account:id').."'")
                thePlayer:outputChat('[!]#D0D0D0 '..targetPlayer.name..' isimli oyuncuya '..quantity..'$ bakiye verdiniz!',195,184,116,true)
                targetPlayer:outputChat('[!]#D0D0D0 '..thePlayer.name..' isimli yetkili size '..quantity..'$ bakiye verdi!',195,184,116,true)
            end
        else
            thePlayer:outputChat('[!]#D0D0D0 /'..commandName..' [ID] [Bakiye]',195,184,116,true)
        end
    end
end)

addCommandHandler('bakiyeal', function(thePlayer, commandName, targetPlayer, quantity)
    if exports.integration:isPlayerDeveloper(thePlayer) then
        if targetPlayer and tonumber(quantity) then
            local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                targetPlayer:setData('bakiye', targetPlayer:getData('bakiye') - quantity)
                local balance = targetPlayer:getData('bakiye') or 0
                dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..targetPlayer:getData('account:id').."'")
                thePlayer:outputChat('[!]#D0D0D0 '..targetPlayer.name..' isimli oyuncudan '..quantity..'$ bakiye kestiniz!',195,184,116,true)
                targetPlayer:outputChat('[!]#D0D0D0 '..thePlayer.name..' isimli yetkili sizden '..quantity..'$ bakiye kesti!',195,184,116,true)
            end
        else
            thePlayer:outputChat('[!]#D0D0D0 /'..commandName..' [ID] [Bakiye]',195,184,116,true)
        end
    end
end)

addEvent('privateshop.guncurrent', true)
addEventHandler('privateshop.guncurrent', root, function(price, itemData)
    if withdrawBalance(source, price) then
        for index, value in ipairs(exports['items']:getItems(source)) do
            if value[3] == itemData then
                if value[1] == 115 or restrictedWeapons[tonumber(exports.global:explode(":", value[2])[1])] then
                    local oldCurrent = (#tostring(exports.global:explode(":", value[2])[5])>0 and exports.global:explode(":", value[2])[5]) or 3
                    oldCurrent = not restrictedWeapons[tonumber(exports.global:explode(":", value[2])[1])] and oldCurrent or "-"
                    newCurrent = oldCurrent + 1
                    local wepName = tostring(exports.global:explode(":", value[2])[3])
                    local checkString = string.sub(exports.global:explode(":", value[2])[3], -4) == " (D)"
                    if checkString then
                        source:setData('bakiye', source:getData('bakiye') + price)
                        local balance = source:getData('bakiye') or 0
                        dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                        source:outputChat('[!]#D0D0D0 Bu özellik duty silahlarında kullanılamaz!',195,184,116,true)
                    else
                        exports.global:takeItem(source, 115, value[2])
                        exports.global:giveItem(source, 115, exports.global:explode(":",value[2])[1]..":"..exports.global:explode(":",value[2])[2]..":"..exports.global:explode(":",value[2])[3].."::"..newCurrent)
                    end
                end
            end
        end
    end
end)

addEvent('privateshop.gun', true)
addEventHandler('privateshop.gun', root, function(price, weaponID)
    if withdrawBalance(source, price) then
        local serial = exports.global:createWeaponSerial(1, source:getData('dbid'), source:getData('dbid'))
        if exports.global:giveItem(source, 115, weaponID..":"..serial..":"..getWeaponNameFromID(weaponID).."::") then
            source:outputChat('[!]#D0D0D0 Başarıyla silahı satın aldınız!',195,184,116,true)
        else
            source:setData('bakiye', source:getData('bakiye') + price)
            local balance = source:getData('bakiye') or 0
            dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
            source:outputChat('[!]#D0D0D0 Üzerinizde bu silahı taşıyabilecek yeriniz yok!',195,184,116,true)
        end
    end
end)

addEvent('privateshop.anim', true)
addEventHandler('privateshop.anim', root, function(price, anim)
    if withdrawBalance(source, price) then
        local playerAnims = source:getData('custom_animations')
        if (playerAnims[tostring(anim)]) then
            source:setData('bakiye', source:getData('bakiye') + price)
            local balance = source:getData('bakiye') or 0
            dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
            source:outputChat('[!]#D0D0D0 Zaten bu animasyona sahipsiniz!',195,184,116,true)
        else
            source:outputChat('[!]#D0D0D0 Başarıyla animasyonu satın aldınız /animpanel',195,184,116,true)
            playerAnims[tostring(anim)] = true
            source:setData('custom_animations', playerAnims)
            dbExec(connection:getConnection(), "UPDATE `accounts` SET custom_animations='"..toJSON(playerAnims).."' WHERE id="..source:getData('account:id').." LIMIT 1")
        end
    end
end)

addEvent('privateshop.veh', true)
addEventHandler('privateshop.veh', root, function(price, gtaModel, owlModel, r, g, b)
    if withdrawBalance(source, price) then
        local dbid = source:getData('dbid')
        local smallestID = SmallestID()
        local x, y, z = source.position.x, source.position.y, source.position.z
        local int, dim = source.interior, source.dimension
        local pr = getPedRotation(source)
        local rotZ = source.rotation.z
        local letter1 = string.char(math.random(65,90))
		local letter2 = string.char(math.random(65,90))
        local var1, var2 = exports['vehicle']:getRandomVariant(owlModel)
		local plate = tonumber(34).. ' ' .. letter1 .. letter2 .. ' ' .. math.random(1000, 9999)
        local color1 = toJSON( {r,g,b} )
		local color2 = toJSON( {0, 0, 0} )
		local color3 = toJSON( {0, 0, 0} )
		local color4 = toJSON( {0, 0, 0} )
        local tint = 0
		local factionVehicle = -1
        x = x + ( ( math.cos ( math.rad ( pr ) ) ) * 5 )
		y = y + ( ( math.sin ( math.rad ( pr ) ) ) * 5 )
        call(getResourceFromName("items" ), "deleteAll", 3, smallestID)
        dbExec(connection:getConnection(), "INSERT INTO vehicles SET id='"..(smallestID).."', model='" .. (gtaModel) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='0', roty='0', rotz='" .. (rotZ) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', faction='" .. (factionVehicle) .. "', owner='" .. (dbid) .. "', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (rotZ) .. "', locked='1', interior='0', currinterior='0', dimension='0', currdimension='0', tintedwindows='" .. (tint) .. "',variant1='"..var1.."',variant2='"..var2.."', creationDate=NOW(), createdBy='-1', `vehicle_shop_id`='"..owlModel.."' ")
        exports.global:giveItem(source, 3, smallestID)
        local veh = Vehicle(gtaModel, x,y,z)
        veh:setColor(r, g, b)
        veh.interior = int
        veh.dimension = dim
        veh:destroy()
        exports['vehicle']:reloadVehicle(smallestID)
        source:outputChat('[!]#D0D0D0 Aracı başayırla satın aldınız!',195,184,116,true)
        source:outputChat('[!]#D0D0D0 /park yapmayı unutmayın!',195,184,116,true)
    end
end)

addEvent('privateshop.vip', true)
addEventHandler('privateshop.vip', root, function(price, day, vip)
    if tonumber(day) and tonumber(vip) then
        if withdrawBalance(source, price) then
            local pVip = source:getData('vipver') or 0
            if pVip <= 0 or pVip == vip then
                exports["vip"]:addVIP(source, vip, day)
                source:outputChat('[!]#D0D0D0 Başarıyla '..day..' günlük vip '..vip..' satın aldınız!',195,184,116,true)
            else
                source:setData('bakiye', source:getData('bakiye') + price)
                local balance = source:getData('bakiye') or 0
                dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                source:outputChat('[!]#D0D0D0 Sadece VIP gününüzü arttırabilirsiniz.',195,184,116,true)
            end
        end
    else
        source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
    end
end)

addEvent('privateshop.charslot', true)
addEventHandler('privateshop.charslot', root, function(price, slot)
    if tonumber(slot) then
        if withdrawBalance(source, price) then
            source:outputChat('[!]#D0D0D0 Başaryıla '..slot..' adet karakter slotu satın aldınız.',195,184,116,true)
            source:setData('account:charLimit', source:getData('account:charLimit') + slot)
            dbExec(connection:getConnection(), "UPDATE accounts SET characterlimit = characterlimit+1 WHERE username='"..source:getData('account:username').."'")
        end
    else
        source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
    end
end)

addEvent('privateshop.vehslot', true)
addEventHandler('privateshop.vehslot', root, function(price, slot)
    if tonumber(slot) then
        if withdrawBalance(source, price) then
            source:outputChat('[!]#D0D0D0 Başaryıla '..slot..' adet araç slotu satın aldınız.',195,184,116,true)
            source:setData('maxvehicles', source:getData('maxvehicles') + slot)
            dbExec(connection:getConnection(), "UPDATE characters SET maxvehicles = maxvehicles+1 WHERE id = "..source:getData('dbid'))
        end
    else
        source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
    end
end)

addEvent('privateshop.delhistory', true)
addEventHandler('privateshop.delhistory', root, function(price, slot)
    if tonumber(slot) then
        if withdrawBalance(source, price) then
            dbQuery(
                function(qh, source)
                    local res, rows, err = dbPoll(qh, 0)
                    if rows > 0 then
                        source:outputChat('[!]#D0D0D0 Başaryıla '..slot..' adet history sildirdiniz.',195,184,116,true)
                        for index, value in ipairs(res) do
                            dbExec(connection:getConnection(), "DELETE FROM adminhistory WHERE id='"..value.id.."'")
                        end
                    else
                        source:setData('bakiye', source:getData('bakiye') + price)
                        local balance = source:getData('bakiye') or 0
                        dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                        source:outputChat('[!]#D0D0D0 Silinecek bir history bulunamadı.',195,184,116,true)
                    end
                end,
            {source}, connection:getConnection(), "SELECT id, action FROM adminhistory WHERE user='"..source:getData('account:id').."' ORDER BY date DESC LIMIT "..slot)
        end
    else
        source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
    end
end)

addEvent('privateshop.setusername', true)
addEventHandler('privateshop.setusername', root, function(price, newName)
    if newName then
        if withdrawBalance(source, price) then
            dbQuery(
                function(qh, source)
                    local res, rows, err = dbPoll(qh, 0)
                    if rows > 0 then
                        source:setData('bakiye', source:getData('bakiye') + price)
                        local balance = source:getData('bakiye') or 0
                        dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                        source:outputChat('[!]#D0D0D0 Bu isim zaten kullanılıyor.',195,184,116,true)
                    else
                        dbExec(connection:getConnection(), "UPDATE accounts SET username='"..(newName).."' WHERE id = "..source:getData('dbid'))
                        source:setData('account:username', newName)
                        source:setData('OOCHapisKontrol', 0)
                        source:outputChat('[!]#D0D0D0 Kullanıcı adınızı '..newName..' olarak değiştirdiniz!',195,184,116,true)
                    end
                end,
            {source}, connection:getConnection(), "SELECT * FROM `accounts` WHERE `username`='".. newName .."'")
            
        end
    else
        source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
    end
end)

addEvent('privateshop.vehdoor', true)
addEventHandler('privateshop.vehdoor', root, function(price, vehID)
    if tonumber(vehID) then
        if withdrawBalance(source, price) then
            local vehicle = exports.pool:getElement("vehicle", vehID)
            if vehicle and isElement(vehicle) then
                if vehicle:getData('owner') == source:getData('dbid') then
                    dbQuery(
                        function(qh)
                            local res, rows, err = dbPoll(qh, 0)
                            if rows > 0 then
                                dbExec(connection:getConnection(), "UPDATE vehicles_custom SET doortype = '2' WHERE id='" .. (vehicle:getData('dbid')) .. "'")
                                setTimer(function() exports["vehicle_manager"]:loadCustomVehProperties(tonumber(vehID), vehicle) end, 5000, 1)
                            else
                                dbQuery(
                                    function(qh)
                                        local res, rows, err = dbPoll(qh, 0)
                                        if rows > 0 then
                                            row = res[1]
                                            dbExec(connection:getConnection(), "INSERT INTO vehicles_custom SET id='"..vehicle:getData('dbid').."', doortype='2', brand='"..row.vehbrand.."', model='"..row.vehmodel.."', year='"..row.vehyear.."' ")
                                            setTimer(function() exports["vehicle_manager"]:loadCustomVehProperties(tonumber(vehID), vehicle) end, 5000, 1)
                                        end
                                    end,
                                connection:getConnection(), "SELECT * FROM vehicles_shop WHERE id='"..vehicle:getData("vehicle_shop_id").."'")
                            end
                        end,
                    connection:getConnection(), "SELECT id FROM vehicles_custom WHERE id='"..vehicle:getData('dbid').."'")
                    source:outputChat('[!]#D0D0D0 Aracınıza başarıyla kelebek kapı eklediniz, 10 sn sonra çalışmaya başlayacaktır.',195,184,116,true)
                else
                    source:setData('bakiye', source:getData('bakiye') + price)
                    local balance = source:getData('bakiye') or 0
                    dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                    source:outputChat('[!]#D0D0D0 Bu aracın sahibi siz değilsiniz!',195,184,116,true)
                end
            else
                source:setData('bakiye', source:getData('bakiye') + price)
                local balance = source:getData('bakiye') or 0
                dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
            end
        end
    else
        source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
    end
end)

addEvent('privateshop.vehtint', true)
addEventHandler('privateshop.vehtint', root, function(price, vehID)
    if tonumber(vehID) then
        if withdrawBalance(source, price) then
            local vehicle = exports.pool:getElement("vehicle", vehID)
            if vehicle and isElement(vehicle) then
                if vehicle:getData('owner') == source:getData('dbid') then
                    dbExec(connection:getConnection(), "UPDATE vehicles SET tintedwindows = '1' WHERE id='"..vehicle:getData('dbid').."'")
                    vehicle:setData('tinted', true, true)
                    triggerClientEvent("tintWindows", vehicle)
                    source:outputChat('[!]#D0D0D0 Aracınıza başarıyla cam filmi eklediniz.',195,184,116,true)
                else
                    source:setData('bakiye', source:getData('bakiye') + price)
                    local balance = source:getData('bakiye') or 0
                    dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                    source:outputChat('[!]#D0D0D0 Bu aracın sahibi siz değilsiniz!',195,184,116,true)
                end
            else
                source:setData('bakiye', source:getData('bakiye') + price)
                local balance = source:getData('bakiye') or 0
                dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
            end
        end
    else
        source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
    end
end)

addEvent('privateshop.vehplate', true)
addEventHandler('privateshop.vehplate', root, function(price, vehID, plateText)
    if tonumber(vehID) and plateText then
        if plateText == '' then
            source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
        else
            if withdrawBalance(source, price) then
                local vehicle = exports.pool:getElement("vehicle", vehID)
                if vehicle and isElement(vehicle) then
                    if vehicle:getData('owner') == source:getData('dbid') then
                        dbQuery(
                            function(qh, source)
                                local res, rows, err = dbPoll(qh, 0)
                                if rows > 0 then
                                    source:setData('bakiye', source:getData('bakiye') + price)
                                    local balance = source:getData('bakiye') or 0
                                    dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                                    source:outputChat('[!]#D0D0D0 Seçtiğiniz plaka kullanılıyor.',195,184,116,true)
                                else
                                    if exports.vehicle_plate:checkPlate(plateText) and getVehiclePlateText(vehicle) ~= plateText then
                                        dbExec(connection:getConnection(), "UPDATE vehicles SET plate='"..plateText.. "' WHERE id = '"..vehicle:getData('dbid').."'")
                                        vehicle:setData('plate', plateText)
                                        vehicle.plateText = plateText
                                        source:outputChat('[!]#D0D0D0 Başarıyla aracınızın plakasını '..plateText..' olarak değiştirdiniz.',195,184,116,true)
                                    else
                                        source:setData('bakiye', source:getData('bakiye') + price)
                                        local balance = source:getData('bakiye') or 0
                                        dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                                        source:outputChat('[!]#D0D0D0 Hatalı karakterler kullandınız!',195,184,116,true)
                                    end
                                end
                            end,
                        {source}, connection:getConnection(), "SELECT * FROM vehicles WHERE plate='"..plateText.."'")
                    else
                        source:setData('bakiye', source:getData('bakiye') + price)
                        local balance = source:getData('bakiye') or 0
                        dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                        source:outputChat('[!]#D0D0D0 Bu aracın sahibi siz değilsiniz!',195,184,116,true)
                    end
                else
                    source:setData('bakiye', source:getData('bakiye') + price)
                    local balance = source:getData('bakiye') or 0
                    dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                    source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
                end
            end
        end
    else
        source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
    end
end)

addEvent('privateshop.charnamegender', true)
addEventHandler('privateshop.charnamegender', root, function(price, name, gender)
    if name and gender then
        if string.len(name) < 3 then
            source:outputChat('[!]#D0D0D0 Yeni isminiz en az 3 karakter olmalı!',195,184,116,true)
        else
            if string.match(name,'_') then
                source:outputChat('[!]#D0D0D0 İsminizde "_" kullanmayınız.',195,184,116,true)
            else
                if gender == 'Erkek' or gender == 'Kadın' then
                    if withdrawBalance(source, price) then
                        local charName = string.gsub(tostring(name), " ", "_")
                        dbQuery(
                            function(qh, source)
                                local res, rows, err = dbPoll(qh, 0)
                                if rows > 0 then
                                    source:setData('bakiye', source:getData('bakiye') + price)
                                    local balance = source:getData('bakiye') or 0
                                    dbExec(connection:getConnection(), "UPDATE `accounts` SET bakiye='"..balance.."' WHERE id='"..source:getData('account:id').."'")
                                    source:outputChat('[!]#D0D0D0 Bu isim kullanılıyor!',195,184,116,true)
                                else
                                    local x, y, z = 398.4130859375, -1533.1025390625, 32.2734375
                                    if gender == 'Erkek' then
                                        walkingstyle = 128
                                        selectedGender = 0
                                    elseif gender == 'Kadın' then
                                        walkingstyle = 131
                                        selectedGender = 1
                                    end
                                    dbExec(connection:getConnection(), "UPDATE `characters` SET gender='"..selectedGender.."' WHERE id='"..source:getData('dbid').."'")
                                    dbExec(connection:getConnection(), "UPDATE `characters` SET walkingstyle='"..walkingstyle.."' WHERE id='"..source:getData('dbid').."'")
                                    dbExec(connection:getConnection(), "UPDATE `characters` SET ulke='0' WHERE id='"..source:getData('dbid').."'")
                                    dbExec(connection:getConnection(), "UPDATE `characters` SET charactername='"..charName.."' WHERE id='"..source:getData('dbid').."'")
                                    dbExec(connection:getConnection(), "UPDATE `characters` SET `x`='" .. x .. "', `y`='" .. y .. "', `z`='" .. z .. "' WHERE `id`='".. source:getData('dbid') .."'")
                                    triggerClientEvent('auth.f10', source)
                                    for index, value in ipairs(Element.getAllByType('player')) do
                                        if value:getData('loggedin') == 1 then
                                            value:outputChat('(( '..source.name..' sunucudan yasaklandı. Sure: Sınırsız Gerekce: İsim Değişikliği))',255, 0, 0)
                                        end
                                    end
                                end
                            end,
                        {source}, connection:getConnection(), "SELECT charactername FROM characters WHERE charactername = '"..charName.."'")
                    end
                else
                    source:outputChat('[!]#D0D0D0 Cinsiyetiniz sadece "Erkek/Kadın" olmalı.',195,184,116,true)
                end
            end
        end
    else
        source:outputChat('[!]#D0D0D0 Bir şeyler ters gitti!',195,184,116,true)
    end
end)