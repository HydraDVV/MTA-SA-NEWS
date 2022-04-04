Rent = Service:new('carrent-system')
author = 'github.com/HydraDVV'
font = DxFont('components/Roboto.ttf', 9)
screen = Vector2(guiGetScreenSize())
show = false
dxDrawRectangle = dxDrawRectangle
dxDrawImage = dxDrawImage
dxDrawText = dxDrawText
region = ColShape.Sphere(439.5439453125, -1549.572265625, 28.059703826904, 3)
pickup = Pickup(439.5439453125, -1549.572265625, 28.059703826904, 3, 1239)
pickup:setData('informationicon:information', '#7f8fa6/kirala\n#ffffff Araç Kiralama Noktası')
header = exports.fonts:getFont('RobotoB', 15)
icoFont = exports.fonts:getFont('FontAwesome', 11)
icoSymbol = exports.fonts:getIcon('fa-car')
Rent.constructor = function()
	if localPlayer:isWithinColShape(region) then
		show = true
		active = false
		showCursor(true)

		Rent.render = Timer(
			function()
				if show then
					dxDrawRoundedRectanglee(screen.x/2-500/2, screen.y/2-400/2, 500, 350,tocolor(8,8,8, 230), { 0.05, 0.05, 0.05, 0.05 }, false)
					dxDrawRoundedRectanglee(screen.x/2 + 215, screen.y/2-392/2, 30, 30,tocolor(29,53,145, 255), { 0.4, 0.4, 0.4, 0.4 }, false)
					dxDrawText(icoSymbol,screen.x/2 + 220, screen.y/2-380/2, 650, 150, tocolor(200,200,200,250), 1, icoFont)
					dxDrawRoundedRectanglee(screen.x/2-450/2, screen.y/2-250/2, 450, 220,tocolor(5,5,5, 230), { 0.1, 0.1, 0.1, 0.1 }, false)

					--dxDrawRectangle(screen.x/2-500/2, screen.y/2-350/2, 500, 400, tocolor(5,5,5,225))
					dxDrawText('araç kiralama arayüzü',screen.x/2-470/2, screen.y/2-380/2, 650, 150, tocolor(200,200,200,250), 1, header)
					dxDrawText('Araç kiralamaya hoşgeldin, araçlara listeden göz atabilirsin,',screen.x/2-450/2, screen.y/2+200/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText('ekranı kapatmak için aşşağıdaki çizgiye tıklayabilirsin.',screen.x/2-450/2, screen.y/2+230/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawImage(screen.x/2-430/2, screen.y/2-190/2, 65, 20, 'components/sultan.png')
					dxDrawImage(screen.x/2-430/2, screen.y/2-45/2, 65, 20, 'components/elegy.png')
					dxDrawImage(screen.x/2-430/2, screen.y/2+100/2, 65, 20, 'components/flash.png')
					dxDrawRoundedRectanglee(screen.x/2-100/2, screen.y/2+155, 100, 6,tocolor(200,200,200, 230), { 0.5, 0.5, 0.5, 0.5 }, false)

					if isMouseInPosition(screen.x/2-75/2, screen.y/2+315/2, 75, 75) and getKeyState("mouse1") then
						Rent.close()
					end

					dxDrawText(' Araç Marka',screen.x/2-450/2, screen.y/2-285/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText(' Kira Bedeli',screen.x/2+165/2, screen.y/2-285/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText(' Araç Özellikleri',screen.x/2 - 65, screen.y/2-285/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText('  Sultan (GTA-SA Style)',screen.x/2-450/2, screen.y/2-235/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText('- 1130₺',screen.x/2+165/2, screen.y/2-235/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText('  Hız: 175 km/h\n  Teker: 4x2\n  Beygir: 120hp',screen.x/2-65, screen.y/2-235/2, 650, 150, tocolor(200,200,200,250), 1, font)

					if isMouseInPosition(screen.x/2+335/2, screen.y/2-180/2, 50, 20) and getKeyState("mouse1") then
						dxDrawRectangle(screen.x/2+335/2, screen.y/2-180/2, 50, 20, tocolor(5,70,5,200))
						dxDrawText('Kirala',screen.x/2+355/2, screen.y/2-175/2, 650, 150, tocolor(200,200,200,250), 1, font)
						if not active then
							active = true
							triggerServerEvent('car.rent', localPlayer, 540, 1130)
							Rent.timer()
						end
					else
						dxDrawRoundedRectanglee(screen.x/2+335/2, screen.y/2-180/2, 50, 20,tocolor(50,50,50, 230), { 0.5, 0.5, 0.5, 0.5 }, false)
						dxDrawText('Kirala',screen.x/2+355/2, screen.y/2-175/2, 650, 150, tocolor(200,200,200,250), 1, font)

					end

					dxDrawText('  Elegy (GTA-SA Style)',screen.x/2-450/2, screen.y/2-90/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText('- 1450₺',screen.x/2+165/2, screen.y/2-90/2, 650, 150, tocolor(200,200,200,250), 1, font)

					dxDrawText('  Hız: 210 km/h\n  Teker: 4x2\n  Beygir: 140hp',screen.x/2-65, screen.y/2-90/2, 650, 150, tocolor(200,200,200,250), 1, font)
					if isMouseInPosition(screen.x/2+335/2, screen.y/2-50/2, 50, 20) and getKeyState("mouse1") then
						dxDrawRectangle(screen.x/2+335/2, screen.y/2-50/2, 50, 20, tocolor(5,70,5,200))
						dxDrawText('Kirala',screen.x/2+355/2, screen.y/2-45/2, 650, 150, tocolor(200,200,200,250), 1, font)
						if not active then
							active = true
							triggerServerEvent('car.rent', localPlayer, 439, 1450)
							Rent.timer()
						end
					else
						dxDrawRoundedRectanglee(screen.x/2+335/2, screen.y/2-50/2, 50, 20,tocolor(50,50,50, 230), { 0.5, 0.5, 0.5, 0.5 }, false)
						dxDrawText('Kirala',screen.x/2+355/2, screen.y/2-45/2, 650, 150, tocolor(200,200,200,250), 1, font)
					end

					dxDrawText('  Flash (GTA-SA Style',screen.x/2-450/2, screen.y/2+55/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText('- 970₺',screen.x/2+165/2, screen.y/2+55/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText('  Hız: 140 km/h\n  Teker: 4x2\n  Beygir: 80hp',screen.x/2-65, screen.y/2+55/2, 650, 150, tocolor(200,200,200,250), 1, font)

					if isMouseInPosition(screen.x/2+335/2, screen.y/2+75/2, 50, 20) and getKeyState("mouse1") then
						dxDrawRectangle(screen.x/2+335/2, screen.y/2+75/2, 50, 20, tocolor(5,70,5,200))
						dxDrawText('Kirala',screen.x/2+355/2, screen.y/2+80/2, 650, 150, tocolor(200,200,200,250), 1, font)
						if not active then
							active = true
							triggerServerEvent('car.rent', localPlayer, 492, 970)
							Rent.timer()
						end
					else
						dxDrawRoundedRectanglee(screen.x/2+335/2, screen.y/2+75/2, 50, 20,tocolor(50,50,50, 230), { 0.5, 0.5, 0.5, 0.5 }, false)
						dxDrawText('Kirala',screen.x/2+355/2, screen.y/2+80/2, 650, 150, tocolor(200,200,200,250), 1, font)
					end
				else
					Rent.close()
				end
			end,
		7, 0)
	end
end

Rent.timer = function()
	Rent.timerEnd = Timer(
		function()
			active = false
		end,
	2000, 1)
end

Rent.close = function()
	showCursor(false)
	show = false
	killTimer(Rent.render)
end

addCommandHandler('kirala', Rent.constructor)