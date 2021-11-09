PlayerData = {}
pedsSpawned = false
haveMessaged = false

ESX = nil

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
} 

-------------------------------------
-- isEmployed()
-- Checks if the players' job is "casino"
-------------------------------------
function isEmployed()
    PlayerData = ESX.GetPlayerData()
    local isEmployed = false
    if PlayerData.job.name == "casino" then
        isEmployed = true
    end
    return isEmployed
end

-------------------------------------
-- isBoss()
-- Checks if the players' job is "casino",
-- Then Checks if they hold the boss or viceboss ranks
-------------------------------------
function isBoss()
    PlayerData = ESX.GetPlayerData()
        local isBoss = false
        if PlayerData.job.name == "casino" then
            if PlayerData.job.grade_name == "boss" or PlayerData.job.grade_name == "viceboss" then
                isBoss = true
            end
        end
        return isBoss
end
-------------------------------------
--
-- EVENT HANDLERS
--
-------------------------------------

-------------------------------------
-- esx:playerLoaded
-- Loads playerData
-- @param xPlayer - The Player
-------------------------------------
RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
end)

-------------------------------------
-- esx:setJob
-- Loads player job from their PlayerData
-- @param job - the job
-------------------------------------
RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    PlayerData.job = job
end)

-----------------------------------------------------------------------
-- LCRP_CasinoJob:GoTo
-- Teleports to the previously selected location.
-- @param data = string, contains the location we want to teleport to.
-----------------------------------------------------------------------
RegisterNetEvent("LCRP_CasinoJob:GoTo")
AddEventHandler("LCRP_CasinoJob:GoTo", function(data)
    if isEmployed() then
        for i, j in pairs(Config.TPLocations) do
            if j.label then
                if j.label == data.destination then
                    ESX.Game.Teleport(PlayerPedId(), {x = j.coords.x, y = j.coords.y, z = j.coords.z, heading = j.heading})
                    SetGameplayCamRelativeHeading(j.camHeading)
                end
            else
                exports['mythic_notify']:DoHudText('error', 'Label was null, contact a developer. This *should* never happen.')
            end
        end
    end
end)
-----------------------------------------
-- LCRP_CasinoJob:openBossMenu
-- Open Society Boss Menu.
-----------------------------------------
RegisterNetEvent("LCRP_CasinoJob:openBossMenu")    
AddEventHandler("LCRP_CasinoJob:openBossMenu", function()
    if isBoss() then
        TriggerEvent('esx_society:openBossMenu', 'casino')
    else
        expotrs['mythic_notify']:DoHudText('error', _U('wrong_perms'))
    end
end)

-----------------------------------------
-- LCRP_CasinoJob:openStaffMenu
-- Open Society Staff Menu.
-----------------------------------------
RegisterNetEvent("LCRP_CasinoJob:openStaffMenu")    
AddEventHandler("LCRP_CasinoJob:openStaffMenu", function()
    if isEmployed() then
        OpenVaultMenu()
    else
        expotrs['mythic_notify']:DoHudText('error', _U('wrong_perms'))
    end
end)

