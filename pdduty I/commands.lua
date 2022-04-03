addCommandHandler('armor', function(thePlayer, cmd, value)
    if thePlayer:getData('faction') == 1 or thePlayer:getData('faction') == 78 then
        local theVehicle = thePlayer.vehicle
        if theVehicle then
            if theVehicle:getData('faction') == 1 or theVehicle:getData('faction') == 78 then
                if tonumber(value) then
                    if tonumber(value) > 100 then
                        thePlayer:outputChat('[-]#D0D0D0 Geçerli bir zırh değeri girin.',195,184,116,true)
                    else
                        global:sendLocalMeAction(thePlayer, 'yeleğindeki zırhı yeniler.')
                        thePlayer.armor = value
                    end
                else
                    thePlayer:outputChat('[-]#D0D0D0 /'..cmd..' [Zırh Değeri]',195,184,116,true)
                end
            else
                thePlayer:outputChat('[-]#D0D0D0 Herhangi bir görev aracında değilsiniz.',195,184,116,true)
            end
        else
            thePlayer:outputChat('[-]#D0D0D0 Herhangi bir görev aracında değilsiniz.',195,184,116,true)
        end
    end
end)