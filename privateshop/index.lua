triggerServerEvent = triggerServerEvent
exports = exports
tocolor = tocolor
bindKey = bindKey
addCommandHandler = addCommandHandler
dxDrawCircle = dxDrawCircle
dxDrawRectangle = dxDrawRectangle
dxDrawText = dxDrawText
getKeyState = getKeyState
getTickCount = getTickCount
isCursorShowing = isCursorShowing
getCursorPosition = getCursorPosition
guiGetScreenSize = guiGetScreenSize
ipairs = ipairs
privateShop = {}
privateShop.__index = privateShop
privateShop.screen = Vector2(guiGetScreenSize())
privateShop.width, privateShop.height = 300, 200
privateShop.sizeX, privateShop.sizeY = (privateShop.screen.x-privateShop.width), (privateShop.screen.y-privateShop.height)
privateShop.robotoB = exports.fonts:getFont('RobotoB',15)
privateShop.roboto = exports.fonts:getFont('Roboto',11)

function privateShop:create()
    local instance = {}
    setmetatable(instance, privateShop)
    if instance:constructor() then
        return instance
    end
    return false
end

function privateShop:constructor()
    self = privateShop;

    bindKey("mouse_wheel_up", "down", self.up)
    bindKey("mouse_wheel_down", "down", self.down)
    addCommandHandler('market', self.open)
    addCommandHandler('oocmarket', self.open)
    addEventHandler('onClientCharacter', root, function(...) self:key(...) end)

    self.restrictedWeapons = {}
    for i=0, 15 do
        self.restrictedWeapons[i] = true
    end

    self.features = {
        {1, 'VIP 1 (1 Ay)', 20},
        {2, 'VIP 2 (1 Ay)', 40},
        {3, 'VIP 3 (1 Ay)', 60},
        {4, 'VIP 4 (1 Ay)', 80},
        {5, 'Karakter İsim/Cinsiyet Değişikliği', 10},
        {6, 'Karakter Slotu Arttırma', 5},
        {7, 'Hesap İsmi Değişikliği', 10},
        {8, 'Özel Plaka', 5},
        {9, 'Cam Filmi', 10},
        {10, 'Kelebek Kapı', 10},
        {11, 'Araç Slotu Arttırma', 5},
        {12, 'History Sildirme', 2},
    }

    self.vehicles = {
        -- id, araç adı, fiyat, gtamodel, owlmodel, hız, vergi
        {1, 'Audi A7', 120, 529, 1076, 260, 35},
        {2, 'Range Rover', 80, 490, 1078, 250, 25},
        {3, 'Mercedes Benz-AMG C63 S Coupe', 90, 602, 1079, 230, 25},
        {4, 'BMW M4', 70, 412, 1080, 225, 20},
        {5, 'Volvo 2020 PoloStar', 70, 402, 1081, 215, 15},
        {6, 'Passat Aşiret Paket', 100, 405, 1034, 230, 25},
        {7, 'Tofaş', 35 , 561, 1077, 220 , 15},
        {8, 'Maverik', 250 , 487, 413 , 200 , 50},
    }

    self.anims = {
        {1, 'Watch Dogs Animasyon Fiziği', 10, 'watchdogs'},
        {2, 'GTA IV Animasyon Fiziği', 5, 'gta4'},
        {3, 'GTA V Animasyon Fiziği', 5, 'gta5'},
        {4, 'SWAT Animasyon Fiziği', 3, 'swat'},
        {5, 'James Bond Animasyon Fiziği', 10, 'custom_1'},
        {6, 'Çete Animasyon Fiziği I', 15, 'custom_2'},
        {7, 'Çete Animasyon Fiziği II', 7, 'custom_8'},
        {8, 'Çete Animasyon Fiziği III', 7, 'custom_12'},
        {9, 'Animasyon Fiziği I', 7, 'custom_6'},
        {10, 'Animasyon Fiziği II', 6, 'custom_9'},
        {11, 'Kadın Yürüme Fiziği', 7, 'custom_7'},
        {12, 'Silah Tutuş Fizği', 5, 'custom_11'},
    }

    self.commandAnims = {
        {1, 'Özel Dans Animasyonları', 10, 'dance'},
    }

    self.guns = {
        {1, 'M4', 200, 31},
        {2, 'AK47', 120, 30},
        {3, 'MP5', 80, 29},
        {4, 'Shotgun', 70, 25},
        {5, 'Tec-9', 60, 32},
        {6, 'Uzi', 60, 28},
        {7, 'Deagle', 50, 24},
        {8, 'Colt45', 20, 22},
    }

    self.gunCurrentList = {
        [356] = math.ceil(250/3),
        [355] = math.ceil(90/3),
        [353] = math.ceil(65/3),
        [349] = math.ceil(65/3),
        [372] = math.ceil(65/3),
        [352] = math.ceil(55/3),
        [348] = math.ceil(50/3),
        [346] = math.ceil(30/3),
    }