-----------------------------------------
-- LCRP_CasinoJob:getVehicle
-- Opens Society Garage.
-----------------------------------------
RegisterNetEvent('LCRP_CasinoJob:getVehicle')
AddEventHandler('LCRP_CasinoJob:getVehicle', function()
    if isEmployed() then
        local elements = {}
        for i, j in pairs(Config.Vehicles) do
            table.insert(elements, {label = j.label , value = j.code})
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'choose_vehicle', {
            title = _U('garage'),
            align = 'top-right',
            elements = elements
        }, function(data, menu)
            local sCode = tostring(data.current.value)
            ESX.Game.SpawnVehicle(sCode, Config.Garage.LoadPos, Config.Garage.Heading, function(vehicle)
                local playerPed = PlayerPedId()
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                ESX.UI.Menu.CloseAll()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end
end)

-----------------------------------------
-- LCRP_CasinoJob:deleteVehicle
-- Deletes closest Vehicle
-----------------------------------------
RegisterNetEvent('LCRP_CasinoJob:deleteVehicle')
AddEventHandler('LCRP_CasinoJob:deleteVehicle', function()
    if isEmployed() then
        local coords = GetEntityCoords(PlayerPedId())
        local car = ESX.Game.GetClosestVehicle(coords, modelFilter)
        ESX.Game.DeleteVehicle(car)
    end
end)

-------------------------------------
--
--  FUNCTIONS
--
-------------------------------------

----------------------------------------------
-- cleanPlayer
-- removes blood and injuries from the player
-- @param playerPed - the ped to be cleaned
----------------------------------------------
function cleanPlayer(playerPed)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
    ResetPedMovementClipset(playerPed, 0)
end

-------------------------------------
-- OpenVaultMenu
-- Opens the society storage
--
-------------------------------------
function OpenVaultMenu()
    local elements = {
        {label = _U('get_stock'), value = 'get_stock'},
        {label = _U('put_stock'), value = 'put_stock'},
    }
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vault', {
        title = _U('vault'),
        align = 'top-right',
        elements = elements,    
    }, function(data, menu)
    if data.current.value == 'get_stock' then
        OpenGetStocksMenu()
    elseif data.current.value == 'put_stock' then
        OpenPutStocksMenu()
    end
    end, function(data, menu)
        menu.close()
    end)
end

-------------------------------------
-- OpenGetStocksMenu
-- Displays a list of items in 
-- the society storage and allows 
-- the player to withdraw them.
-------------------------------------
function OpenGetStocksMenu()
    ESX.TriggerServerCallback('LCRP_CasinoJob:getStockItems', function(items)
        local elements = {}
        for i, j in ipairs(items) do
            if j.count ~= 0 then
                if j.label then
                    table.insert(elements, {label = 'x' .. j.count .. ' ' .. j.label, value = j.name})
                end
            end
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            title = _U('vault'),
            align = 'top-right',
            elements = elements
        }, function(data, menu)
            local iName = data.current.value
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count_dialog', {
                title = _U('quantity')
            }, function(data2, menu2)
                local count = tonumber(data2.value)
                if not count then
                    exports['mythic_notify']:DoHudText('error', _U('invalid_amount'))
                else
                    TriggerServerEvent('LCRP_CasinoJob:getStockItem', iName, count)
                    ESX.UI.Menu.CloseAll()
                    OpenGetStocksMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

-------------------------------------
-- OpenGetStocksMenu
-- Displays a list of items in 
-- the players' inventory
-- And allows them to be stored
-------------------------------------
function OpenPutStocksMenu()
    ESX.TriggerServerCallback('LCRP_CasinoJob:getPlayerInventory', function(inventory)
        local elements = {}
        for i, j in pairs(inventory.items) do
            if j.count > 0 then
                table.insert(elements, {label = j.label .. " x" .. j.count, type = "item_standard", value = j.name})
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            title = _U('vault'),
            align = "top-right",
            elements = elements
        }, function(data, menu)
            local iName = data.current.value
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count_dialog', {
                title = _U('quantity')
            }, function(data2, menu2)
                local count = tonumber(data2.value)
                if not count then
                    exports['mythic_notify']:DoHudText('error', _U('invalid_amount'))
                else
                    ESX.UI.Menu.CloseAll()
                    TriggerServerEvent('LCRP_CasinoJob:putStockItems', iName, count)
                end
            end, function(data2,menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

-------------------------------------
-- 
-- THREADS
--
-------------------------------------

-------------------------------------
-- ESX Thread
-------------------------------------
Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
end)

-- Spawn Peds
Citizen.CreateThread(function()
    if Config.SpawnPeds then
        for i, j in pairs(Config.Peds) do
            RequestModel(GetHashKey(j.hash))
            while not HasModelLoaded(GetHashKey(j.hash)) do
                Wait(1)
            end
            local npc = CreatePed(4, j.hash, j.x, j.y, j.z, j.heading, false, true)

            FreezeEntityPosition(npc, true)	
            SetEntityHeading(npc, j.heading)
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
        end
    end
end)

