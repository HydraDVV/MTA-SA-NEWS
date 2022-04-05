local localPlayer = getLocalPlayer()
local show = false
local width, height = 400,67
local sx, sy = guiGetScreenSize()



local groupIcon = exports.fonts:getIcon("fa-icon-circle")
local icoo = exports.fonts:getIcon("fa-users")
local roboto = exports.fonts:getFont('FontAwesome',10)
local robotoB = exports.fonts:getFont('RobotoB',13)
local awesomeFont = exports.fonts:getFont("FontAwesome", 12)


local content = {}
local timerClose = nil
local cooldownTime = 20 --seconds
local toBeDrawnWidth = width
local justClicked = false
function drawOverlayTopRight(info, widthNew, posXOffsetNew, posYOffsetNew, cooldown)
	local pinned = getElementData(localPlayer, "hud:pin")
	if not pinned and timerClose and isTimer(timerClose) then
		killTimer(timerClose)
		timerClose = nil
	end
	if info then
		content = info
		content[1][1] = string.sub(content[1][1], 1, 1)..string.sub(content[1][1], 2)
	else
		return false
	end
	
	if posXOffsetNew then
		posXOffset = posXOffsetNew
	end
	if posYOffsetNew then
		posYOffset = posYOffsetNew
	end
	if cooldown then
		cooldownTime = cooldown
	end
	if content then
		show = true
	end
	
	toBeDrawnWidth = width
	
	playSoundFrontEnd ( 101 )
	if cooldownTime ~= 0 and not pinned then
		timerClose = setTimer(function()
			show = false
			setElementData(localPlayer, "hud:overlayTopRight", 0, false)
		end, cooldownTime*1000, 1)
	end
	
	for i=1, #info do
		outputConsole(info[i][1] or "")
	end
end
addEvent("hudOverlay:drawOverlayTopRight", true)
addEventHandler("hudOverlay:drawOverlayTopRight", localPlayer, drawOverlayTopRight)

