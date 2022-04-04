addEvent('car.rent', true)
addEventHandler('car.rent', root, function(model, cash)
  if source:getData('loggedin') == 1 then
    if tonumber(model) and tonumber(cash) then
      if source:getData('rent:car') then
        source:outputChat('[HydraDVV]#D0D0D0 Zaten bir araba kiralamışsınız!',195,184,116,true)
      else
        if exports.global:takeMoney(source, cash) then
          local car = Vehicle(model, 439.380859375, -1558.12890625, 27.068222045898, 0, 0, 177.36303710938, 'KIRALIK')
          local x, y, z = getElementPosition(car)
          car:setOverrideLights(1)
          car:setEngineState(false)
          car:setData('dbid', -source:getData('dbid'), true)
          car:setData('fuel', 100)
          car:setData('plate', 'KIRALIK', true)
          car:setData('Impounded', 0)
          car:setData('engine', 0, false)
          car:setData('oldx', x, false)
          car:setData('oldy', y, false)
          car:setData('oldz', z, false)
          car:setData('faction', -1)
          car:setData('owner', source:getData('dbid'), false)
          car:setData('job', 0, false)
          car:setData('handbrake', 0, true)
          car:setData('brand', brand, true)
          exports.global:giveItem(source, 3, -source:getData('dbid'))
          source:outputChat('[HydraDVV]#D0D0D0 Yeni aracını başarıyla kiraladın! (1 saat)',195,184,116,true)
          source:setData('rent:car', true)
          setTimer(function()
            car:destroy()
          end, 3600000, 1)
        else
          source:outputChat('[HydraDVV]#D0D0D0 Bu aracı kiralamak için '..cash..'₺ ödemeniz gerekli.',195,184,116,true)
        end
      end
    end
  end
end)