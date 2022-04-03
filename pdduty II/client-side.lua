local sx, sy = guiGetScreenSize()
local browser = guiCreateBrowser(0, 0, sx, sy, true, true, false)

guiSetVisible(browser, false)
local theBrowser = guiGetBrowser(browser)
guiSetInputMode("no_binds_when_editing")

addEventHandler("onClientBrowserCreated", theBrowser, 
    function()
        loadBrowserURL(source, "http://mta/local/index.html")
    end
)

function closePanel()
    guiSetVisible( browser, not guiGetVisible( browser ) )
    showCursor(guiGetVisible( browser ))
end
addEvent("customduty:closePanel", true)
addEventHandler("customduty:closePanel", root, closePanel)

function triggerPanel(player)
    if getElementData(localPlayer, "faction") == 1 then
        local px, py, pz = getElementPosition(localPlayer)

        local px1, py1, pz1 = settings.colshapes[1][1], settings.colshapes[1][2], settings.colshapes[1][3]
        local px2, py2, pz2 = settings.colshapes[2][1], settings.colshapes[2][2], settings.colshapes[2][3]
        
        if getDistanceBetweenPoints3D(px, py, pz, px1, py1, pz1) < 5 or getDistanceBetweenPoints3D(px, py, pz, px2, py2, pz2) < 5 then
            guiSetVisible( browser, not guiGetVisible( browser ) )
            showCursor(guiGetVisible( browser ))
        else 
            local veh = getPedOccupiedVehicle(localPlayer)
            if veh then 
                if settings.dutyVehicles[getElementModel(veh)] then
                    guiSetVisible( browser, not guiGetVisible( browser ) )
                    showCursor(guiGetVisible( browser ))
                end 
            end
        end
    end
end
addCommandHandler("cduty", triggerPanel)

-- >>>>>>>>>>>>>>>>>> WEAPONS <<<<<<<<<<<<<<<<<< -- 

function giveM4()
    closePanel()
    triggerServerEvent("customduty_s:givem4",localPlayer,localPlayer)
end
addEvent("customduty:givem4", true)
addEventHandler("customduty:givem4", root, giveM4)

function giveDeagle()
    closePanel()
    triggerServerEvent("customduty_s:givedeagle",localPlayer,localPlayer)
end
addEvent("customduty:givedeagle", true)
addEventHandler("customduty:givedeagle", root, giveDeagle)

function giveShotgun()
    closePanel()
    triggerServerEvent("customduty_s:giveshotgun",localPlayer,localPlayer)
end
addEvent("customduty:giveshotgun", true)
addEventHandler("customduty:giveshotgun", root, giveShotgun)

function giveCShotgun()
    closePanel()
    triggerServerEvent("customduty_s:givecshotgun",localPlayer,localPlayer)
end
addEvent("customduty:givecshotgun", true)
addEventHandler("customduty:givecshotgun", root, giveCShotgun)

function giveSniper()
    closePanel()
    triggerServerEvent("customduty_s:givesniper",localPlayer,localPlayer)
end
addEvent("customduty:givesniper", true)
addEventHandler("customduty:givesniper", root, giveSniper)

function giveMP5()
    closePanel()
    triggerServerEvent("customduty_s:givemp5",localPlayer,localPlayer)
end
addEvent("customduty:givemp5", true)
addEventHandler("customduty:givemp5", root, giveMP5)

-- >>>>>>>>>>>>>>>>>> WEAPONS <<<<<<<<<<<<<<<<<< -- 

-- >>>>>>>>>>>>>>>>>> ARMOR <<<<<<<<<<<<<<<<<< -- 

function armor25()
    closePanel()
    triggerServerEvent("customduty_s:armor25",localPlayer,localPlayer)
end
addEvent("customduty:armor25", true)
addEventHandler("customduty:armor25", root, armor25)

function armor50()
    closePanel()
    triggerServerEvent("customduty_s:armor50",localPlayer,localPlayer)
end
addEvent("customduty:armor50", true)
addEventHandler("customduty:armor50", root, armor50)

function armor100()
    closePanel()
    triggerServerEvent("customduty_s:armor100",localPlayer,localPlayer)
end
addEvent("customduty:armor100", true)
addEventHandler("customduty:armor100", root, armor100)

-- >>>>>>>>>>>>>>>>>> ARMOR <<<<<<<<<<<<<<<<<< -- 

