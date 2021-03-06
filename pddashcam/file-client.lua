color="#9ed063[!] #ffffff"
export = exports.global

ekran_x,ekran_y=guiGetScreenSize()
c_settings={p_dash_shape=nil,p_dash_sivil="",p_dash_marka="",p_dash_plate="",p_dash_speed="",}
p_col_shape={}

renderSuresi = {}
function c_render(id,func) if not isTimer(renderSuresi[id]) then renderSuresi[id] = setTimer(func,1,0) end end
function c_renderSil(id) if isTimer(renderSuresi[id]) then killTimer(renderSuresi[id]) renderSuresi[id] = nil end end

function c_dash_render()
dxDrawRectangle(ekran_x*0.8150,ekran_y*0.4500,ekran_x*0.1700,ekran_y*0.1000,tocolor(0,0,0,170))
if c_settings.p_dash_sivil=="" then
dxDrawText(c_settings.p_dash_marka,ekran_x*0.8720,ekran_y*0.5800,ekran_x*0.1600,ekran_y*0.3600,tocolor(222,222,222,150),0.7,"bankgothic","left","center")
dxDrawText(c_settings.p_dash_plate,ekran_x*0.8530,ekran_y*0.6400,ekran_x*0.1600,ekran_y*0.3600,tocolor(222,222,222,150),0.7,"bankgothic","left","center")
else
dxDrawText(c_settings.p_dash_sivil,ekran_x*0.8590,ekran_y*0.6400,ekran_x*0.1600,ekran_y*0.3600,tocolor(222,222,222,150),0.7,"bankgothic","left","center")
end
if c_settings.p_dash_speed == "" then else
dxDrawText(""..tostring(math.floor(c_settings.p_dash_speed)).." KM/H",ekran_x*0.8700,ekran_y*0.7000,ekran_x*0.1600,ekran_y*0.3600,tocolor(222,222,222,150),0.7,"bankgothic","left","center")
end
end

function c_dashcam()
local p_car = getPedOccupiedVehicle(getLocalPlayer())
if not p_car then outputChatBox(""..color.."Önce bir polis arabasında olmalısınız!",0,0,0,true) return end
if getElementData(p_car,"faction") == 1 then else return end
if c_settings.p_dash_shape==nil then else c_renderSil("c_dash_render") c_settings.p_dash_shape=nil destroyElement(p_col_shape[getLocalPlayer()]) p_col_shape[getLocalPlayer()] = nil return end
c_settings.p_dash_shape=true
c_render("c_dash_render",c_dash_render)
local r_g_x,r_g_y_,r_g_z = getElementRotation(p_car)
p_x,p_y,p_z = getElementPosition(p_car)
p_x = p_x+((math.cos(math.rad(r_g_z)))*5)
p_y = p_y+((math.sin(math.rad(r_g_z)))*5)
p_col_shape[getLocalPlayer()] = createColSphere(p_x,p_y,p_z,3)
attachElements(p_col_shape[getLocalPlayer()],p_car,0,8,0)
addEventHandler("onClientColShapeHit",p_col_shape[getLocalPlayer()],araca_yaklasti)
addEventHandler("onClientColShapeLeave",p_col_shape[getLocalPlayer()],aractan_uzaklasti)
end
addCommandHandler("dashcam",c_dashcam)

function araca_yaklasti(element,matchingDimension)
if getElementType(element) == "vehicle" then else return end
local owner = getElementData(element,"owner") or -1
local faction = getElementData(element,"faction")
local plate_gizlimi = getElementData(element,"show_plate") or 0
local plate = getElementData(element,"plate")
local carName = getElementData(element,"brand")
local dash_speed = export:getVehicleVelocity(element)
if owner < 0 and faction == -1 then
c_settings.p_dash_sivil="sivil araç!"
c_settings.p_dash_speed=""
elseif (faction==-1) and (owner>0) then
c_settings.p_dash_sivil=""
c_settings.p_dash_marka=carName
c_settings.p_dash_speed=dash_speed
if plate_gizlimi == 1 then
c_settings.p_dash_plate=plate
else
c_settings.p_dash_plate="kapalı plaka"
end
if not carName then c_settings.p_dash_marka="Car" end
end
end

function aractan_uzaklasti(element,matchingDimension)
if getElementType(element) == "vehicle" then else return end
if c_settings.p_dash_shape==true then else return end
c_settings.p_dash_sivil=""
c_settings.p_dash_marka=""
c_settings.p_dash_plate=""
c_settings.p_dash_speed=""
end

addEventHandler("onClientVehicleExit",getRootElement(),function(player,seat)
if (player == localPlayer) then
if c_settings.p_dash_shape==true then
c_renderSil("c_dash_render") c_settings.p_dash_shape=nil destroyElement(p_col_shape[player]) p_col_shape[player] = nil
end
end
end)