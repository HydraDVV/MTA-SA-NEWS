
startAnimation = "InOutQuad"
startAnimationTime = 250

renderTimers = {}

function createRender(funcName, func, tick)
    if not tick then
        tick = 5
    end
    
    if not renderTimers[funcName] then
        if funcName then 
            renderTimers[funcName] = setTimer(func, tick, 0)
        end
    end
end

function checkRender(funcName)
    return renderTimers[funcName]
end

function destroyRender(funcName)
    if renderTimers[funcName] then
        killTimer(renderTimers[funcName])
        renderTimers[funcName] = nil
        collectgarbage("collect")
    end
end

local minigameStarted, chopStarted, gData

mini_text = ''
mini_color = tocolor(3, 223, 252, 220)

trashs = {}
trashTimer = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
	if Config.state then 
		for key, value in ipairs(Config.settings.trash) do 
			trashs[key] = createObject(Config.model, value[1], value[2], value[3])
			trashs[key]:setData("trash.state", true)
			trashs[key]:setData("trash.ID", key)
		end 
	end 
end)

addEvent("trash >> state", true)
addEventHandler("trash >> state", root, function(state, element)
	if state then 
		outputChatBox("[!]#ffffff Çöpü başarıyla karıştırdınız.", 0, 255, 0, true)
		setElementData(element, "trash.state", nil)
		trashTimer[element] = Timer(function(element)
			setElementData(element, "trash.state", true)
		end, 5000, 1, element)
		local random_number = math.random(1, #Config.settings.items)
		local itemID = Config.settings.items[random_number][1]
		local itemValue = Config.settings.items[random_number][2]
		triggerServerEvent("trash >> setPedAnimation", localPlayer, localPlayer)
		if itemID > 0 then
			if type(itemValue) == "number" then 
				outputChatBox("[!]#ffffff Bu çöp kutusundan ["..exports["vesta_items"]:getItemName(itemID).."] adlı eşyayı buldunuz.", 0, 255, 0, true)
				triggerServerEvent("trash >> giveItem", localPlayer, localPlayer, itemID, itemValue)
			else 
				outputChatBox("[!]#ffffff Bu çöp kutusundan ["..itemID.."] miktar para buldunuz.", 0, 255, 0, true)
				triggerServerEvent("trash >> giveMoney", localPlayer, localPlayer, itemID)
			end
		else 
			outputChatBox("[!]#ffffff Bu çöp kutusundan bir şey bulamadınız.", 255, 0, 0, true)
		end
	end 
end)

if not isChatBoxInputActive() then
    outputChatBox("You're typing")
end


lastClick = 0
setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then 
		for key, value in ipairs(trashs) do 
			local tx, ty, tz = getElementPosition(value)
			local mesafe = getDistanceBetweenPoints3D(tx, ty, tz, localPlayer.position)
			if mesafe <= 1 then
				if getKeyState("E") and lastClick+800 <= getTickCount() then
					lastClick = getTickCount()
					if not isChatBoxInputActive() then
						if getElementData(value, "trash.state") then 
							startMinigame("chopping",
								{
									["color"] = tocolor(0, 0, 0, 220),
									["text"] = "Çöp karıştırılıyor.",
									["state"] = true,
									["element"] = value,
									["successEvent"] = "trash >> state"
								}
							)
							triggerServerEvent("trash >> setPedAnimation", localPlayer, localPlayer, "bomber", "bom_plant_crouch_out")
						else 
							outputChatBox("[!]#ffffff Bu çöpü zaten karıştırdınız.", 255, 0, 0, true)
						end
					end
				end 
				local cx, cy, cz, clx, cly, clz = getCameraMatrix()
				local sx, sy = getScreenFromWorldPosition(tx, ty, tz, dxGetTextWidth("self.string", 1, "default-bold", true), false)
				if sx and sy then
					dxDrawBorderedText(1, "Karıştırmak İçin\n[E]\nBasınız ", sx, sy, sx,sy, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", false, false, false, true)
				end
			end
		end
	end
end,7,0)

function startMinigame(id, data)
    if not minigameStarted then
        minigameStarted = true
        
        if id == "chopping" then
            gData = data
            chopAnim = true
            chopAnimTick = getTickCount()
            localPlayer.frozen = true
            createRender("renderBar", renderBar)
            
            local x,y = getElementPosition(localPlayer)
            if isTimer(minigameSuccessTimer) then killTimer(minigameSuccessTimer) end
            mini_text = gData['text'] or ''
            mini_color = gData['color'] or tocolor(3, 223, 252, 220)
            minigameSuccessTimer = setTimer(
                function()
                    destroyRender("renderBar")
                    localPlayer.frozen = false
                    minigameStarted = false
                    triggerEvent(gData["successEvent"], localPlayer, gData["state"], gData["element"])
                    gData = {}
                end, 5 * 1000, 1
            )
        end
    end
end

local sx, sy = guiGetScreenSize()
local w,h = 30, 220

function renderBar()
    local size
    local nowTick = getTickCount()
    if chopAnim then
        local elapsedTime = nowTick - chopAnimTick
        local duration = 5000
        local progress = elapsedTime / duration
        local alph = interpolateBetween(
            0, 0, 0,
            1, 0, 0,
            progress, startAnimation
        )

        size = alph
    end
    
    local w, h = 220, 30
    dxDrawRectangle(sx/2 - w/2, sy - h - 60, w, h, tocolor(0, 0, 0, 70))
    dxDrawRectangle(sx/2 - w/2, sy - h - 60, w * size, h, tocolor(3, 165, 252, 180))
    dxDrawBorder(sx/2 - w/2, sy - h - 60, w, h, tocolor(255, 255, 255, 255), 1)
    dxDrawText(mini_text, sx/2 - w/2, sy - h - 60, sx/2 - w/2 + w, sy - h - 60 + h, tocolor(255, 255, 255), 1, "default-bold", "center", "center")
   
end

function stopMinigame(id)
    if id == "chopping" then
        chopAnim = false
        chopAnimTick = getTickCount()
        
        if isTimer(timer1) then killTimer(timer1) end
        timer1 = setTimer(
            function()
                minigameStarted = false
                gData = {}
            end, startAnimationTime, 1
        )
        localPlayer.frozen = false
    end
end

function dxDrawBorder(x, y, width, height, color, _width, postGUI)
    local _width = _width or 1
    dxDrawLine(x, y, x+width, y, color, _width, postGUI)
    dxDrawLine(x, y, x, y+height, color, _width, postGUI)
    dxDrawLine(x, y+height, x+width, y+height, color, _width, postGUI) 
    dxDrawLine(x+width, y, x+width, y+height, color, _width, postGUI)
end


function dxDrawBorderedText (outline, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    local outline = (scale or 1) * (1.333333333333334 * (outline or 1))
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top - outline, right - outline, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top - outline, right + outline, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top + outline, right - outline, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top + outline, right + outline, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top, right - outline, bottom, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top, right + outline, bottom, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top - outline, right, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top + outline, right, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end