local sx, sy = guiGetScreenSize()

Roboto11 = dxCreateFont("assets/fonts/Roboto-Regular.ttf", 11, false, "antialiased")

local scrollNum = 0
local maxShowed = 10
roldersi = nil
panelstate = nil
alern_sayi = 0
tiklama = 0

setElementData(localPlayer, 'roldersi', nil)
addEventHandler("onClientRender", root, function()
if not panelstate then return end 
	w,h = 300, 400
	x,y,w,h = sx/2-w/2, sy/2-h/2, w, h 
	dxDrawRectangle(x, y, w, h, tocolor(0,0,0,100))
	x, y, w, h = x + 4, y + 4, w - 8, h - 8 
	dxDrawRectangle(x, y , w , h, tocolor(0,0,0,100))
	dxDrawRectangle(x, y , w , 30, tocolor(0,0,0,100))
	dxDrawText('Rol Dersi Almayanlar © Hydra', x, y, x+w, y+30, tocolor(255,255,255), 1 ,Roboto11,"center","center") 
	 index = 0	
     local elem = 0
     for key , value in ipairs(getElementsByType( "player" )) do 
		if value:getData('loggedin') == 1 and value:getData('roldersi') ~= 1 then 
			index = index+1
			alern_sayi = index
			if (index > scrollNum and elem < maxShowed) then
				elem = elem + 1
					if tonumber(value:getData('roldersi')) == 1 then 
						roldersi = 'Almış'
					else 
						roldersi = 'Almamış'
					end
				if isInBox(x, y+(elem*35), w, 30) then 
				 dxDrawRectangle(x, y+(elem*35), w, 30, tocolor(0,0,0,170))
				 dxDrawText('('..value:getData('playerid')..') '..value.name..' - Ders: '..(roldersi), x, y+(elem*35), x+w, y+(elem*35)+30, tocolor(255,255,255), 1 ,Roboto11,"center","center") 
					if getKeyState("mouse1") and tiklama+200 <= getTickCount() then
						tiklama = getTickCount()
						triggerServerEvent('alern:rol:class', localPlayer, localPlayer, value)
					end
				else 
				 dxDrawRectangle(x, y+(elem*35), w, 30, tocolor(0,0,0,100))
				 dxDrawText('('..value:getData('playerid')..') '..value.name..' - Ders: '..(roldersi), x, y+(elem*35), x+w, y+(elem*35)+30, tocolor(255,255,255, 100), 1 ,Roboto11,"center","center")
				end
			end 
		end
	end
end)

addCommandHandler('roldersi', function()
	if exports.integration:isPlayerAdmin(localPlayer) then 
		if not panelstate then 
			panelstate = true
		else 
			panelstate = nil
		end
	end 
end)

bindKey("mouse_wheel_down", "down",
	function()
		if scrollNum < alern_sayi - maxShowed and panelstate then
			scrollNum = scrollNum + 1
		end
	end
)

bindKey("mouse_wheel_up", "down",
	function()
		if scrollNum > 0 and panelstate then
			scrollNum = scrollNum - 1
		end
	end
)

isInBox = function (xS,yS,wS,hS)
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