addEventHandler("onClientRender",getRootElement(), function ()
	if show and not getElementData(localPlayer, "integration:previewPMShowing") and getElementData(localPlayer, 'loggedin') == 1 then 
		if ( getPedWeapon( localPlayer ) ~= 43 or not getPedControlState( localPlayer, "aim_weapon" ) ) then
			local posXOffset, posYOffset = 0, 165
			local hudDxHeight = getElementData(localPlayer, "hud:whereToDisplayY") or 0
			if hudDxHeight then
				posYOffset = posYOffset + hudDxHeight + 100
			end
		
			local width, height = 250,26
			local sx, sy = guiGetScreenSize()
			local w, h = 340, 200
			local clientDrawWidht = width
			local clientXOffset, clientYOffset = 43, 7
			local headerfont = exports.fonts:getFont('RobotoB', 9)
			local headerfont2 = exports.fonts:getFont('RobotoB', 7)
			local detailed = exports.fonts:getFont('FontAwesome', 9)
				local skinid = getElementData(localPlayer, "skin")
				local skinIMG = ":account/img/" .. ("%03d"):format( skinid or 2 ) .. ".png"	-- SKİN İD ÇEKİCEK KISIM
				local names = string.gsub(getPlayerName(localPlayer), "_", " ")
				local gun = getElementData(localPlayer, "day")
				local ay = getElementData(localPlayer, "month")
				local yas = getElementData(localPlayer, "age")
				local format = string.format("%02d/%02d", gun, ay)
				local dogum = exports.global:getPlayerDoB(localPlayer)
				local cinsiyet = getElementData(localPlayer, "gender")
				local skinIMG = ":account/img/" .. ("%03d"):format( skinid or 2 ) .. ".png"-- SKİN İD ÇEKİCEK KISIM
				local seriNo = getPlayerSerial(localPlayer)
				dxDrawRoundedRectangle(sx-clientDrawWidht-clientXOffset - 80, clientYOffset + 100, w, h, 10,tocolor(8,8,8,230))
				dxDrawText("TURKIYE CUMHURİYETİ", sx-clientDrawWidht-clientXOffset + 7, clientYOffset + 110, w, h, tocolor(200,200,200,255), 1, headerfont)
				dxDrawText("VATANDAŞ KİMLİK KARTI", sx-clientDrawWidht-clientXOffset + 15, clientYOffset + 125, w, h, tocolor(200,200,200,255), 1, headerfont)
				dxDrawText("Kimlik Numarası / Idenity Number;", sx-clientDrawWidht-clientXOffset + 40, clientYOffset + 160, w, h, tocolor(200,200,200,255), 1, detailed)
				dxDrawText(seriNo, sx-clientDrawWidht-clientXOffset + 40, clientYOffset + 175, w, h, tocolor(200,200,200,255), 1, headerfont2)
				dxDrawText("İsim Soyisim / Name or Surname;", sx-clientDrawWidht-clientXOffset + 40, clientYOffset + 190, w, h, tocolor(200,200,200,255), 1, detailed)
				dxDrawText(names, sx-clientDrawWidht-clientXOffset + 40, clientYOffset + 205, w, h, tocolor(200,200,200,255), 1, headerfont)
				dxDrawText("Doğum Tarihi / Date of Birth;", sx-clientDrawWidht-clientXOffset + 40, clientYOffset + 220, w, h, tocolor(200,200,200,255), 1, detailed)
				dxDrawText(dogum, sx-clientDrawWidht-clientXOffset + 40, clientYOffset + 235, w, h, tocolor(200,200,200,255), 1, headerfont)
				dxDrawText("Cinsiyet / Gender;", sx-clientDrawWidht-clientXOffset + 40, clientYOffset + 250, w, h, tocolor(200,200,200,255), 1, detailed)
				dxDrawText(cinsiyet.." (0 = Erkek / 1 = Kadın)", sx-clientDrawWidht-clientXOffset + 40, clientYOffset + 265, w, h, tocolor(200,200,200,255), 1, headerfont)
				dxDrawRoundedRectangle(sx-clientDrawWidht-clientXOffset - 65, clientYOffset + 160, 100, 100, 10,tocolor(255,255,255,50))
				dxDrawImage(sx-clientDrawWidht-clientXOffset - 70, clientYOffset + 160, 100, 100, skinIMG)
				dxDrawText("İmza / Signature;", sx-clientDrawWidht-clientXOffset - 70, clientYOffset + 260, w, h, tocolor(200,200,200,255), 1, detailed)
				--dxDrawImage(sx-clientDrawWidht-clientXOffset - 50, clientYOffset + 276, 50, 18, imza)

			
			function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
				dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
				dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
				dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
				dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
				dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
				dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
				dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
				dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
				dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
			end
			--roundedRectangle(sx-toBeDrawnWidth-15+posXOffset-2, 5+posYOffset-2, toBeDrawnWidth, 309, tocolor(24,24,24,210), tocolor(255,255,255,210)) -- shadoe
			dxDrawRoundedRectangle(sx-toBeDrawnWidth+posXOffset+25, posYOffset+51, toBeDrawnWidth-60, 16*(#content)+5, 5, tocolor(8, 8 ,8, 230)) -- main
			--dxDrawRoundedRectangle(sx-toBeDrawnWidth-15+posXOffset, 5+posYOffset, toBeDrawnWidth, 65, tocolor(24,24,24,255)) -- üst taraf
			--dxDrawRoundedRectangle(sx-toBeDrawnWidth-15+posXOffset, posYOffset*2.55*#content/10, toBeDrawnWidth, 35, tocolor(24,24,24,255)) -- alt taraf
			
			--dxDrawImage ( (sx-5+posXOffset)/1.05, (5+posYOffset)+60, 45, 45, "com/logo.png" ,0, 0, 0, tocolor(255,255,255), false )
			dxDrawRoundedRectangle((sx-5+posXOffset)/1.045, (5+posYOffset)+60, 40,40, 5, tocolor(29,53,145,255)) -- main
			dxDrawText(icoo,(sx-5+posXOffset)/1.040, (5+posYOffset)+70, 40,40, tocolor(255,255,255,255),1,awesomeFont )

			for i=1, #content do
				if content[i] then
					
					if i == 1 or content[i][7] == "title" then --Title

						dxDrawText( content[i][1] or "" , sx-toBeDrawnWidth+posXOffset+50, (16*i)+posYOffset+50, toBeDrawnWidth-5, 15, tocolor ( 225, 225, 225, 200), 1, robotoB )
					else
						dxDrawText( content[i][1] or "" , sx-toBeDrawnWidth+posXOffset+50, (16*i)+posYOffset+55, toBeDrawnWidth-5, 15, tocolor ( content[i][2] or 225, content[i][3] or 225, content[i][4] or 225, content[i][5] or 225 ), content[i][6] or 1, roboto )
					end
				end
			end
		end
	end
end, false)

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

function pinIt()
	setElementData(localPlayer, "hud:pin", true, false)
	if timerClose and isTimer(timerClose) then
		killTimer(timerClose)
		timerClose = nil
	end
end

function unpinIt()
	pinIt()
	setElementData(localPlayer, "hud:pin", false, false)
	timerClose = setTimer(function()
		show = false
		setElementData(localPlayer, "hud:overlayTopRight", 0, false)
	end, 3000, 1)
end

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 180)
		end
		if (not bgColor) then
			bgColor = borderColor
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);

	end
end

--[[

carshop

		local content = {}
		table.insert(content, { getCarShopNicename(getElementData(source, "carshop")) , false, false, false, false, false, false, "title"} )
		table.insert(content, {" " } )
		table.insert(content, {" " } )
		table.insert(content, {" - Marka: "..(getElementData(source, "brand") or getVehicleNameFromModel( getElementModel( source ) )) } )
		table.insert(content, {" - Model: "..(getElementData(source, "maximemodel") or getVehicleNameFromModel( getElementModel( source ) ))} )
		table.insert(content, {" - Yıl: "..(getElementData(source, "year") or "2015")} )		
		
		
		table.insert(content, {" - Kilometre: "..exports.global:formatMoney(getElementData(source, 'odometer') or 0) .. " KM"})
		table.insert(content, {" - Fiyat: ₺"..exports.global:formatMoney(carPrice)  } )
		table.insert(content, {" - Vergi: ₺"..exports.global:formatMoney(taxPrice) } )
		--table.insert(content, {"   (( MTA Model: "..getVehicleNameFromModel( getElementModel( source ) ).."))" } )
		table.insert(content, {" - Aracı satın almak için 'F' veya 'Enter' tuşuna basınız!" } )
		table.insert(content, {" " } )
		table.insert(content, {" " } )
		table.insert(content, {" " } )
		table.insert(content, {" " } )
		table.insert(content, {"                                    Araç Satın Alım İşlemleri"} )


]]