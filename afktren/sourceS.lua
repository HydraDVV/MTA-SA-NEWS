mysql = exports.mysql
owl = nil -- Alt yapınız OwlGaming ise true kalmadı eğer UnitedGaming alt yapısı ise false yazınız. 
vehStock = 10

addEventHandler("onVehicleStartExit", root, function(player, seat, jacked)
    if getElementData(source, "trainJOB") then 
        finishVeh(player, source)
    end 
end)

addEventHandler("onVehicleStartEnter", root, function(player, seat, jacked)
    if getElementData(source, "trainJOB") then 
        if seat > 0 then 
            outputChatBox("[!]#ffffff Maalesef bu trene binemezsiniz.", player, 255, 0, 0, true)
            cancelEvent()
            return false 
        else 
            if getElementData(source, "owner") ~= getElementData(player, "dbid") then 
                outputChatBox("[!]#ffffff Bu trene sahibi olmadan binemezsiniz.", player, 255, 0, 0, true)
                cancelEvent()
                return false
            end 
        end 
    end 
end)

addEvent("clientTrain>>openPanels", true)
addEventHandler("clientTrain>>openPanels", root, function(player)
    triggerClientEvent(root, "clientTrain>>openPanelc", root, player, vehStock)
end)

addEvent("clientTrain>>GiveJobVeh", true)
addEventHandler("clientTrain>>GiveJobVeh", root, function(player, model)
        local veh = createVehicle(model, 1915.9892578125, 2694.1806640625, 10.900276184082, 0, 0, 0)
        setElementData(veh, "dbid", -1-getElementData(player, "dbid"))
        setElementData(veh, "fuel", 100)
        setElementData(veh, "plate", "End")
        setElementData(veh, "Impounded", 0)
        setElementData(veh, "engine", 1)
        setElementData(veh, "oldx", 1924.861328125)
        setElementData(veh, "oldy", 2694.7314453125)
        setElementData(veh, "oldz", 10.8203125)
        setElementData(veh, "faction", -1)
        setElementData(veh, "handbrake", 0)
        setElementData(veh, "trainJOB", true)
        setElementData(veh, "owner", getElementData(player, "dbid"))
        setElementData(player, "trainVeh", veh)
        setTrainDerailable(veh, true)
        vehStock = vehStock - 1
    Timer(function(player, veh)
        warpPedIntoVehicle(player, veh)
    end, 100, 1, player, veh)
        if owl then 
            local vehShopData = exports["vehicle_manager"]:getInfoFromVehShopID(1012)
            setElementData(veh, "brand", vehShopData.vehbrand)
            setElementData(veh, "maximemodel", vehShopData.vehmodel)
            setElementData(veh, "year", vehShopData.vehyear)
            setElementData(veh, "vehicle_shop_id", vehShopData.id)
        end
	return veh
end)

addEventHandler ( "onPlayerQuit", root, function(type)
    if getElementData(source, "trainVeh") then 
        destroyElement(getElementData(source, "trainVeh"))
        print("+")
        vehStock = vehStock + 1
    end 
end)

addEvent("clientTrain>>GiveMoney", true)
addEventHandler("clientTrain>>GiveMoney", root, function(player, price)
    exports["global"]:giveMoney(player, price)
end)

finishVeh = function(player, veh)
    if getElementData(veh, "trainJOB") then 
    Timer(function(player)
        removePedFromVehicle(player)
        setElementPosition(player, 1916.3984375, 2704.271484375, 10.812517166138)
        setElementRotation(player, 0, 0, 90)
        triggerClientEvent(player, "clientTrain>>FinishJob", player)
    end, 100, 1, player)
        destroyElement(veh)
        vehStock = vehStock + 1
    end 
end



























































createObject(2008, 1913.5380859375, 2700.4619140625, 9.8, 0, 0, 90)