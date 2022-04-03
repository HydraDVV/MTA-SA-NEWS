local mysql = exports[settings.mysql]

function giveM4(thePlayer)
	local weaponID = 31
	
	givePlayerWeapon(thePlayer, weaponID)
end
addEvent("customduty_s:givem4",true)
addEventHandler("customduty_s:givem4",root, giveM4)

function giveDeagle(thePlayer)
	local weaponID = 24

	givePlayerWeapon(thePlayer, weaponID)
end
addEvent("customduty_s:givedeagle",true)
addEventHandler("customduty_s:givedeagle",root, giveDeagle)

function giveShotgun(thePlayer)
	local weaponID = 25	

	givePlayerWeapon(thePlayer, weaponID)
end
addEvent("customduty_s:giveshotgun",true)
addEventHandler("customduty_s:giveshotgun",root, giveShotgun)

function giveCShotgun(thePlayer)
	local weaponID = 27	

	givePlayerWeapon(thePlayer, weaponID)
end
addEvent("customduty_s:givecshotgun",true)
addEventHandler("customduty_s:givecshotgun",root, giveCShotgun)

function giveSniper(thePlayer)
	local weaponID = 34
	
	givePlayerWeapon(thePlayer, weaponID)
end
addEvent("customduty_s:givesniper",true)
addEventHandler("customduty_s:givesniper",root, giveSniper)

function giveMP5(thePlayer)
	local weaponID = 29
	
	givePlayerWeapon(thePlayer, weaponID)
end
addEvent("customduty_s:givemp5",true)
addEventHandler("customduty_s:givemp5",root, giveMP5)

