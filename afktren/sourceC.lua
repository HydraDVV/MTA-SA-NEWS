local sx, sy = guiGetScreenSize()
Roboto11 = dxCreateFont("assets/fonts/Roboto-Regular.ttf", 11)

vipData = "vipver" -- her paketten her sistemden her sisteme değişmektedir.
ped = createPed(295, 1914.044921875, 2701.1494140625, 10.8203125, 90)
ped.frozen = true 

addEventHandler("onClientClick", root, function(button, state, _, _, _, _, _, element)
	if element then 
		if element == ped then 
			if button == "right" and state == "down" then 
				if getDistanceBetweenPoints3D(ped.position, localPlayer.position) < 3 then 
					if not localPlayer.vehicle then 
						if not panelState then 
							if isElement(getElementData(localPlayer, "trainVeh")) then 
								outputChatBox("[!]#ffffff Zaten bir trene sahipsiniz.", 255, 0, 0, true)
							return end 
							triggerServerEvent("clientTrain>>openPanels", localPlayer, localPlayer)
						end 
					end
				end 
			end
		end 
	end 
end)

addEvent("clientTrain>>openPanelc", true)
addEventHandler("clientTrain>>openPanelc", root, function(player, stock)
	cache.vehStock = stock 
	if player == localPlayer then 
		panelState = true 
		addEventHandler("onClientRender", root, renderPanel)
	end 
end)

cache = {
	selectedVIP = nil,
	trainType = "Treni",
	trainModel = 538,
	notvipPrice = 3000, -- vip değilken vereceği para
	vipPrice = 6800, -- vip ise vereceği para
	vehStock = 1
}

addEvent("clientTrain>>Update", true)
addEventHandler("clientTrain>>Update", root, function(stock)
	cache.vehStock = stock
end)

