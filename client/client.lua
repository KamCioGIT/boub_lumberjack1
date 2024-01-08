local RSGCore = exports['rsg-core']:GetCoreObject()
local spawned = false
local bees_cloud_group = "core"
local bees_cloud_name = "ent_amb_insect_bee_swarm"
local cooldownSecondsRemaining = 0

local isBusy = false
local cuttingstarted = false

---------------------------------------------------------------------------------

-- spawn beehives / bees
Citizen.CreateThread(function()
    while true do
    Wait(0)
        if spawned == false then
            for k,v in pairs(Config.TreeProps) do
                local hash = GetHashKey(v.model)
                while not HasModelLoaded(hash) do
                    Wait(10)
                    RequestModel(hash)
                end
                RequestModel(hash)
                beehive = CreateObject(hash, v.coords -1, true, false, false)
                SetEntityHeading(beehive, v.heading)
                SetEntityAsMissionEntity(beehive, true)
                PlaceObjectOnGroundProperly(beehive, true)
                FreezeEntityPosition(beehive, true)
                Citizen.InvokeNative(0xA10DB07FC234DD12, bees_cloud_group)
                bees = Citizen.InvokeNative(0xBA32867E86125D3A , bees_cloud_name, v.coords, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                spawned = true
            end
        end
    end
end)

---------------------------------------------------------------------------------

-- Target

exports['rsg-target']:AddTargetModel(Config.TreeProps, {
    options = {
        {
            type = "client",
            event = 'boubeur-bucheron:client:checkBois',
            icon = "fa-regular fa-tree",
            label = 'Couper du bois',
            distance = 2.0
        }
    }
})


---------------------------------------------------------------------------------

-- couper le bois
RegisterNetEvent('boubeur-bucheron:client:checkBois')
AddEventHandler('boubeur-bucheron:client:checkBois', function()
    if isBusy == false and cooldownSecondsRemaining == 0 then
        local hasItem = RSGCore.Functions.HasItem('axe', 1)
        if hasItem then
            isBusy = true
            local player = PlayerPedId()
			
			if Config.ProgressBar then
            RSGCore.Functions.Progressbar("Coupage-Bois", 'Coupage du bois ...', 30000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
            end)
        end
			
            cuttingstarted = true
            TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('EA_WORLD_HUMAN_TREE_CHOP_NEW'), -1, true, false, false, false)
            Wait(Config.CheckTime)  ------ default 30000 config
			ClearPedTasksImmediately(PlayerPedId(-1))
			TriggerServerEvent('RSGCore:Notify', 'Vous avez récolté du bois','success')
            SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
            TriggerServerEvent('boubeur-bucheron::server:giveWood') ---- donne le bois server.lua
            PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
            cooldownTimer() ----- cooldown timer
            isBusy = false
			cuttingstarted = false
        else
            RSGCore.Functions.Notify('Vous n\'avez pas de hache', 'error')
        end
    else
        RSGCore.Functions.Notify('Vous reprenez votre souffle !', 'primary')
    end
end)

---------------------------------------------------------------------------------

-- cooldown timer
function cooldownTimer()
    cooldownSecondsRemaining = Config.Cooldown
    Citizen.CreateThread(function()
        while cooldownSecondsRemaining > 0 do
            Wait(100)  ---- cooldown
            cooldownSecondsRemaining = cooldownSecondsRemaining - 1
            --print(cooldownSecondsRemaining)
        end
    end)
end

---------------------------------------------------------------------------------

--- effect Guêpes
Citizen.CreateThread(function()
    while true do
        Wait(3000)
        for k,v in pairs(Config.TreeProps) do
            if IsEntityAtCoord(PlayerPedId(), v.coords, 3.0, 3.0, 3.0, 0, 1, 0) then
                local ped = PlayerPedId()
                local health = GetEntityHealth(ped)
                if health > 0 then 
                    SetEntityHealth(ped, health - Config.BeeSting)
                    PlayPain(ped, 9, 1, true, true)
                end
            end
        end
    end
end)

---------------------------------------------------------------------------------
