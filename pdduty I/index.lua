duty = {}
duty.__index = duty
duty.screen = Vector2(guiGetScreenSize())
duty.width, duty.height = 300, 200
duty.sizeX, duty.sizeY = (duty.screen.x-duty.width), (duty.screen.y-duty.height)
duty.robotoB = exports.fonts:getFont('RobotoB',15)
duty.roboto = exports.fonts:getFont('Roboto',11)

function duty:create()
    local instance = {}
    setmetatable(instance, duty)
    if instance:constructor() then
        return instance
    end
    return false
end

function duty:constructor()
    self = duty;
    self.active = false

    self.shapePD = ColShape.Sphere(361.8271484375, 174.0009765625, 1008.3893432617, 4)
    self.shapePD.interior = 3
    self.shapePD.dimension = 124  

    self.shapeMD = ColShape.Sphere(361.8271484375, 174.0009765625, 1008.3893432617, 4)
    self.shapeMD.interior = 3
    self.shapeMD.dimension = 124 

    bindKey("mouse_wheel_up", "down", self.up)
    bindKey("mouse_wheel_down", "down", self.down)

    addCommandHandler('sduty', self.open)
end

function duty:open()
    self = duty;
    if self.active then
        self.active = false
        showCursor(false)
        removeEventHandler('onClientRender', getRootElement(), self.render)
    else
        if localPlayer:isWithinColShape(self.shapePD) and localPlayer:getData('faction') == 1 or localPlayer:isWithinColShape(self.shapePD) and localPlayer:getData('faction') == 78 or localPlayer:isWithinColShape(self.shapeMD) and localPlayer:getData('faction') == 2 then
            if localPlayer:getData('faction') == 1 or localPlayer:getData('faction') == 2 or localPlayer:getData('faction') == 78 then
                self.active = true
                self.click = 0
                self.scrollClothes = 0
                self.scrollWeapons = 0
                self.scrollEquipments = 0
                self.selected = 'Clothes'
                showCursor(true)
                addEventHandler('onClientRender', root, self.render, true, 'low-10')
            end
        end
    end
end