lastClick = 0
renderPanel = function()
	if panelState then 
		w, h = 400, 142
		x, y, w, h = sx/2 - w/2, sy/2 - h/2, w, h 
		roundedRectangle(x, y, w, h, tocolor(0, 0, 0, 180))
		if cache.selectedVIP and (getElementData(localPlayer, vipData) or 0) > 0 then  
			dxDrawText("Merhaba;\nŞuanda kullanıma mevcut olan tren sayısı: "..cache.vehStock.." adet\nHer yük alanında $"..cache.vipPrice.." alırsınız.", x, y, w+x, h+y, tocolor(255, 255, 255), 1, Roboto11, "center", "top", false, false, false, false, false)
		else
			dxDrawText("Merhaba;\nŞuanda kullanıma mevcut olan tren sayısı: "..cache.vehStock.." adet\nHer yük alanında $"..cache.notvipPrice.." alırsınız.", x, y, w+x, h+y, tocolor(255, 255, 255), 1, Roboto11, "center", "top", false, false, false, false, false)
		end 
			roundedRectangle(x+10, y+86, 13, 13, tocolor(190, 190, 190, 180))
		dxDrawText("VİP Tren", (x+30), (y+85), 13+(x+10), 13+(y+85), tocolor(50, 250, 50), 1, Roboto11, "left", "center", false, false, false, false, false)
		if isInBox(x+10, y+86, 13, 13) then 
			if getKeyState("mouse1") and lastClick+800 <= getTickCount() then
				lastClick = getTickCount()
				if (getElementData(localPlayer, vipData) or 3) > 0 then 
					if cache.selectedVIP then 
						cache.selectedVIP = nil 
						cache.trainType = "Treni"
						cache.trainModel = 538
					else 
						cache.selectedVIP = true 
						cache.trainType = "Tramvayı"
						cache.trainModel = 449
					end 
				else 
					outputChatBox("[!]#ffffff Maalesef VİP olmadan bu seçeneği seçemezsiniz.", 0, 255, 0, true)
				end
			end 
		end
		if cache.selectedVIP then 
			dxDrawText("X", (x+10), (y+85), 13+(x+10), 13+(y+85), tocolor(50, 250, 50), 1, Roboto11, "center", "center", false, false, false, false, false)
			dxDrawText("(Aktif)", (x+90), (y+89), 13+(x+10), 13+(y+85), tocolor(50, 250, 50, 50), 0.7, Roboto11, "left", "center", false, false, false, false, false)
		else
			dxDrawText("X", (x+10), (y+85), 13+(x+10), 13+(y+85), tocolor(50, 50, 50), 1, Roboto11, "center", "center", false, false, false, false, false)
			dxDrawText("(İnaktif)", (x+90), (y+89), 13+(x+10), 13+(y+85), tocolor(255, 255, 255, 50), 0.7, Roboto11, "left", "center", false, false, false, false, false)
		end

		if isInBox(x+5, y+110, (w/2)-10, 25) then 
			roundedRectangle(x+5, y+110, (w/2)-10, 25, tocolor(0, 0, 0, 230))
			dxDrawText(cache.trainType.." Al", x+5, y+110, (x+5)+(w/2)-10, (y+110)+25, tocolor(255, 255, 255), 1, Roboto11, "center", "center", false, false, false, false, false)
			if getKeyState("mouse1") and lastClick+800 <= getTickCount() then
				lastClick = getTickCount()
				if cache.vehStock > 0 then 
					triggerServerEvent("clientTrain>>GiveJobVeh", localPlayer, localPlayer, cache.trainModel)
					panelState = nil 
					removeEventHandler("onClientRender", root, renderPanel)
					markerID = 0
					nextMarker()
				else 
					outputChatBox("[!]#ffffff Maalesef yeterli miktarda tren olmadığı için başlayamazsınız.", 255, 0, 0, true)
				end
			end
		else
			roundedRectangle(x+5, y+110, (w/2)-10, 25, tocolor(0, 0, 0, 180))
			dxDrawText(cache.trainType.." Al", x+5, y+110, (x+5)+(w/2)-10, (y+110)+25, tocolor(255, 255, 255), 1, Roboto11, "center", "center", false, false, false, false, false)
		end 
		if getDistanceBetweenPoints3D(ped.position, localPlayer.position) > 3 or localPlayer.vehicle then
			panelState = nil 
			removeEventHandler("onClientRender", root, renderPanel)
		end
		if isInBox(x+w/2+5, y+110, (w/2)-10, 25) then 
			roundedRectangle(x+w/2+5, y+110, (w/2)-10, 25, tocolor(0, 0, 0, 230))
			dxDrawText("Arayüzü Kapat", x+w/2+5, y+110, (x+w/2+5)+(w/2)-10, (y+110)+25, tocolor(255, 255, 255), 1, Roboto11, "center", "center", false, false, false, false, false)
			if getKeyState("mouse1") and lastClick+800 <= getTickCount() then
				lastClick = getTickCount()
				panelState = nil 
				removeEventHandler("onClientRender", root, renderPanel)
			end 
		else
			roundedRectangle(x+w/2+5, y+110, (w/2)-10, 25, tocolor(0, 0, 0, 180))
			dxDrawText("Arayüzü Kapat", x+w/2+5, y+110, (x+w/2+5)+(w/2)-10, (y+110)+25, tocolor(255, 255, 255), 1, Roboto11, "center", "center", false, false, false, false, false)
		end
	end
end

addEvent("clientTrain>>FinishJob", true)
addEventHandler("clientTrain>>FinishJob", root, function()
	if isElement(Marker) then 
		destroyElement(Marker)
	end 
	markerID = 0
	cache.selectedVIP = nil 
	cache.trainType = "Treni"
	cache.trainModel = 538
	if panelState then 
		panelState = nil 
		removeEventHandler("onClientRender", root, renderPanel)
	end 
end)

