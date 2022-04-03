mysql = exports.mysql
Webhooks = {
	["general"] = {
		link = "https://discord.com/api/webhooks/937103684561690624/SPzQ8BOb_SDWt5IR_BoVZlFwVr1iYd6IrGTCSj-YUN7HXHP2tidJDwYYw9Ildot88JQ8",
		avatar = "", -- if u want to empty, enter nil
		username = "rol dersi"
	}
}

WebhookList = {};
WebhookDebug = false; -- true: giving debug messages // false: release mode
WebhookClass = setmetatable({
        constructor = function(self, args)
            self.username = Webhooks[args].username;
            self.link = Webhooks[args].link;
            self.avatar = Webhooks[args].avatar;
            if WebhookDebug then
                outputDebugString("DiscordWebhook: Created channel '"..args.."'");
            end;
            return self;
        end;

        send = function(self, message, embed)
            local sendOptions = {
                connectionAttempts = 3,
                connectTimeout = 5000,
                formFields = {
                    content = message:gsub("#%x%x%x%x%x%x", ""),
                    username = self.username,
                    avatar_url = self.avatar,
                    --embeds = {}, -- Will be add
                }
            };

            if embed then
                sendOptions.formFields.embed = embed;
            end;
            fetchRemote(self.link, sendOptions,
		        function(responseData)
		            if WebhookDebug then
                        outputDebugString("DiscordWebhook: "..responseData);
                    end;
                end
	        );
        end;
    }, {
    __call = function(cls, ...)
        local self = {}
        setmetatable(self, {
            __index = cls
        })

        self:constructor(...)

        return self
    end;
});

addEventHandler("onResourceStart", resourceRoot,
    function()
        for name, data in pairs(Webhooks) do
            WebhookList[name] = WebhookClass(name);
        end;
    end
);

function sendMessage(channel, message, embed)
    if WebhookList[channel] then
        WebhookList[channel]:send(message, embed);
        if WebhookDebug then
            outputDebugString("DiscordWebhook: Send message '"..message.."' from '"..channel.."' channel.");
        end;
    else
        outputDebugString("DiscordWebhook: Couldn't find the Discord Webhook Channel.");
    end;
end;
addEvent("discord.sendMessage", true);
addEventHandler("discord.sendMessage", root, sendMessage);


addEvent("alern:rol:class", true)
addEventHandler("alern:rol:class", root, function(plr, target)
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
    dbExec(mysql:getConnection(), 'UPDATE accounts SET roldersi = 1  WHERE id = '..(target:getData('account:id'))..'')
    plr:setData('rolsayi', (plr:getData('rolsayi') or 0)+1)
    dbExec(mysql:getConnection(), 'UPDATE accounts SET rolsayi = '..(plr:getData('rolsayi') or 0)..'  WHERE id = '..(plr:getData('account:id'))..'')
    target:setData('roldersi', 1)

    sendMessage('general', '**Rol Dersi Veren: '..plr.name..' - Toplam verdiği ders: '..(plr:getData('rolsayi') or 0)..'\nRol Dersi Verilen: '..target.name..'\n-----Detaylı bilgiler için tıklayınız.-----\n||Ders Verilen;\nİsim: '..target.name..'\nKullanıcı Adı: '..target:getData('account:username')..'\nSerial: '..target.serial..'\nTarih: '..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds)..'||**', embed)
	outputChatBox('[!]#ffffff '..target.name..' isimli oyuncunun rol dersini  onayladınız.', plr, 50, 50, 255, true)
	outputChatBox('[!]#ffffff '..plr.name..' isimli yetkili rol dersinizi onayladı.', target, 50, 50, 255, true)
end)