-- >>>>>>>>>>>>>>>>>> AMMO <<<<<<<<<<<<<<<<<< -- 

function giveAmmo1()
    closePanel()
    triggerServerEvent("customduty_s:givedeagle_ammo",localPlayer,localPlayer)
end
addEvent("customduty:givedeagle_ammo", true)
addEventHandler("customduty:givedeagle_ammo", root, giveAmmo1)

function giveAmmo2()
    closePanel()
    triggerServerEvent("customduty_s:givemp5_ammo",localPlayer,localPlayer)
end
addEvent("customduty:givemp5_ammo", true)
addEventHandler("customduty:givemp5_ammo", root, giveAmmo2)

function giveAmmo3()
    closePanel()
    triggerServerEvent("customduty_s:givem4_ammo",localPlayer,localPlayer)
end
addEvent("customduty:givem4_ammo", true)
addEventHandler("customduty:givem4_ammo", root, giveAmmo3)

function giveAmmo4()
    closePanel()
    triggerServerEvent("customduty_s:givesniper_ammo",localPlayer,localPlayer)
end
addEvent("customduty:givesniper_ammo", true)
addEventHandler("customduty:givesniper_ammo", root, giveAmmo4)

function giveAmmo5()
    closePanel()
    triggerServerEvent("customduty_s:givecshotgun_ammo",localPlayer,localPlayer)
end
addEvent("customduty:givecshotgun_ammo", true)
addEventHandler("customduty:givecshotgun_ammo", root, giveAmmo5)

function giveAmmo6()
    closePanel()
    triggerServerEvent("customduty_s:giveshotgun_ammo",localPlayer,localPlayer)
end
addEvent("customduty:giveshotgun_ammo", true)
addEventHandler("customduty:giveshotgun_ammo", root, giveAmmo6)

-- >>>>>>>>>>>>>>>>>> AMMO <<<<<<<<<<<<<<<<<< -- 

-- >>>>>>>>>>>>>>>>>> SKINS <<<<<<<<<<<<<<<<<< -- 

function skin1()
    closePanel()
    triggerServerEvent("customduty_s:skin1",localPlayer,localPlayer)
end
addEvent("customduty:skin1", true)
addEventHandler("customduty:skin1", root, skin1)

function skin2()
    closePanel()
    triggerServerEvent("customduty_s:skin2",localPlayer,localPlayer)
end
addEvent("customduty:skin2", true)
addEventHandler("customduty:skin2", root, skin2)

function skin3()
    closePanel()
    triggerServerEvent("customduty_s:skin3",localPlayer,localPlayer)
end
addEvent("customduty:skin3", true)
addEventHandler("customduty:skin3", root, skin3)

function skin4()
    closePanel()
    triggerServerEvent("customduty_s:skin4",localPlayer,localPlayer)
end
addEvent("customduty:skin4", true)
addEventHandler("customduty:skin4", root, skin4)

function skin5()
    closePanel()
    triggerServerEvent("customduty_s:skin5",localPlayer,localPlayer)
end
addEvent("customduty:skin5", true)
addEventHandler("customduty:skin5", root, skin5)

-- >>>>>>>>>>>>>>>>>> SKINS <<<<<<<<<<<<<<<<<< -- 

-- >>>>>>>>>>>>>>>>>> ITEMS <<<<<<<<<<<<<<<<<< -- 

function giveradio()
    closePanel()
    triggerServerEvent("customduty_s:giveradio",localPlayer,localPlayer)
end
addEvent("customduty:giveradio", true)
addEventHandler("customduty:giveradio", root, giveradio)

function givecuff()
    closePanel()
    triggerServerEvent("customduty_s:givecuff",localPlayer,localPlayer)
end
addEvent("customduty:givecuff", true)
addEventHandler("customduty:givecuff", root, givecuff)

function givebelt()
    closePanel()
    triggerServerEvent("customduty_s:givebelt",localPlayer,localPlayer)
end
addEvent("customduty:givebelt", true)
addEventHandler("customduty:givebelt", root, givebelt)

function givejop()
    closePanel()
    triggerServerEvent("customduty_s:givejop",localPlayer,localPlayer)
end
addEvent("customduty:givejop", true)
addEventHandler("customduty:givejop", root, givejop)

-- >>>>>>>>>>>>>>>>>> ITEMS <<<<<<<<<<<<<<<<<< -- 