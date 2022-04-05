-- Misc
local function sortTable( a, b )
	if b[2] < a[2] then
		return true
	end

	if b[2] == a[2] and b[4] > a[4] then
		return true
	end

	return false
end

local function getPlayerScripterRank( player )
	if exports.integration:isPlayerLeadScripter( player ) then
		return "Scripter"
	elseif exports.integration:isPlayerScripter( player ) then
		return "Deneme Scripter"
	elseif exports.integration:isPlayerTester( player ) then
		return "Deneme"
	else
		return ""
	end
end

local function getPlayerSupportRank( player )
	if exports.integration:isPlayerSupportManager( player ) then
		return "Rehber Yoneticisi"
	elseif exports.integration:isPlayerSupporter( player ) then
		return "Rehber"
	else
		return ""
	end
end

function showStaff( thePlayer, commandName )
	local logged = getElementData(thePlayer, "loggedin")
	local info = {}
	local isOverlayDisabled = getElementData(thePlayer, "hud:isOverlayDisabled")

	-- ADMINS --

	if(logged==1) then
		local players = exports.global:getAdmins()
		local counter = 0

		admins = {}

		if isOverlayDisabled then
			--outputChatBox("ADMINLER:", thePlayer, 255, 194, 14)
		else
			table.insert(info, {"Üst Yönetim Kurulu", 255, 194, 14, 255, 1, "title"})
			table.insert(info, {""})
		end

		for k, arrayPlayer in ipairs(players) do
			local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
			local logged = getElementData(arrayPlayer, "loggedin")

			if logged == 1 then
				if tonumber(getElementData( arrayPlayer, "admin_level" )) > 4 or getElementData(arrayPlayer, "uyk") == 1 and tonumber(getElementData( arrayPlayer, "admin_level" )) < 7 then
					if exports.integration:isPlayerAdmin(arrayPlayer) and ( hiddenAdmin == 0 or ( exports.integration:isPlayerAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer) ) ) and not exports.integration:isPlayerIA( arrayPlayer ) then
						admins[ #admins + 1 ] = { arrayPlayer, getElementData( arrayPlayer, "admin_level" ), getElementData( arrayPlayer, "duty_admin" ), exports.global:getPlayerName( arrayPlayer ) }
					end
				end
			end
		end

		table.sort( admins, sortTable )

		for k, v in ipairs(admins) do
			arrayPlayer = v[1]
			local adminTitle = exports.global:getPlayerAdminTitle(arrayPlayer)
			local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
			if hiddenAdmin == 0 or exports.integration:isPlayerTrialAdmin(thePlayer) then
			v[4] = v[4].." ("..tostring(getElementData(arrayPlayer, "account:username"))..")"

				if(v[3]==1)then
					table.insert(info, {"  " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").."", 0, 255, 0, 200, 1, "default"})
				else
					table.insert(info, {"  " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").."", 255, 255, 255, 200, 1, "default"})
				end
			end
		end

		if #admins == 0 then
			table.insert(info, {"-    Aktif üst yönetim yok.", 255, 255, 255, 200, 1, "default"})
		end
		--outputChatBox("Use /gms to see a list of gamemasters.", thePlayer)
	end

	if not isOverlayDisabled then
		table.insert(info, {" ", 100, 100, 100, 255, 1, "default"})
	end

	if(logged==1) then
		local players = exports.global:getAdmins()
		local counter = 0

		admins = {}

		if isOverlayDisabled then
			--outputChatBox("ADMINLER:", thePlayer, 255, 194, 14)
		else
			table.insert(info, {"Yetkili Takımı", 255, 194, 14, 255, 1, "title"})
			table.insert(info, {""})
		end

		for k, arrayPlayer in ipairs(players) do
			local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
			local logged = getElementData(arrayPlayer, "loggedin")

			if logged == 1 then
				if tonumber(getElementData( arrayPlayer, "admin_level" )) < 5 and tonumber(getElementData( arrayPlayer, "admin_level" )) < 7 then
					if exports.integration:isPlayerAdmin(arrayPlayer) and ( hiddenAdmin == 0 or ( exports.integration:isPlayerAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer) ) ) and not exports.integration:isPlayerIA( arrayPlayer ) then
						admins[ #admins + 1 ] = { arrayPlayer, getElementData( arrayPlayer, "admin_level" ), getElementData( arrayPlayer, "duty_admin" ), exports.global:getPlayerName( arrayPlayer ) }
					end
				end
			end
		end

		table.sort( admins, sortTable )

		for k, v in ipairs(admins) do
			arrayPlayer = v[1]
			local adminTitle = exports.global:getPlayerAdminTitle(arrayPlayer)
			local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
			if hiddenAdmin == 0 or exports.integration:isPlayerAdmin(thePlayer) then
				v[4] = v[4] .. " (" .. tostring(getElementData(arrayPlayer, "account:username")) .. ")"

				if(v[3]==1)then
					table.insert(info, {"  " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").."", 0, 255, 0, 200, 1, "default"})
				else
					table.insert(info, {"  " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").."", 255, 255, 255, 200, 1, "default"})
				end
			end
		end

		if #admins == 0 then
			if isOverlayDisabled then
				outputChatBox("-    Aktif yetkili yok.", thePlayer)
			else
				table.insert(info, {"-    Aktif yetkili yok.", 255, 255, 255, 200, 1, "default"})
			end
		end
		--outputChatBox("Use /gms to see a list of gamemasters.", thePlayer)
	end

	if not isOverlayDisabled then
		table.insert(info, {" ", 100, 100, 100, 255, 1, "default"})
	end

	--GMS--
	if(logged==1) then
		local players = exports.global:getGameMasters()
		local counter = 0

		admins = {}
		if isOverlayDisabled then
			outputChatBox("Rehber takımı", thePlayer, 255, 194, 14)
		else
			table.insert(info, {"Rehber takımı", 255, 194, 14, 255, 1, "title"})
			table.insert(info, {""})
		end
		for k, arrayPlayer in ipairs(players) do
			local logged = getElementData(arrayPlayer, "loggedin")
			if logged == 1 then
				if exports.integration:isPlayerSupporter(arrayPlayer) then
					admins[ #admins + 1 ] = { arrayPlayer, getElementData( arrayPlayer, "account:gmlevel" ), getElementData( arrayPlayer, "duty_supporter" ), exports.global:getPlayerName( arrayPlayer ) }
				end
			end
		end

		for k, v in ipairs(admins) do
			arrayPlayer = v[1]
			local adminTitle = getPlayerSupportRank(arrayPlayer)

			v[4] = v[4] .. " (" .. tostring(getElementData(arrayPlayer, "account:username")) .. ")"

			if (v[3] == 1)then
				table.insert(info, {"  " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").."", 0, 255, 0, 200, 1, "default"})
			else
				table.insert(info, {"  " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").."", 142, 142, 148, 200, 1, "default"})
			end
		end
		table.insert(info, {""})

		if #admins == 0 then
			if isOverlayDisabled then
			--	outputChatBox("-    Aktif yetkili bulunamadi.", thePlayer)
			else
				table.insert(info, {"-    Aktif rehber yok.", 255, 255, 255, 200, 1, "default"})
				table.insert(info, {"", 255, 255, 255, 200, 1, "default"})
				table.insert(info, {"", 255, 255, 255, 200, 1, "default"})
				table.insert(info, {"", 255, 255, 255, 200, 1, "default"})
			end
		end
	end

	if logged == 1 then
		if not isOverlayDisabled then
			exports.stats:sendTopRightNotification(thePlayer, info, 350)
		end
	end
end
addCommandHandler("admin", showStaff, false, false)
addCommandHandler("admins", showStaff, false, false)
