


addEvent("trash >> giveItem", true)
addEventHandler("trash >> giveItem", root, function(player, itemID, itemValue)
	exports["vesta_global"]:giveItem(player, itemID, itemValue)
end)

addEvent("trash >> giveMoney", true)
addEventHandler("trash >> giveMoney", root, function(player, money)
	exports["vesta_global"]:giveMoney(player, money)
end)

addEvent("trash >> setPedAnimation", true)
addEventHandler("trash >> setPedAnimation", root, function(player, block, anim)
	if block and anim then 
		setPedAnimation(player, block, anim)
	else 
		setPedAnimation(player)
	end
end)