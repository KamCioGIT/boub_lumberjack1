local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterNetEvent('boubeur-bucheron::server:giveWood', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
	
	local randomNumber = math.random(1,100)
    if randomNumber > 80 then
        Player.Functions.RemoveItem('axe', 1)
        TriggerEvent("inventory:client:ItemBox", RSGCore.Shared.Items["axe"], "remove")
        TriggerClientEvent('RSGCore:Notify', src, 'Vous avez cassé votre hache', 'error')

    end
	
	
    local chance = math.random(1,100)
    -- reward (95% chance)
    if chance <= 95 then -- reward : 1 x wood 1 x wood2
        -- add item wood
        Player.Functions.AddItem('wood', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['wood'], "add")
        --Player.Functions.AddItem('wood2', 1)
        -- TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['wood2'], "add")
		
        -- remove item 
        --Player.Functions.RemoveItem('axe', 1)
        --TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['axe'], "remove")

    end
    -- reward (5% chance)
    if chance > 95 then -- reward : 2 x wood and 2 x wood2
        -- add item wood
        Player.Functions.AddItem('wood', 2)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['wood'], "add")
        --Player.Functions.AddItem('wood2', 2)
        --TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['wood2'], "add")
		
        -- remove item 
        --Player.Functions.RemoveItem('axe', 1)
        --TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['axe'], "remove")

    end
end)
