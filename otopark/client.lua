local sx, sy= guiGetScreenSize()

local fonts = {
	exports['fonts']:getFont('RobotoB',14),
	exports['fonts']:getFont('RobotoB',14),
	exports['fonts']:getFont('RobotoB',20),
	exports['fonts']:getFont('RobotoB',10)
}

roundedRectangle = function (x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200)
		end
		if (not bgColor) then
			bgColor = borderColor
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI)
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI)
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI)
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI)
	end
end
x2 , y2, z2 = 0, 0, 0
maxshow = 5
scrollNum = 0
tiklama = 0
seciliarac = {}
tiklananarac = {}
timer = {}
show = false
otoparkDX = function ()
	if getElementData(localPlayer, "loggedin") == 1 then	
        roundedRectangle (sx *0.2990, sy * 0.2390, sx * 0.3870, sy * 0.3220, tocolor(222, 222, 222, 25), false) 
        roundedRectangle (sx *0.3000, sy * 0.2400, sx * 0.3850, sy * 0.3200, tocolor(33 ,33 ,33, 200), false) 
        roundedRectangle (sx *0.2990, sy * 0.1990, sx * 0.3870, sy * 0.0320, tocolor(222, 222, 222, 25), false) 
        roundedRectangle (sx *0.3000, sy * 0.2000, sx * 0.3850, sy * 0.0300, tocolor(33 ,33 ,33, 200), false) 
        dxDrawText("HydraDVV: Otopark Sistemi", sx * 0.4450, sy * 0.3820, sx * 0.1500, sy * 0.0500, tocolor(222, 222, 222  , 150), 1, fonts[2], "left", "center",  false, false, false, false, false)
        roundedRectangle (sx *0.5500, sy * 0.4450, sx * 0.1300, sy * 0.0500, tocolor(22 ,22 ,22, 150), false) 
        roundedRectangle (sx *0.5500, sy * 0.5000, sx * 0.1300, sy * 0.0500, tocolor(22 ,22 ,22, 150), false) 
        dxDrawText("Çıkart", sx * 0.6010, sy * 0.8900, sx * 0.1500, sy * 0.0500, tocolor(222, 222, 222  , 150), 1, fonts[2], "left", "center",  false, false, false, false, false)
        dxDrawText("NOT", sx * 0.5960, sy * 0.5900, sx * 0.1500, sy * 0.0500, tocolor(222, 222, 222  , 150), 1, fonts[3], "left", "center",  false, false, false, false, false)
        dxDrawRectangle(sx *0.5800, sy * 0.3370, sx * 0.0600, sy * 0.0010, tocolor(222, 222, 222, 150), false) 
        dxDrawText("Oyundan çıktığınız an araç otoparka yollanır.", sx * 0.5350, sy * 0.6600, sx * 0.1500, sy * 0.0500, tocolor(222, 222, 222  , 150), 1, fonts[4], "left", "center",  false, false, false, false, false)
        dxDrawText("Çıkış", sx * 0.6030, sy * 0.9999, sx * 0.1500, sy * 0.0500, tocolor(222, 222, 222  , 150), 1, fonts[2], "left", "center",  false, false, false, false, false)
        
    
        if isInSlot(sx *0.3020, sy * 0.2800, sx * 0.2300, sy * 0.0500) or tiklananarac[localPlayer] == 1 then
            roundedRectangle (sx *0.3020, sy * 0.2800, sx * 0.2300, sy * 0.0500, tocolor(109, 160, 101, 150), false)
        end

        if isInSlot(sx *0.3020, sy * 0.3350, sx * 0.2300, sy * 0.0500) or tiklananarac[localPlayer] == 2 then
            roundedRectangle (sx *0.3020, sy * 0.3350, sx * 0.2300, sy * 0.0500, tocolor(109, 160, 101, 150), false)
        end

        if isInSlot(sx *0.3020, sy * 0.3900, sx * 0.2300, sy * 0.0500) or tiklananarac[localPlayer] == 3 then
            roundedRectangle (sx *0.3020, sy * 0.3900, sx * 0.2300, sy * 0.0500, tocolor(109, 160, 101, 150), false)
        end

        if isInSlot(sx *0.3020, sy * 0.4450, sx * 0.2300, sy * 0.0500) or tiklananarac[localPlayer] == 4 then
            roundedRectangle (sx *0.3020, sy * 0.4450, sx * 0.2300, sy * 0.0500,  tocolor(109, 160, 101, 150), false)
        end

        if isInSlot(sx *0.3020, sy * 0.5000, sx * 0.2300, sy * 0.0500) or tiklananarac[localPlayer] == 5 then
            roundedRectangle (sx *0.3020, sy * 0.5000, sx * 0.2300, sy * 0.0500, tocolor(109, 160, 101, 150), false)
        end

        if isInSlot(sx *0.5500, sy * 0.4450, sx * 0.1300, sy * 0.0500) then
            roundedRectangle (sx *0.5500, sy * 0.4450, sx * 0.1300, sy * 0.0500, tocolor(222, 222, 222, 15), false)
            dxDrawText("Çıkart", sx * 0.6010, sy * 0.8900, sx * 0.1500, sy * 0.0500, tocolor(109, 160, 101, 150), 1, fonts[2], "left", "center",  false, false, false, false, false)
        end

        if isInSlot(sx *0.5500, sy * 0.5000, sx * 0.1300, sy * 0.0500) then
            roundedRectangle (sx *0.5500, sy * 0.5000, sx * 0.1300, sy * 0.0500, tocolor(222, 222, 222, 15), false)
            dxDrawText("Çıkış", sx * 0.6030, sy * 0.9999, sx * 0.1500, sy * 0.0500, tocolor(109, 160, 101, 150), 1, fonts[2], "left", "center",  false, false, false, false, false) 
        end 

        if isInSlot(sx *0.3000, sy * 0.2000, sx * 0.3850, sy * 0.0300) then
            dxDrawText("HydraDVV: Otopark Sistemi", sx * 0.4450, sy * 0.3820, sx * 0.1500, sy * 0.0500, tocolor(109, 160, 101  , 150), 1, fonts[1], "left", "center",  false, false, false, false, false)
        end
        
        x = 0
        h = 0
        y = 0
        vego = 0
        for i, arac in ipairs(araclar) do
            if (i > scrollNum and h < maxshow) then
                h = h +1
                roundedRectangle (sx *0.3020, sy * 0.2800+y, sx * 0.2300, sy * 0.0500, tocolor(22 ,22 ,22, 150), false) 
                dxDrawText(arac.model.."("..arac.dbid..")", sx * 0.3285, sy * 0.5600+x, sx * 0.1500, sy * 0.0500, tocolor(222, 222, 222  , 150), 1.3, "default-bold", "left", "center",  false, false, false, false, false)
                dxDrawImage( sx * 0.3000, sy * 0.2800+vego, sx * 0.0300, sy * 0.0500, "files/car.png", 0, 0, 0, tocolor(222, 222, 222, 150) )
                x = x + 120
                vego = vego + 60
                if isInSlot(sx *0.3020, sy * 0.2800+y, sx * 0.2300, sy * 0.0500) then 
                    if getKeyState("mouse1") and tiklama+200 <= getTickCount() then
                        if getElementData(arac.otoparkveh, "otopark") == 1 then
                            tiklama = getTickCount()
                            seciliarac[localPlayer] = arac.dbid
                            tiklananarac[localPlayer] = i
                        end
                    end 
                end
                y = y + 59.5
            end 
        end
    end