function givePlayerWeapon(thePlayer, weaponID)
	if getElementData(thePlayer, "faction") == 1 then
		local dutylevel = getElementData(thePlayer, "custom_duty") or 0
		if dutylevel ~= 0 then
			local valid = checkValid(thePlayer, dutylevel, weaponID)
			if valid then
				local characterid = tonumber(getElementData(thePlayer, "account:character:id"))
				local weaponSerial = exports[settings.global]:createWeaponSerial(1, characterid)

				if exports[settings.item]:giveItem(thePlayer, 115, weaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID (weaponID) .. " (D)") then
					outputChatBox("[!] #f9f9f9Başarıyla "..getWeaponNameFromID(weaponID).." adlı görev silahını kuşandınız.", thePlayer, 0, 255, 0, true)
				end
			else
				outputChatBox("[!] #f9f9f9Bu silahı kuşanmak için gerekli duty seviyesine sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end

function dutyVer(thePlayer, commandName, targetPlayer, dutyPerk)
	if (getElementData(thePlayer, "faction") == 1 and getElementData(thePlayer, "factionleader") == 1) or exports.client_integration:isPlayerDeveloper(thePlayer) then
		if (not tonumber(dutyPerk)) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Karakter Adı & ID] [1-5]", thePlayer, 255, 194, 14)
		else
			dutyPerk = tonumber(dutyPerk)
			local targetPlayer, targetPlayerName = exports[settings.global]:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "faction") == 1 then
					if dutyPerk >= 1 and dutyPerk <= 5 then
						local dbid = getElementData(targetPlayer, "dbid")
						outputChatBox("[!] #f9f9f9Başarıyla "..getPlayerName(targetPlayer):gsub("_", " ").." isimli oyuncunun duty seviyesi "..tonumber(dutyPerk).." olarak düzenlendi.", thePlayer, 0, 255, 0, true)
						setElementData(targetPlayer, "custom_duty", tonumber(dutyPerk))
						dbExec(mysql:getConnection(), "UPDATE characters SET custom_duty = " ..tonumber(dutyPerk).. " WHERE id = '" .. (dbid) .. "'")
					else 
						outputChatBox("SYNTAX: /" .. commandName .. " [Karakter Adı & ID] [1-5]", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("[!] #f9f9f9Hedef oyuncu polis biriminde bulunmuyor.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("dutyver", dutyVer)

function checkValid(thePlayer, dutylevel, value)
	local weapons = shared_dutyPerks[dutylevel].weapons
	for i, v in ipairs(weapons) do 
		if v == value then
			return true
		else
			return false
		end
	end
end

function armor25(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		setPedArmor(thePlayer, 25)
		outputChatBox("[!] #f9f9f9Başarıyla %25 Zırh kuşandınız.", thePlayer, 0, 0, 255, true)
	end
end
addEvent("customduty_s:armor25",true)
addEventHandler("customduty_s:armor25",root, armor25)

function armor50(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		setPedArmor(thePlayer, 50)
		outputChatBox("[!] #f9f9f9Başarıyla %50 Zırh kuşandınız.", thePlayer, 0, 0, 255, true)
	end
end
addEvent("customduty_s:armor50",true)
addEventHandler("customduty_s:armor50",root, armor50)

function armor100(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		setPedArmor(thePlayer, 100)
		outputChatBox("[!] #f9f9f9Başarıyla %100 Zırh kuşandınızs.", thePlayer, 0, 0, 255, true)
	end
end
addEvent("customduty_s:armor100",true)
addEventHandler("customduty_s:armor100",root, armor100)

------------------------------------------------------------------------------------------------------

function giveAmmo1(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		local weaponID = 24
		local ammo = 7
		exports[settings.item]:giveItem(thePlayer, 116, weaponID..":"..ammo..":Ammo for "..getWeaponNameFromID(weaponID))
		outputChatBox("[!] #f9f9f9Başarıyla [x"..ammo.."] "..getWeaponNameFromID(weaponID).." mermisi kuşandınız.", thePlayer, 0, 0, 255, true)
	end
end
addEvent("customduty_s:givedeagle_ammo",true)
addEventHandler("customduty_s:givedeagle_ammo",root, giveAmmo1)

function giveAmmo2(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		local weaponID = 29
		local ammo = 25
		exports[settings.item]:giveItem(thePlayer, 116, weaponID..":"..ammo..":Ammo for "..getWeaponNameFromID(weaponID))
		outputChatBox("[!] #f9f9f9Başarıyla [x"..ammo.."] "..getWeaponNameFromID(weaponID).." mermisi kuşandınız.", thePlayer, 0, 0, 255, true)
	end
end
addEvent("customduty_s:givemp5_ammo",true)
addEventHandler("customduty_s:givemp5_ammo",root, giveAmmo2)

function giveAmmo3(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		local weaponID = 31
		local ammo = 30
		exports[settings.item]:giveItem(thePlayer, 116, weaponID..":"..ammo..":Ammo for "..getWeaponNameFromID(weaponID))
		outputChatBox("[!] #f9f9f9Başarıyla [x"..ammo.."] "..getWeaponNameFromID(weaponID).." mermisi kuşandınız.", thePlayer, 0, 0, 255, true)
	end
end
addEvent("customduty_s:givem4_ammo",true)
addEventHandler("customduty_s:givem4_ammo",root, giveAmmo3)

function giveAmmo4(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		local weaponID = 25
		local ammo = 10
		exports[settings.item]:giveItem(thePlayer, 116, weaponID..":"..ammo..":Ammo for "..getWeaponNameFromID(weaponID))
		outputChatBox("[!] #f9f9f9Başarıyla [x"..ammo.."] "..getWeaponNameFromID(weaponID).." mermisi kuşandınız.", thePlayer, 0, 0, 255, true)
	end
end
addEvent("customduty_s:giveshotgun_ammo",true)
addEventHandler("customduty_s:giveshotgun_ammo",root, giveAmmo4)

function giveAmmo5(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		local weaponID = 27
		local ammo = 10
		exports[settings.item]:giveItem(thePlayer, 116, weaponID..":"..ammo..":Ammo for "..getWeaponNameFromID(weaponID))
		outputChatBox("[!] #f9f9f9Başarıyla [x"..ammo.."] "..getWeaponNameFromID(weaponID).." mermisi kuşandınız.", thePlayer, 0, 0, 255, true)
	end
end
addEvent("customduty_s:givecshotgun_ammo",true)
addEventHandler("customduty_s:givecshotgun_ammo",root, giveAmmo5)

function giveAmmo6(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		local weaponID = 34
		local ammo = 5
		exports[settings.item]:giveItem(thePlayer, 116, weaponID..":"..ammo..":Ammo for "..getWeaponNameFromID(weaponID))
		outputChatBox("[!] #f9f9f9Başarıyla [x"..ammo.."] "..getWeaponNameFromID(weaponID).." mermisi kuşandınız.", thePlayer, 0, 0, 255, true)
	end
end
addEvent("customduty_s:givesniper_ammo",true)
addEventHandler("customduty_s:givesniper_ammo",root, giveAmmo6)

------------------------------------------------------------------------------------------------------

function s_skin1(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		local skinID = settings.skins[1]
		setElementModel(thePlayer, skinID)
	end
end
addEvent("customduty_s:skin1",true)
addEventHandler("customduty_s:skin1",root, s_skin1)

function s_skin2(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		local skinID = settings.skins[2]
		setElementModel(thePlayer, skinID)
	end
end
addEvent("customduty_s:skin2",true)
addEventHandler("customduty_s:skin2",root, s_skin2)

function s_skin3(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		local skinID = settings.skins[3]
		setElementModel(thePlayer, skinID)
	end
end
addEvent("customduty_s:skin3",true)
addEventHandler("customduty_s:skin3",root, s_skin3)

function s_skin4(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		local skinID = settings.skins[4]
		setElementModel(thePlayer, skinID)
	end
end
addEvent("customduty_s:skin4",true)
addEventHandler("customduty_s:skin4",root, s_skin4)

function s_skin5(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		local skinID = settings.skins[5]
		setElementModel(thePlayer, skinID)
	end
end
addEvent("customduty_s:skin5",true)
addEventHandler("customduty_s:skin5",root, s_skin5)

------------------------------------------------------------------------------------------------------

function giveradio(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		exports[settings.item]:giveItem(thePlayer, 6, 1)
		outputChatBox("[!] #f9f9f9Başarıyla 'Telsiz' isimli görev eşyasını kuşandınız.", thePlayer, 0, 255, 0, true)
	end
end
addEvent("customduty_s:giveradio",true)
addEventHandler("customduty_s:giveradio",root, giveradio)

function givecuff(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		exports[settings.item]:giveItem(thePlayer, 45, 1)
		outputChatBox("[!] #f9f9f9Başarıyla 'Kelepçe' isimli görev eşyasını kuşandınız.", thePlayer, 0, 255, 0, true)
	end
end
addEvent("customduty_s:givecuff",true)
addEventHandler("customduty_s:givecuff",root, givecuff)

function givebelt(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		exports[settings.item]:giveItem(thePlayer, 126, 1)
		outputChatBox("[!] #f9f9f9Başarıyla 'Görev Kemeri' isimli görev eşyasını kuşandınız.", thePlayer, 0, 255, 0, true)
	end
end
addEvent("customduty_s:givebelt",true)
addEventHandler("customduty_s:givebelt",root, givebelt)

function givejop(thePlayer)
	if (getElementData(thePlayer, "faction") or 0) == 1 then
		local weaponID = 3
		local characterid = tonumber(getElementData(thePlayer, "account:character:id"))
		local weaponSerial = exports[settings.global]:createWeaponSerial(1, characterid)

		if exports[settings.item]:giveItem(thePlayer, 115, weaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID (weaponID) .. " (D)") then
			outputChatBox("[!] #f9f9f9Başarıyla "..getWeaponNameFromID(weaponID).." adlı görev eşyasını kuşandınız.", thePlayer, 0, 255, 0, true)
		end
	end
end
addEvent("customduty_s:givejop",true)
addEventHandler("customduty_s:givejop",root, givejop)