end

function privateShop:render()
    self = privateShop;
    if localPlayer:getData('loggedin') == 1 then
        self:roundedRectangle(self.sizeX/2-150, self.sizeY/2-100, 600, 450, 10, tocolor(15,15,15,250))
        dxDrawText('OOC Market', self.sizeX/2-150, self.sizeY/2-107, 25, 25, tocolor(175,175,175,245), 0.65, self.robotoB)
        dxDrawText('aşşağıda seçenekler listeleniyor:', self.sizeX/2-125, self.sizeY/2-80, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
        dxDrawText('Bakiye: '..localPlayer:getData('bakiye')..'$', self.sizeX/2+365, self.sizeY/2-80, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)

        if self:isInBox(self.sizeX/2+345, self.sizeY/2+315, 75, 15) then
            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                self.click = getTickCount()
                self:open()
            end
            dxDrawText('Arayüzü Kapat', self.sizeX/2+345, self.sizeY/2+315, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
        else
            dxDrawText('Arayüzü Kapat', self.sizeX/2+345, self.sizeY/2+315, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
        end

        if self:isInBox( self.sizeX/2-110, self.sizeY/2+315, 43, 15) then
            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                self.click = getTickCount()
                self.scroll = 0
                self.selected = 'features'
                self.text = ''
                self.text2 = ''
                self.otherText = nil
                self.selectedChoice = nil
                self.selectedColor = nil
                self.selectedTable = self.features
            end
            dxDrawText('Özellikler', self.sizeX/2-110, self.sizeY/2+315, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
        else
            dxDrawText('Özellikler', self.sizeX/2-110, self.sizeY/2+315, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
        end

        if self:isInBox(self.sizeX/2-25, self.sizeY/2+315, 34, 15) then
            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                self.click = getTickCount()
                self.scroll = 0
                self.selected = 'vehicles'
                self.text = ''
                self.text2 = ''
                self.otherText = nil
                self.selectedChoice = nil
                self.selectedColor = nil
                self.selectedTable = self.vehicles
            end
            dxDrawText('Araçlar', self.sizeX/2-25, self.sizeY/2+315, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
        else
            dxDrawText('Araçlar', self.sizeX/2-25, self.sizeY/2+315, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
        end

        if self:isInBox(self.sizeX/2+50, self.sizeY/2+315, 65, 15) then
            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                self.click = getTickCount()
                self.scroll = 0
                self.selected = 'anims'
                self.text = ''
                self.text2 = ''
                self.otherText = nil
                self.selectedChoice = nil
                self.selectedColor = nil
                self.selectedTable = self.anims
            end
            dxDrawText('Animasyonlar', self.sizeX/2+50, self.sizeY/2+315, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
        else
            dxDrawText('Animasyonlar', self.sizeX/2+50, self.sizeY/2+315, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
        end

        if self:isInBox(self.sizeX/2+145, self.sizeY/2+315, 35, 15) then
            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                self.click = getTickCount()
                self.scroll = 0
                self.selected = 'guns'
                self.text = ''
                self.text2 = ''
                self.otherText = nil
                self.selectedChoice = nil
                self.selectedColor = nil
                self.selectedTable = self.guns
            end
            dxDrawText('Silahlar', self.sizeX/2+145, self.sizeY/2+315, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
        else
            dxDrawText('Silahlar', self.sizeX/2+145, self.sizeY/2+315, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
        end

        if self.selected == 'vehicles' and self.selectedChoice then
            exports["objprev"]:setAlpha(self.prevVeh, 255)
        else
            exports["objprev"]:setAlpha(self.prevVeh, 0)
        end

        if self.selected == 'features' then
            self:roundedRectangle(self.sizeX/2-135, self.sizeY/2-30, 300, 285, 10, tocolor(20,20,20,245))
            dxDrawText('İsim', self.sizeX/2-110, self.sizeY/2-25, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
            dxDrawText('Fiyat', self.sizeX/2+105, self.sizeY/2-25, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
            self.counter = 0
            self.counterY = 0
            for index, value in ipairs(self.features) do
                if index > self.scroll and self.counter < 10 then
                    if self.selectedChoice == index then
                        self:roundedRectangle(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20, 10, tocolor(7,7,7,235))
                        dxDrawText(value[2], self.sizeX/2-125, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        dxDrawText(''..value[3]..'$', self.sizeX/2+105, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if self:isInBox(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20) then
                            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                                self.click = getTickCount()
                                self.selectedChoice = nil
                            end
                        end
                    else
                        if self:isInBox(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20) then
                            self:roundedRectangle(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20, 10, tocolor(7,7,7,235))
                            dxDrawText(value[2], self.sizeX/2-125, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                            dxDrawText(''..value[3]..'$', self.sizeX/2+105, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                                self.click = getTickCount()
                                self.selectedChoice = index
                                self.activeText = nil
                                if value[1] == 5 then
                                    self.text = 'İsim'
                                    self.text2 = 'Cinsiyet'
                                elseif value[1] == 8 then
                                    self.text = 'Araç ID'
                                    self.text2 = 'Plaka'
                                else
                                    self.text = ''
                                    self.text2 = ''
                                end
                            end
                        else
                            self:roundedRectangle(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20, 10, tocolor(15,15,15,235))
                            dxDrawText(value[2], self.sizeX/2-125, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                            dxDrawText(''..value[3]..'$', self.sizeX/2+105, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        end
                    end
                    self.counter = self.counter + 1
                    self.counterY = self.counterY + 25
                end
            end
            if self.selectedChoice then
                self.table = self.selectedTable[self.selectedChoice]
                if self.table[1] <= 4 then
                    if tonumber(self.text) then
                        self.vipPrice = self.table[3] / 30 * tonumber(self.text)
                    end
                    dxDrawText('Satın Alma Detayları:', self.sizeX/2+185, self.sizeY/2-20, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    self:roundedRectangle(self.sizeX/2+185, self.sizeY/2, 250, 75, 10, tocolor(20,20,20,245))
                    dxDrawText('Kaç günlük Vıp '..self.table[1]..' istiyorsunuz?', self.sizeX/2+195, self.sizeY/2+10, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if self:isInBox(self.sizeX/2+190, self.sizeY/2+30, 240, 25) then    
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(7,7,7,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.activeText = true
                            self.text = ''
                        end
                    else
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(15,15,15,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    end
                    if self:isInBox(self.sizeX/2+340, self.sizeY/2+100, 75, 15) then
                        dxDrawText('Satın Al ('..(self.vipPrice or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            triggerServerEvent('privateshop.vip', localPlayer, self.table[3], self.text, self.vipPrice)
                            self:open()
                        end
                    else
                        dxDrawText('Satın Al ('..(self.vipPrice or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    end
                elseif self.table[1] == 5 then
                    dxDrawText('Satın Alma Detayları:', self.sizeX/2+185, self.sizeY/2-20, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    self:roundedRectangle(self.sizeX/2+185, self.sizeY/2, 250, 100, 10, tocolor(20,20,20,245))
                    dxDrawText('Karakterinizin yeni isim/cinsiyeti?', self.sizeX/2+195, self.sizeY/2+10, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if self:isInBox(self.sizeX/2+190, self.sizeY/2+30, 240, 25) then    
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(7,7,7,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.activeText = true
                            self.otherText = nil
                            self.text = ''
                        end
                    else
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(15,15,15,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    end
                    if self:isInBox(self.sizeX/2+190, self.sizeY/2+60, 240, 25) then    
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+60, 240, 25, 10, tocolor(7,7,7,235))
                        dxDrawText(self.text2, self.sizeX/2+200, self.sizeY/2+65, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.activeText = true
                            self.otherText = true
                            self.text2 = ''
                        end
                    else
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+60, 240, 25, 10, tocolor(15,15,15,235))
                        dxDrawText(self.text2, self.sizeX/2+200, self.sizeY/2+65, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    end
                    if self:isInBox(self.sizeX/2+340, self.sizeY/2+120, 75, 15) then
                        dxDrawText('Satın Al ('..(self.table[3] or 0)..'$)', self.sizeX/2+340, self.sizeY/2+120, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            triggerServerEvent('privateshop.charnamegender', localPlayer, self.table[3], self.text, self.text2)
                            self:open()
                        end
                    else
                        dxDrawText('Satın Al ('..(self.table[3] or 0)..'$)', self.sizeX/2+340, self.sizeY/2+120, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    end
                elseif self.table[1] == 6 then
                    if tonumber(self.text) then
                        self.slotPrice = self.table[3] * tonumber(self.text)
                    end
                    dxDrawText('Satın Alma Detayları:', self.sizeX/2+185, self.sizeY/2-20, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    self:roundedRectangle(self.sizeX/2+185, self.sizeY/2, 250, 75, 10, tocolor(20,20,20,245))
                    dxDrawText('Kaç adet karakter slotu almak istiyorsunuz?', self.sizeX/2+195, self.sizeY/2+10, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if self:isInBox(self.sizeX/2+190, self.sizeY/2+30, 240, 25) then    
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(7,7,7,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.activeText = true
                            self.text = ''
                        end
                    else
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(15,15,15,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    end
                    if self:isInBox(self.sizeX/2+340, self.sizeY/2+100, 75, 15) then
                        dxDrawText('Satın Al ('..(self.slotPrice or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            triggerServerEvent('privateshop.charslot', localPlayer, self.slotPrice, self.text)
                            self:open()
                        end
                    else
                        dxDrawText('Satın Al ('..(self.slotPrice or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    end
                elseif self.table[1] == 7 then
                    dxDrawText('Satın Alma Detayları:', self.sizeX/2+185, self.sizeY/2-20, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    self:roundedRectangle(self.sizeX/2+185, self.sizeY/2, 250, 75, 10, tocolor(20,20,20,245))
                    dxDrawText('Yeni hesap isminiz ne olsun?', self.sizeX/2+195, self.sizeY/2+10, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if self:isInBox(self.sizeX/2+190, self.sizeY/2+30, 240, 25) then    
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(7,7,7,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.activeText = true
                            self.text = ''
                        end
                    else
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(15,15,15,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    end
                    if self:isInBox(self.sizeX/2+340, self.sizeY/2+100, 75, 15) then
                        dxDrawText('Satın Al ('..(self.table[3] or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            triggerServerEvent('privateshop.setusername', localPlayer, self.table[3], self.text)
                            self:open()
                        end
                    else
                        dxDrawText('Satın Al ('..(self.table[3] or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    end
                elseif self.table[1] == 8 then
                    dxDrawText('Satın Alma Detayları:', self.sizeX/2+185, self.sizeY/2-20, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    self:roundedRectangle(self.sizeX/2+185, self.sizeY/2, 250, 100, 10, tocolor(20,20,20,245))
                    dxDrawText('Plaka değiştireceğiniz aracın id/plakası?', self.sizeX/2+195, self.sizeY/2+10, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if self:isInBox(self.sizeX/2+190, self.sizeY/2+30, 240, 25) then    
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(7,7,7,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.activeText = true
                            self.otherText = nil
                            self.text = ''
                        end
                    else
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(15,15,15,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    end
                    if self:isInBox(self.sizeX/2+190, self.sizeY/2+60, 240, 25) then    
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+60, 240, 25, 10, tocolor(7,7,7,235))
                        dxDrawText(self.text2, self.sizeX/2+200, self.sizeY/2+65, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.activeText = true
                            self.otherText = true
                            self.text2 = ''
                        end
                    else
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+60, 240, 25, 10, tocolor(15,15,15,235))
                        dxDrawText(self.text2, self.sizeX/2+200, self.sizeY/2+65, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    end
                    if self:isInBox(self.sizeX/2+340, self.sizeY/2+120, 75, 15) then
                        dxDrawText('Satın Al ('..(self.table[3] or 0)..'$)', self.sizeX/2+340, self.sizeY/2+120, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            triggerServerEvent('privateshop.vehplate', localPlayer, self.table[3], self.text, self.text2)
                            self:open()
                        end
                    else
                        dxDrawText('Satın Al ('..(self.table[3] or 0)..'$)', self.sizeX/2+340, self.sizeY/2+120, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    end
                elseif self.table[1] == 9 then
                    dxDrawText('Satın Alma Detayları:', self.sizeX/2+185, self.sizeY/2-20, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    self:roundedRectangle(self.sizeX/2+185, self.sizeY/2, 250, 75, 10, tocolor(20,20,20,245))
                    dxDrawText('Cam filmi yaptırmak istediğiniz araç id?', self.sizeX/2+195, self.sizeY/2+10, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if self:isInBox(self.sizeX/2+190, self.sizeY/2+30, 240, 25) then    
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(7,7,7,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.activeText = true
                            self.text = ''
                        end
                    else
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(15,15,15,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    end
                    if self:isInBox(self.sizeX/2+340, self.sizeY/2+100, 75, 15) then
                        dxDrawText('Satın Al ('..(self.table[3] or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            triggerServerEvent('privateshop.vehtint', localPlayer, self.table[3], self.text)
                            self:open()
                        end
                    else
                        dxDrawText('Satın Al ('..(self.table[3] or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    end
                elseif self.table[1] == 10 then
                    dxDrawText('Satın Alma Detayları:', self.sizeX/2+185, self.sizeY/2-20, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    self:roundedRectangle(self.sizeX/2+185, self.sizeY/2, 250, 75, 10, tocolor(20,20,20,245))
                    dxDrawText('Kelebek kapı yaptırmak istediğiniz araç id?', self.sizeX/2+195, self.sizeY/2+10, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if self:isInBox(self.sizeX/2+190, self.sizeY/2+30, 240, 25) then    
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(7,7,7,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.activeText = true
                            self.text = ''
                        end
                    else
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(15,15,15,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    end
                    if self:isInBox(self.sizeX/2+340, self.sizeY/2+100, 75, 15) then
                        dxDrawText('Satın Al ('..(self.table[3] or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            triggerServerEvent('privateshop.vehdoor', localPlayer, self.table[3], self.text)
                            self:open()
                        end
                    else
                        dxDrawText('Satın Al ('..(self.table[3] or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    end
                elseif self.table[1] == 11 then
                    if tonumber(self.text) then
                        self.slotPrice = self.table[3] * tonumber(self.text)
                    end
                    dxDrawText('Satın Alma Detayları:', self.sizeX/2+185, self.sizeY/2-20, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    self:roundedRectangle(self.sizeX/2+185, self.sizeY/2, 250, 75, 10, tocolor(20,20,20,245))
                    dxDrawText('Kaç adet araç slotu almak istiyorsunuz?', self.sizeX/2+195, self.sizeY/2+10, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if self:isInBox(self.sizeX/2+190, self.sizeY/2+30, 240, 25) then    
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(7,7,7,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.activeText = true
                            self.text = ''
                        end
                    else
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(15,15,15,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    end
                    if self:isInBox(self.sizeX/2+340, self.sizeY/2+100, 75, 15) then
                        dxDrawText('Satın Al ('..(self.slotPrice or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            triggerServerEvent('privateshop.vehslot', localPlayer, self.slotPrice, self.text)
                            self:open()
                        end
                    else
                        dxDrawText('Satın Al ('..(self.slotPrice or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    end
                elseif self.table[1] == 12 then
                    if tonumber(self.text) then
                        self.slotPrice = self.table[3] * tonumber(self.text)
                    end
                    dxDrawText('Satın Alma Detayları:', self.sizeX/2+185, self.sizeY/2-20, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    self:roundedRectangle(self.sizeX/2+185, self.sizeY/2, 250, 75, 10, tocolor(20,20,20,245))
                    dxDrawText('Kaç adet history sildirmek istiyorsunuz?', self.sizeX/2+195, self.sizeY/2+10, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if self:isInBox(self.sizeX/2+190, self.sizeY/2+30, 240, 25) then    
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(7,7,7,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.activeText = true
                            self.text = ''
                        end
                    else
                        self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30, 240, 25, 10, tocolor(15,15,15,235))
                        dxDrawText(self.text, self.sizeX/2+200, self.sizeY/2+35, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    end
                    if self:isInBox(self.sizeX/2+340, self.sizeY/2+100, 75, 15) then
                        dxDrawText('Satın Al ('..(self.slotPrice or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            triggerServerEvent('privateshop.delhistory', localPlayer, self.slotPrice, self.text)
                            self:open()
                        end
                    else
                        dxDrawText('Satın Al ('..(self.slotPrice or 0)..'$)', self.sizeX/2+340, self.sizeY/2+100, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                    end
                end
            end
        elseif self.selected == 'vehicles' then
            self:roundedRectangle(self.sizeX/2-135, self.sizeY/2-30, 300, 285, 10, tocolor(20,20,20,245))
            dxDrawText('İsim', self.sizeX/2-110, self.sizeY/2-25, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
            dxDrawText('Fiyat', self.sizeX/2+105, self.sizeY/2-25, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
            self.counter = 0
            self.counterY = 0
            for index, value in ipairs(self.vehicles) do
                if index > self.scroll and self.counter < 10 then
                    if self.selectedChoice == index then
                        self:roundedRectangle(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20, 10, tocolor(7,7,7,235))
                        dxDrawText(value[2], self.sizeX/2-125, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        dxDrawText(''..value[3]..'$', self.sizeX/2+105, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if self:isInBox(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20) then
                            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                                self.click = getTickCount()
                                self.veh.model = 565
                                self.selectedChoice = nil
                            end
                        end
                    else
                        if self:isInBox(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20) then
                            self:roundedRectangle(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20, 10, tocolor(7,7,7,235))
                            dxDrawText(value[2], self.sizeX/2-125, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                            dxDrawText(''..value[3]..'$', self.sizeX/2+105, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                                self.click = getTickCount()
                                self.veh.model = value[4]
                                self.selectedChoice = index
                            end
                        else
                            self:roundedRectangle(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20, 10, tocolor(15,15,15,235))
                            dxDrawText(value[2], self.sizeX/2-125, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                            dxDrawText(''..value[3]..'$', self.sizeX/2+105, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        end
                    end
                    self.counter = self.counter + 1
                    self.counterY = self.counterY + 25
                end
            end
            if self.selectedChoice then
                self.colors = {
                    {1, 255, 0, 0},
                    {2, 0, 255, 0},
                    {3, 0, 0, 255},
                    {4, 255, 255, 255},
                    {5, 0, 0, 0},
                }
                self.colorX = 0
                for i=1, 5 do
                    if i == self.selectedColor then
                        for k, v in ipairs(self.colors) do
                            if i == v[1] then
                                self.r, self.g, self.b = v[2], v[3], v[4]
                            end
                        end
                        if self.r > 0 then
                            self.r = self.r - 125
                        end
                        if self.g > 0 then
                            self.g = self.g - 125
                        end
                        if self.b > 0 then
                            self.b = self.b - 125
                        end
                        if self.r == 0 and self.g == 0 and self.b == 0 then
                            self.r, self.g, self.b = 7, 7, 7
                        end
                        if self:isInBox(self.sizeX/2+210+self.colorX, self.sizeY/2+155, 30, 30) then
                            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                                self.click = getTickCount()
                                self.selectedColor = nil
                            end
                        end
                        self:roundedRectangle(self.sizeX/2+210+self.colorX, self.sizeY/2+155, 30, 30, 15, tocolor(self.r,self.g,self.b,245))
                    else
                        for k, v in ipairs(self.colors) do
                            if i == v[1] then
                                self.r, self.g, self.b = v[2], v[3], v[4]
                            end
                        end
                        if self:isInBox(self.sizeX/2+210+self.colorX, self.sizeY/2+155, 30, 30) then
                            if self.r > 0 then
                                self.r = self.r - 125
                            end
                            if self.g > 0 then
                                self.g = self.g - 125
                            end
                            if self.b > 0 then
                                self.b = self.b - 125
                            end
                            if self.r == 0 and self.g == 0 and self.b == 0 then
                                self.r, self.g, self.b = 7, 7, 7
                            end
                            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                                self.click = getTickCount()
                                self.selectedColor = i
                                self.veh:setColor(self.r, self.g, self.b)
                            end
                            self:roundedRectangle(self.sizeX/2+210+self.colorX, self.sizeY/2+155, 30, 30, 15, tocolor(self.r,self.g,self.b,245))
                        else
                            self:roundedRectangle(self.sizeX/2+210+self.colorX, self.sizeY/2+155, 30, 30, 15, tocolor(self.r,self.g,self.b,245))
                        end
                    end
                    self.colorX = self.colorX + 40
                end
                self.table = self.selectedTable[self.selectedChoice]
                dxDrawText('Azami Hız: '..self.table[6]..'kmh / Saatlik Vergi: '..self.table[7]..'$', self.sizeX/2+200, self.sizeY/2+115, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                if self:isInBox(self.sizeX/2+365, self.sizeY/2+290, 35, 15) then
                    if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                        self.click = getTickCount()
                        if self.selectedColor then
                            for index, value in ipairs(self.colors) do
                                if self.selectedColor == value[1] then
                                    triggerServerEvent("privateshop.veh", localPlayer, self.table[3], self.table[4], self.table[5], value[2], value[3], value[4])
                                    self:open()
                                end
                            end
                        else
                            outputChatBox('[!]#D0D0D0 Bir renk seçimi yapmanız gerekiyor!',195,184,116,true)
                        end
                    end
                    dxDrawText('Satın Al', self.sizeX/2+365, self.sizeY/2+290, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                else
                    dxDrawText('Satın Al', self.sizeX/2+365, self.sizeY/2+290, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                end
            end
        elseif self.selected == 'anims' then
            self:roundedRectangle(self.sizeX/2-135, self.sizeY/2-30, 300, 285, 10, tocolor(20,20,20,245))
            dxDrawText('İsim', self.sizeX/2-110, self.sizeY/2-25, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
            dxDrawText('Fiyat', self.sizeX/2+105, self.sizeY/2-25, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
            self.counter = 0
            self.counterY = 0
            for index, value in ipairs(self.anims) do
                if index > self.scroll and self.counter < 10 then
                    if self.selectedChoice == index then
                        self:roundedRectangle(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20, 10, tocolor(7,7,7,235))
                        dxDrawText(value[2], self.sizeX/2-125, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        dxDrawText(''..value[3]..'$', self.sizeX/2+105, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if self:isInBox(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20) then
                            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                                self.click = getTickCount()
                                self.selectedChoice = nil
                            end
                        end
                    else
                        if self:isInBox(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20) then
                            self:roundedRectangle(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20, 10, tocolor(7,7,7,235))
                            dxDrawText(value[2], self.sizeX/2-125, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                            dxDrawText(''..value[3]..'$', self.sizeX/2+105, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                            if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                                self.click = getTickCount()
                                self.selectedChoice = index
                            end
                        else
                            self:roundedRectangle(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20, 10, tocolor(15,15,15,235))
                            dxDrawText(value[2], self.sizeX/2-125, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                            dxDrawText(''..value[3]..'$', self.sizeX/2+105, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        end
                    end
                    self.counter = self.counter + 1
                    self.counterY = self.counterY + 25
                end
            end
            dxDrawText('Kodlu Animasyonlar', self.sizeX/2+185, self.sizeY/2-20, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
            self:roundedRectangle(self.sizeX/2+185, self.sizeY/2, 250, 175, 10, tocolor(20,20,20,245))
            dxDrawText('İsim', self.sizeX/2+210, self.sizeY/2+5, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
            dxDrawText('Fiyat', self.sizeX/2+380, self.sizeY/2+5, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
            self.counter = 0
            self.counterY = 0
            if self.selectedChoice then
                if self:isInBox(self.sizeX/2+365, self.sizeY/2+290, 35, 15) then
                    if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                        self.click = getTickCount()
                        self.table = self.selectedTable[self.selectedChoice]
                        triggerServerEvent("privateshop.anim", localPlayer, self.table[3], self.table[4])
                        self:open()
                    end
                    dxDrawText('Satın Al', self.sizeX/2+365, self.sizeY/2+290, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                else
                    dxDrawText('Satın Al', self.sizeX/2+365, self.sizeY/2+290, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                end
            end
        elseif self.selected == 'guns' then
            self:roundedRectangle(self.sizeX/2-135, self.sizeY/2-30, 300, 285, 10, tocolor(20,20,20,245))
            dxDrawText('İsim', self.sizeX/2-110, self.sizeY/2-25, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
            dxDrawText('Fiyat', self.sizeX/2+105, self.sizeY/2-25, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
            self.counterY = 0
            for index, value in ipairs(self.guns) do
                if self.selectedChoice == index then
                    self:roundedRectangle(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20, 10, tocolor(7,7,7,235))
                    dxDrawText(value[2], self.sizeX/2-125, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    dxDrawText(''..value[3]..'$', self.sizeX/2+105, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    if self:isInBox(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20) then
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.selectedChoice = nil
                        end
                    end
                else
                    if self:isInBox(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20) then
                        self:roundedRectangle(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20, 10, tocolor(7,7,7,235))
                        dxDrawText(value[2], self.sizeX/2-125, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        dxDrawText(''..value[3]..'$', self.sizeX/2+105, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                            self.click = getTickCount()
                            self.selectedChoice = index
                        end
                    else
                        self:roundedRectangle(self.sizeX/2-130, self.sizeY/2+self.counterY, 290, 20, 10, tocolor(15,15,15,235))
                        dxDrawText(value[2], self.sizeX/2-125, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                        dxDrawText(''..value[3]..'$', self.sizeX/2+105, self.sizeY/2+2+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                    end
                end
                self.counterY = self.counterY + 25
            end
            dxDrawText('Hak Ekletme', self.sizeX/2+185, self.sizeY/2-20, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
            self:roundedRectangle(self.sizeX/2+185, self.sizeY/2, 250, 175, 10, tocolor(20,20,20,245))
            dxDrawText('Silah', self.sizeX/2+210, self.sizeY/2+5, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
            dxDrawText('Hak', self.sizeX/2+380, self.sizeY/2+5, 25, 25, tocolor(175,175,175,245), 0.85, self.roboto)
            self.counter = 0
            self.counterY = 0
            for index, value in ipairs(exports['items']:getItems(localPlayer)) do
                if value[1] == 115 and self.gunCurrentList[exports['items']:getItemModel(value[1], value[2])] then
                    if self.counter < 5 then
                        self.gunCurrent = (#tostring(exports.global:explode(":", value[2])[5])>0 and exports.global:explode(":", value[2])[5]) or 3
                        self.gunCurrent = not self.restrictedWeapons[tonumber(exports.global:explode(":", value[2])[1])] and self.gunCurrent or "-"
                        if self.selectedGun == index then
                            self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30+self.counterY, 240, 20, 10, tocolor(7,7,7,235))
                            dxDrawText(exports['items']:getItemName(value[1], value[2]), self.sizeX/2+205, self.sizeY/2+2+30+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                            dxDrawText(self.gunCurrent, self.sizeX/2+385, self.sizeY/2+2+30+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                            if self:isInBox(self.sizeX/2+190, self.sizeY/2+30+self.counterY, 240, 20) then
                                if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                                    self.click = getTickCount()
                                    self.selectedGun = nil
                                end
                            end
                        else
                            if self:isInBox(self.sizeX/2+190, self.sizeY/2+30+self.counterY, 240, 20) then
                                self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30+self.counterY, 240, 20, 10, tocolor(7,7,7,235))
                                dxDrawText(exports['items']:getItemName(value[1], value[2]), self.sizeX/2+205, self.sizeY/2+2+30+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                                dxDrawText(self.gunCurrent, self.sizeX/2+385, self.sizeY/2+2+30+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                                if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                                    self.click = getTickCount()
                                    self.selectedGun = index
                                    self.selectedGunData = self.gunCurrentList[exports['items']:getItemModel(value[1], value[2])] or 9999
                                    self.selectedGunData2 = value[3]
                                end
                            else
                                self:roundedRectangle(self.sizeX/2+190, self.sizeY/2+30+self.counterY, 240, 20, 10, tocolor(15,15,15,235))
                                dxDrawText(exports['items']:getItemName(value[1], value[2]), self.sizeX/2+205, self.sizeY/2+2+30+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                                dxDrawText(self.gunCurrent, self.sizeX/2+385, self.sizeY/2+2+30+self.counterY, 25, 25, tocolor(175,175,175,245), 0.80, self.roboto)
                            end
                        end
                        self.counter = self.counter + 1
                        self.counterY = self.counterY + 25
                    end
                end
            end
            if self.selectedGun then
                if self:isInBox(self.sizeX/2+340, self.sizeY/2+185, 75, 15) then
                    dxDrawText('Hak Ekle ('..self.selectedGunData..'$)', self.sizeX/2+340, self.sizeY/2+185, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                    if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                        self.click = getTickCount()
                        triggerServerEvent("privateshop.guncurrent", localPlayer, self.selectedGunData, self.selectedGunData2)
                        self:open()
                    end
                else
                    dxDrawText('Hak Ekle ('..self.selectedGunData..'$)', self.sizeX/2+340, self.sizeY/2+185, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                end
            end
            if self.selectedChoice then
                if self:isInBox(self.sizeX/2+365, self.sizeY/2+290, 35, 15) then
                    if getKeyState('mouse1') and self.click+800 <= getTickCount() then
                        self.click = getTickCount()
                        self.table = self.selectedTable[self.selectedChoice]
                        triggerServerEvent("privateshop.gun", localPlayer, self.table[3], self.table[4])
                        self:open()
                    end
                    dxDrawText('Satın Al', self.sizeX/2+365, self.sizeY/2+290, 25, 25, tocolor(125,125,125,245), 0.55, self.robotoB)
                else
                    dxDrawText('Satın Al', self.sizeX/2+365, self.sizeY/2+290, 25, 25, tocolor(175,175,175,245), 0.55, self.robotoB)
                end
            end
        end
    end
end

function privateShop:open()
    self = privateShop;
    if localPlayer:getData('loggedin') == 1 then
        if self.active then
            self.active = false
            self.veh:destroy()
	        exports['objprev']:destroyObjectPreview(self.prevVeh)
            showChat(true)
            showCursor(false)
            removeEventHandler('onClientRender', getRootElement(), self.render)
        else
            self.active = true
            self.click = 0
            self.scroll = 0
            self.selected = 'features'
            self.selectedChoice = nil
            self.selectedColor = nil
            self.selectedGun = nil
            self.activeText = nil
            self.text = ''
            self.text2 = ''
            self.otherText = nil
            self.selectedTable = self.features
            self.veh = createVehicle(565, 0, 0, 0)
            self.veh:setData('alpha', 255)
            self.veh:setColor(255,255,255)
            self.veh.dimension = 999
            self.prevVeh = exports["objprev"]:createObjectPreview(self.veh, 0, 0, 180, self.sizeX/2+180, self.sizeY/2-70, 450/2, 460/2, false, true)
            exports["objprev"]:setAlpha(self.prevVeh, 0)
            exports["objprev"]:setRotation(self.prevVeh,0, 0, 195)
            showChat(false)
            showCursor(true)
            addEventHandler('onClientRender', root, self.render, true, 'low-10')
        end
    end
end

function privateShop:key(character)
    self = privateShop;
    if self.active then
        if self.activeText then
            if self.otherText then
                if string.len(self.text2) > 30 then
                    self.text2 = {}
                else
                    self.text2 = ''..self.text2..''..character
                end
            else
                if string.len(self.text) > 30 then
                    self.text = {}
                else
                    self.text = ''..self.text..''..character
                end
            end
        end
    end
end

function privateShop:up()
    self = privateShop;
    if self.active then
        if self.scroll > 0 then
            self.scroll = self.scroll - 1
        end
    end
end

function privateShop:down()
    self = privateShop;
    if self.active then
        if self.scroll < #self.selectedTable - 10 then
            self.scroll = self.scroll + 1
        end
    end
end

function privateShop:roundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

function privateShop:isInBox(xS,yS,wS,hS)
    self = privateShop;
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX*self.screen.x, cursorY*self.screen.y
        if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
            return true
        else
            return false
        end
    end
end

privateShop:create()