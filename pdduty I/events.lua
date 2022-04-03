connection = exports.mysql
global = exports.global

addEvent('duty.clothes', true)
addEventHandler('duty.clothes', root, function(model)
    if source and tonumber(model) then
        source.model = model
        global:sendLocalMeAction(source, 'dolabından görev kıyafetini alır ve giyinir.')
    end
end)

addEvent('duty.weapons', true)
addEventHandler('duty.weapons', root, function(weapon)
    if source and tonumber(weapon) then
        local characterDatabaseID = source:getData('account:character:id')
        local weaponSerial = global:createWeaponSerial(2, characterDatabaseID)
        local gtaweaponcap = exports.weaponcap:getGTACap(weapon)
        global:giveItem(source, 115, weapon..':'..weaponSerial..':'..getWeaponNameFromID(weapon)..' (D)')
        for i=1,10 do 
            global:giveItem(source, 116, weapon..':'..gtaweaponcap..':Ammopack for '..getWeaponNameFromID(weapon)..' (D)') 
        end
        global:sendLocalMeAction(source, 'dolabından görev silahını alır ve kuşanır.')
    end
end)

addEvent('duty.equipments', true)
addEventHandler('duty.equipments', root, function(item)
    if source and tonumber(item) then
        global:giveItem(source, item, 1)
        global:sendLocalMeAction(source, 'dolabından görev ekipmanını alır ve kuşanır.')
    end
end)

addEvent('duty.off', true)
addEventHandler('duty.off', root, function()
    if source then
        dbQuery(
			function(qh, source)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
                    for index, row in ipairs(res) do
                        source.model = row.skin
                    end
				end
			end,
		{source}, connection:getConnection(), "SELECT * FROM `characters` WHERE `id`='"..source:getData('dbid').."'")
        for i = 115, 116 do
            while exports['item-system']:takeItem(source, i) do
            end
        end
        global:sendLocalMeAction(source, 'görev eşyalarını dolabına bırakır ve üzerini değişir.')
    end
end)