trainPos = {
	{1828.4775390625, 2690.30078125, 10.828102111816},
	{1480.626953125, 2632.3212890625, 10.8203125},
	{971.27734375, 2758.4716796875, 17.8203125},
	{741.9267578125, 1878.025390625, 5.8203125},
	{-85.2373046875, 1289.8525390625, 18.774003982544},
	{-1515.748046875, 574.0234375, 34.578125},
	{-1980.076171875, -557.3359375, 25.7109375},
	{-1270.5517578125, -1512.830078125, 25.7109375},
	{-558.6513671875, -1191.2626953125, 42.7109375},
	{20.5439453125, -1017.9267578125, 20.958650588989},
	{1846.8115234375, -1953.8056640625, 13.554664611816},
	{2284.9755859375, -1226.546875, 24},
	{2474.0419921875, -275.6416015625, 17.774045944214},
	{2765.330078125, 394.5546875, 8.2897529602051},
	{2864.759765625, 1435.763671875, 10.8203125},
	{2552.75, 2407.408203125, 9.6355419158936},
	{2100.40234375, 2694.1328125, 10.8203125},
}


nextMarker = function()
	markerID = markerID + 1
	if isElement(Marker) then 
		destroyElement(Marker)
	end 
	if markerID <= #trainPos then 
		Marker = createMarker (trainPos[markerID][1], trainPos[markerID][2], trainPos[markerID][3], "checkpoint", 1.5, 0, 255, 0, 170)
		Marker:setData("trainMarker", true)
	else 
		markerID = 1
		Marker = createMarker (trainPos[markerID][1], trainPos[markerID][2], trainPos[markerID][3], "checkpoint", 1.5, 0, 255, 0, 170)
		Marker:setData("trainMarker", true)
	end
end 

addEventHandler("onClientMarkerHit", root, function(hitPlayer)
	if hitPlayer == localPlayer then 
		if localPlayer.vehicle then 
			if localPlayer.vehicle.vehicleType == "Train" then 
				if getElementData(source, "trainMarker") then 
					if markerID <= #trainPos then 
						if cache.selectedVIP and (getElementData(localPlayer, vipData) or 0) > 0 then 
							triggerServerEvent("clientTrain>>GiveMoney", localPlayer, localPlayer, cache.vipPrice)
							outputChatBox("[!]#ffffff VİP treni ile tur attığınız için $"..cache.vipPrice.." aldınız.", 0, 255, 0, true)
						else 
							triggerServerEvent("clientTrain>>GiveMoney", localPlayer, localPlayer, cache.notvipPrice)
							outputChatBox("[!]#ffffff Bu turdan $"..cache.notvipPrice.." aldınız.", 0, 255, 0, true)
						end 
						nextMarker()
					end
				end 
			end 
		end 
	end 
end)


function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 180)
		end
		if (not bgColor) then
			bgColor = borderColor
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);

        dxDrawRectangle(x + 0.5, y + 0.5, 1, 2, borderColor, postGUI);
        dxDrawRectangle(x + 0.5, y + h - 1.5, 1, 2, borderColor, postGUI);
        dxDrawRectangle(x + w - 0.5, y + 0.5, 1, 2, borderColor, postGUI);
        dxDrawRectangle(x + w - 0.5, y + h - 1.5, 1, 2, borderColor, postGUI);
	end
end

function isInBox(xS,yS,wS,hS)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition()
		sX,sY = guiGetScreenSize()
		cursorX, cursorY = cursorX*sX, cursorY*sY
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end	
end

addEventHandler("onClientRender", root, function()
	if getElementData(localPlayer, "loggedin") == 1 then 
		local mesafe = getDistanceBetweenPoints3D(1914.044921875, 2701.1494140625, 11.8203125, localPlayer.position)
		if mesafe <= 3 then
			local cx, cy, cz, clx, cly, clz = getCameraMatrix()
			if isLineOfSightClear(cx, cy, cz, 1914.044921875, 2701.1494140625, 11.8203125, true, false, true, true, false, false, true) then
				local sx, sy = getScreenFromWorldPosition(1914.044921875, 2701.1494140625, 11.8203125, dxGetTextWidth("self.string", 1, Roboto11, true), false)
				if sx and sy then
					dxDrawText("Raylı Sistemler", sx, sy, _, _, tocolor(255, 255, 255, 255), 1, Roboto11, "center", "center", false, false, false, true)
				end
			end
		end
	end
end)