function duty:render()
    self = duty;
    self:roundedRectangle(self.sizeX/2-150, self.sizeY/2-100, 600, 450, tocolor(15,15,15,245))

    dxDrawText('Görev Eşya Dolabı', self.sizeX/2-150, self.sizeY/2-107, 25, 25, tocolor(175,175,175,245), 0.65, self.robotoB)
    dxDrawText('Aşşağıda görev eşyaları sırayla listeleniyor:', self.sizeX/2-140, self.sizeY/2-85, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)

    if self:isInBox(self.sizeX/2+415, self.sizeY/2-85, 15, 15) then
        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
            self.click = getTickCount()
            self:open()
        end
        dxDrawText('X', self.sizeX/2+425, self.sizeY/2-90, 25, 25, tocolor(175,175,175,245), 0.65, self.robotoB)
    else
        dxDrawText('X', self.sizeX/2+425, self.sizeY/2-90, 25, 25, tocolor(225,225,225,245), 0.65, self.robotoB)
    end

    if self:isInBox(self.sizeX/2+325, self.sizeY/2+320, 125, 15) then
        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
            self.click = getTickCount()
            triggerServerEvent('duty.off', localPlayer)
            self:open()
        end
        dxDrawText('Görev Eşyalarını Bırak', self.sizeX/2+325, self.sizeY/2+320, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
    else
        dxDrawText('Görev Eşyalarını Bırak', self.sizeX/2+325, self.sizeY/2+320, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
    end

    if self:isInBox(self.sizeX/2-130, self.sizeY/2-50, 125, 25) then
        self:roundedRectangle(self.sizeX/2-130, self.sizeY/2-50, 125, 25, tocolor(20,20,20,245))
        dxDrawText('Kıyafetler', self.sizeX/2-95, self.sizeY/2-45, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
            self.click = getTickCount()
            self.selected = 'Clothes'
        end
    else
        self:roundedRectangle(self.sizeX/2-130, self.sizeY/2-50, 125, 25, tocolor(25,25,25,245))
        dxDrawText('Kıyafetler', self.sizeX/2-95, self.sizeY/2-45, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
    end

    if self:isInBox(self.sizeX/2+10, self.sizeY/2-50, 125, 25) then
        self:roundedRectangle(self.sizeX/2+10, self.sizeY/2-50, 125, 25, tocolor(20,20,20,245))
        dxDrawText('Silahlar', self.sizeX/2+50, self.sizeY/2-45, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
            self.click = getTickCount()
            self.selected = 'Weapons'
        end
    else
        self:roundedRectangle(self.sizeX/2+10, self.sizeY/2-50, 125, 25, tocolor(25,25,25,245))
        dxDrawText('Silahlar', self.sizeX/2+50, self.sizeY/2-45, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
    end

    if self:isInBox(self.sizeX/2+150, self.sizeY/2-50, 125, 25) then
        self:roundedRectangle(self.sizeX/2+150, self.sizeY/2-50, 125, 25, tocolor(20,20,20,245))
        dxDrawText('Teçhizatlar', self.sizeX/2+185, self.sizeY/2-45, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
            self.click = getTickCount()
            self.selected = 'Equipments'
        end
    else
        self:roundedRectangle(self.sizeX/2+150, self.sizeY/2-50, 125, 25, tocolor(25,25,25,245))
        dxDrawText('Teçhizatlar', self.sizeX/2+185, self.sizeY/2-45, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
    end

    if self.selected == 'Clothes' then
        self.counter = 0
        self.counterX = 0
        self.counterY = 0
        if localPlayer:getData('faction') == 1 or localPlayer:getData('faction') == 78 then
            self.clothes = {71, 60,280,281,282,284,285,286,287}
        elseif localPlayer:getData('faction') == 2 then
            self.clothes = {69, 70, 71, 72}
        end
        for index, value in ipairs(self.clothes) do
            if index > self.scrollClothes and self.counter < 8 then
                if self:isInBox(self.sizeX/2-130+self.counterX, self.sizeY/2-15+self.counterY, 125, 150) then
                    self:roundedRectangle(self.sizeX/2-130+self.counterX, self.sizeY/2-15+self.counterY, 125, 150, tocolor(20,20,20,245))
                    dxDrawImage(self.sizeX/2-105+self.counterX, self.sizeY/2+self.counterY, 74, 74, ':account/img/'..value..'.png')
                    dxDrawText('Kıyafet: '..value, self.sizeX/2-95+self.counterX, self.sizeY/2+100+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                        self.click = getTickCount()
                        triggerServerEvent('duty.clothes', localPlayer, value)
                    end
                else
                    self:roundedRectangle(self.sizeX/2-130+self.counterX, self.sizeY/2-15+self.counterY, 125, 150, tocolor(25,25,25,245))
                    dxDrawImage(self.sizeX/2-105+self.counterX, self.sizeY/2+self.counterY, 74, 74, ':account/img/'..value..'.png')
                    dxDrawText('Kıyafet: '..value, self.sizeX/2-95+self.counterX, self.sizeY/2+100+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                end
                self.counterX = self.counterX + 145
                self.counter = self.counter + 1
                if self.counter == 4 then
                    self.counterY = 165
                    self.counterX = 0
                end
            end
        end
    elseif self.selected == 'Weapons' then
        self.counter = 0
        self.counterX = 0
        self.counterY = 0
        if localPlayer:getData('faction') == 1 or localPlayer:getData('faction') == 78 then
            self.weapons = {3, 24, 29, 31,41}
        elseif localPlayer:getData('faction') == 2 then
            self.weapons = {14}
        end
        for index, value in ipairs(self.weapons) do
            if index > self.scrollWeapons and self.counter < 8 then
                if self:isInBox(self.sizeX/2-130+self.counterX, self.sizeY/2-15+self.counterY, 125, 150) then
                    self:roundedRectangle(self.sizeX/2-130+self.counterX, self.sizeY/2-15+self.counterY, 125, 150, tocolor(20,20,20,245))
                    dxDrawImage(self.sizeX/2-133+self.counterX, self.sizeY/2+self.counterY, 125, 70, 'components/weapons/weapon'..value..'.png')
                    dxDrawText(getWeaponNameFromID(value), self.sizeX/2-85+self.counterX, self.sizeY/2+85+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                        self.click = getTickCount()
                        triggerServerEvent('duty.weapons', localPlayer, value)
                    end
                else
                    self:roundedRectangle(self.sizeX/2-130+self.counterX, self.sizeY/2-15+self.counterY, 125, 150, tocolor(25,25,25,245))
                    dxDrawImage(self.sizeX/2-133+self.counterX, self.sizeY/2+self.counterY, 125, 70, 'components/weapons/weapon'..value..'.png')
                    dxDrawText(getWeaponNameFromID(value), self.sizeX/2-85+self.counterX, self.sizeY/2+85+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                end
                self.counterX = self.counterX + 145
                self.counter = self.counter + 1
                if self.counter == 4 then
                    self.counterY = 165
                    self.counterX = 0
                end
            end
        end
    elseif self.selected == 'Equipments' then
        self.counter = 0
        self.counterX = 0
        self.counterY = 0
        if localPlayer:getData('faction') == 1 or localPlayer:getData('faction') == 78 then
            self.equipments = {
                {126, 'Görev Kemeri'},
                {6, 'Görev Telsizi'},
                {26, 'Gaz Maskesi'},
                {56, 'Kar Maskesi'},
            }
        elseif localPlayer:getData('faction') == 2 then
            self.equipments = {
                {126, 'Görev Kemeri'},
                {6, 'Görev Telsizi'},
                {26, 'Gaz Maskesi'},
            }
        end
        for index, value in ipairs(self.equipments) do
            if index > self.scrollEquipments and self.counter < 8 then
                if self:isInBox(self.sizeX/2-130+self.counterX, self.sizeY/2-15+self.counterY, 125, 150) then
                    self:roundedRectangle(self.sizeX/2-130+self.counterX, self.sizeY/2-15+self.counterY, 125, 150, tocolor(20,20,20,245))
                    dxDrawImage(self.sizeX/2-105+self.counterX, self.sizeY/2+self.counterY, 80, 55, ':items/images/'..value[1]..'.png')
                    dxDrawText(value[2], self.sizeX/2-103+self.counterX, self.sizeY/2+75+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                        self.click = getTickCount()
                        triggerServerEvent('duty.equipments', localPlayer, value[1])
                    end
                else
                    self:roundedRectangle(self.sizeX/2-130+self.counterX, self.sizeY/2-15+self.counterY, 125, 150, tocolor(25,25,25,245))
                    dxDrawImage(self.sizeX/2-105+self.counterX, self.sizeY/2+self.counterY, 80, 55, ':items/images/'..value[1]..'.png')
                    dxDrawText(value[2], self.sizeX/2-103+self.counterX, self.sizeY/2+75+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                end
                self.counterX = self.counterX + 145
                self.counter = self.counter + 1
                if self.counter == 4 then
                    self.counterY = 165
                    self.counterX = 0
                end
            end
        end
    end

end

function duty:up()
    self = duty;
    if self.active then
        if self.selected == 'Clothes' then
            if self.scrollClothes > 0 then
                self.scrollClothes = self.scrollClothes - 1
            end
        elseif self.selected == 'Weapons' then
            if self.scrollWeapons > 0 then
                self.scrollWeapons = self.scrollWeapons - 1
            end
        elseif self.selected == 'Equipments' then
            if self.scrollEquipments > 0 then
                self.scrollEquipments = self.scrollEquipments - 1
            end
        end
    end
end

function duty:down()
    self = duty;
    if self.active then
        if self.selected == 'Clothes' then
            if self.scrollClothes < #self.clothes - 8 then
                self.scrollClothes = self.scrollClothes + 1
            end
        elseif self.selected == 'Weapons' then
            if self.scrollWeapons < #self.weapons - 8 then
                self.scrollWeapons = self.scrollWeapons + 1
            end
        elseif self.selected == 'Equipments' then
            if self.scrollEquipments < #self.equipments - 8 then
                self.scrollEquipments = self.scrollEquipments + 1
            end
        end
    end
end

function duty:roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
    if (x and y and w and h) then
        if (not borderColor) then
            borderColor = tocolor(0, 0, 0, 200);
        end
        if (not bgColor) then
            bgColor = borderColor;
        end
        dxDrawRectangle(x, y, w, h, bgColor, postGUI);
        dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
        dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
        dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
        dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
    end
end

function duty:isInBox(xS,yS,wS,hS)
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

duty:create()