end

addEventHandler("onClientClick", root, function(a, s)
	if a == "left" and s == "down" then 
		if show then 
			if isInSlot(sx *0.5500, sy * 0.4450, sx * 0.1300, sy * 0.0500) then
				if isTimer(timer[localPlayer]) then return end
				if seciliarac[localPlayer] then 
                    show = false
                    removeEventHandler("onClientRender", root, otoparkDX)
                    triggerServerEvent("otopark > cikar", localPlayer, localPlayer, seciliarac[localPlayer])
                end
				timer[localPlayer] = setTimer(function() end, 1000, 1)
			elseif isInSlot(sx *0.5500, sy * 0.5000, sx * 0.1300, sy * 0.0500) then 
				removeEventHandler("onClientRender", root, otoparkDX)
				show = false
			end
		end
	end
end) 

screenSize = {guiGetScreenSize()}
getCursorPos = getCursorPosition
getCursorPosition = function ()
    if isCursorShowing() then
        local x,y = getCursorPos()
        x, y = x * screenSize[1], y * screenSize[2] 
        return x,y
    else
        return -5000, -5000
    end
end

bindKey("mouse_wheel_down", "down",
	function()
		if show then
			if scrollNum < #araclar - maxshow then
				scrollNum = scrollNum + 1
			end
		end
	end
)

bindKey("mouse_wheel_up", "down",
	function()
		if show then
			if scrollNum > 0 then
				scrollNum = scrollNum - 1
			end
		end
	end
)

cursorState = isCursorShowing()
cursorX, cursorY = getCursorPosition()

isInBox = function(dX, dY, dSZ, dM, eX, eY)
    if eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM then
        return true
    else
        return false
    end
end

isInSlot = function(xS,yS,wS,hS)
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        if isInBox(xS,yS,wS,hS, cursorX, cursorY) then
            return true
        else
            return false
        end
    end 
end

araclar = {}

araclar = {}
otoparkdxopen = function(player, tablo)
    veh = getPedOccupiedVehicle(player)
	if show == false then 
        if not veh then
		    araclar = tablo
		    addEventHandler("onClientRender", root, otoparkDX)
		    show = true
        end
	end
end
addEvent("otopark > acilis", true)
addEventHandler("otopark > acilis", root, otoparkdxopen)

otoparkdxclose = function()
	if show == true then
        removeEventHandler("onClientRender", root, otoparkDX)
        show = false
	end
end
addEvent("otopark > kapanis", true)
addEventHandler("otopark > kapanis", root, otoparkdxclose)