-------------------------------------
-- Q-target
-------------------------------------
Citizen.CreateThread(function()
    -- Vault / Boss Ped
    local vaultPed = {
        `a_f_y_business_01`
    }
    exports['qtarget']:AddTargetModel(vaultPed, {
        options = {
            {
                event = "LCRP_CasinoJob:openBossMenu",
                icon = "fas fa-clipboard",
                label = _U('open_boss_menu')
            },
            {
                event = "LCRP_CasinoJob:openStaffMenu",
                icon = "fas fa-clipboard",
                label = _U('open_staff_menu')
            }
        },
        job = "casino",
        distance = 2.0,
    })
    -- Lifts
    local liftPed = {
        `s_m_y_valet_01`
    }
    exports['qtarget']:AddTargetModel(liftPed, {
        options = {
            {
                event = "LCRP_CasinoJob:GoTo", --find boss menu event, add permission check
                icon = "fas fa-clipboard-list",
                label = "Go to CCTV Room",
                destination = "cctv",
            },
            {
                event = "LCRP_CasinoJob:GoTo", -- Open Employee menu
                icon = "fas fa-clipboard-list",
                label = "Go to lower level Vault",
                destination = "vault",
            },
            {
                event = "LCRP_CasinoJob:GoTo", -- Open Employee menu
                icon = "fas fa-clipboard-list",
                label = "Go to management lower lift",
                destination = "lower",
            },
            {
                event = "LCRP_CasinoJob:GoTo", -- Open Employee menu
                icon = "fas fa-clipboard-list",
                label = "Go To Managers Office",
                destination = "office",
            },
            {
                event = "LCRP_CasinoJob:GoTo", -- Open Employee menu
                icon = "fas fa-clipboard-list",
                label = "Go to Rooftop",
                destination = "roof",
            },
            {
                event = "LCRP_CasinoJob:GoTo", -- Open Employee menu
                icon = "fas fa-clipboard-list",
                label = "Go to Penthouse",
                destination = "pent",
            },
            {
                event = "LCRP_CasinoJob:GoTo", -- Open Employee menu
                icon = "fas fa-clipboard-list",
                label = "Go to Garage",
                destination = "garage",
            },
        },
        job = 'casino',
        distance = 2.0,
    })
--[[     exports['qtarget']:AddBoxZone("CasinoGarage", GarageZone, 0.5, 0.5, {
        name = "CasinoGarage",
        heading = "11.0",
        debugPoly = true,
        minZ = 81.43,
        maxZ = 81.53,
        }, {
            options = {
                {
                    event = "LCRP_CasinoJob:getVehicle",
                    icon = "fas fa-car",
                    label = "Withdraw Vehicle",
                    job = "casino",
                },
            },
        distance = 5.0,
    }) ]]
    exports['qtarget']:AddBoxZone("CasinoGarage", vector3(927.15, 23.6, 81.33), 0.8, 0.8, {
        name="CasinoGarage",
        heading=191.882,
        debugPoly=false,
        minZ= 81.0,
        maxZ= 82.0
    }, {
        options = {
        {
            event = "LCRP_CasinoJob:getVehicle",
            icon = "fas fa-car",
            label = "Withdraw Vehicle",
        },
        {
            event = "LCRP_CasinoJob:deleteVehicle",
            icon = "fas fa-car",
            label = "Store Closest Vehicle",
        },
    },
        job = {"casino"},
        distance = 6.0,
    })
end)

-------------------------------
-- Key Controls
-------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if IsControlJustReleased(0, Keys['BACKSPACE']) and isEmployed() then
            ESX.UI.Menu.CloseAll()
        end
    end
end)

-------------------------------
-- Spawn Peds
-------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local dist = #(Config.FrontDoorCoods - GetEntityCoords(PlayerPedId()))
        if dist <= 75 and pedsSpawned == false then
            TriggerEvent("LCRP_CasinoJob:spawnPeds", Config.Peds)
            break
        end
    end
end)

--[[ ---------------------------------------
--
-- Check if inside Vehicle Despawn Zone
--
---------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if isEmployed() then
            if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Garage.DelPos, true)) < Config.DelDistance then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    haveMessaged = true
                    if not haveMessaged then exports['mythic_notify']:DoHudText('inform', 'Press E to despawn vehicle') end
                    if IsControlJustReleased(0, Keys['E']) then
                        ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                        haveMessaged = false
                    end
                end
            end
        end
    end
end) ]]