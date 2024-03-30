local QBCore = exports['qb-core']:GetCoreObject()
local currentGarage = 0
local inGarage = false
local onDuty = false
PlayerJob = {}


-- Functions
local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function GetClosestPlayer()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

    for i = 1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"][currentGarage]
    if coords then
        QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
            SetVehicleNumberPlateText(veh, "McDonald's")
            SetEntityHeading(veh, coords.w)
            exports['LegacyFuel']:SetFuel(veh, 100.0)
            closeMenuFull()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
            SetVehicleEngineOn(veh, true, true)
        end, coords, true)
    end
end

function MenuGarage(currentSelection)
    local vehicleMenu = {
        {
            header = "Garage",
            ir36enuHeader = true
        }
    }

    local authorizedVehicles = Config.AuthorizedVehicles[QBCore.Functions.GetPlayerData().job.grade.level]
    for veh, label in pairs(authorizedVehicles) do
        vehicleMenu[#vehicleMenu+1] = {
            header = label,
            txt = "",
            params = {
                event = "r36-mcdonalds:client:TakeOutVehicle",
                args = {
                    vehicle = veh,
                    currentSelection = currentSelection
                }
            }
        }
    end

    vehicleMenu[#vehicleMenu+1] = {
        header = "Close",
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }

    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

function closeMenuFull()
    exports['qb-menu']:closeMenu()
end


local function CreateDutyBlips(playerId, playerLabel, playerJob, playerLocation)
    local ped = GetPlayerPed(playerId)
    local blip = GetBlipFromEntity(ped)
    if not DoesBlipExist(blip) then
        if NetworkIsPlayerActive(playerId) then
            blip = AddBlipForEntity(ped)
        else
            blip = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
        end
        SetBlipSprite(blip, 1)
        ShowHeadingIndicatorOnBlip(blip, true)
        SetBlipRotation(blip, math.ceil(playerLocation.w))
        SetBlipScale(blip, 1.0)
        if playerJob == Config.Job then
            SetBlipColour(blip, 38)
        else
            SetBlipColour(blip, 5)
        end
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerLabel)
        EndTextCommandSetBlipName(blip)
        DutyBlips[#DutyBlips+1] = blip
    end

    if GetBlipFromEntity(PlayerPedId()) == blip then
        -- Ensure we remove our own blip.
        RemoveBlip(blip)
    end
end



-- Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = player.job
    onDuty = player.job.onduty
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.onduty then
            if PlayerData.job.name == Config.Job then
                TriggerServerEvent("QBCore:ToggleDuty")
            end
        end
        TriggerServerEvent("r36-mcdonalds:server:UpdateBlips")
        TriggerServerEvent("r36-mcdonalds:server:UpdateCurrentmcemployes")
        if PlayerJob and PlayerJob.name ~= Config.Job then
            if DutyBlips then
                for k, v in pairs(DutyBlips) do
                    RemoveBlip(v)
                end
            end
            DutyBlips = {}
        end
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('r36-mcdonalds:server:UpdateBlips')
    TriggerServerEvent("r36-mcdonalds:server:UpdateCurrentmcemployes")
    onDuty = false
    if DutyBlips then
        for k, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
        DutyBlips = {}
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
    if JobInfo.name ~= Config.Job then
        if DutyBlips then
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
    PlayerJob = JobInfo
    TriggerServerEvent("r36-mcdonalds:server:UpdateBlips")
end)

RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

-- PickUp Orders Stashes Events

RegisterNetEvent("r36-mcdonalds:client:stash1")
AddEventHandler("r36-mcdonalds:client:stash1", function()
    TriggerEvent("inventory:client:SetCurrentStash", "McDonald's Orders")
         TriggerServerEvent("inventory:server:OpenInventory", "stash", "McDonald's Orders", {
        maxweight = 10000,
        slots = 6,
    })
end)

RegisterNetEvent("r36-mcdonalds:client:stash2")
AddEventHandler("r36-mcdonalds:client:stash2", function()
    TriggerEvent("inventory:client:SetCurrentStash", "McDonald's Orders")
         TriggerServerEvent("inventory:server:OpenInventory", "stash", "McDonald's Orders", {
        maxweight = 10000,
        slots = 6,
    })
end)

RegisterNetEvent("r36-mcdonalds:client:drivethrustash")
AddEventHandler("r36-mcdonalds:client:drivethrustash", function()
    TriggerEvent("inventory:client:SetCurrentStash", "McDonald's Drive Thru Orders")
         TriggerServerEvent("inventory:server:OpenInventory", "stash", "McDonald's Drive Thru Orders", {
        maxweight = 10000,
        slots = 6,
    })
end)

-- McDonald's Fridge Event

RegisterNetEvent("r36-mcdonalds:client:fridge:food", function()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "McDonald's Food Fridge", Config.Food)
end)

-- Player McDonald's Menu

RegisterNetEvent('r36-mcdonalds:client:Sandwicher36enu')
AddEventHandler('r36-mcdonalds:client:Sandwicher36enu', function()
    local headerMenu = {}
    headerMenu[#headerMenu+1] = {
        header = "| Available Meals |",
        params = {
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Mix 2 Meal",
        txt = "1 Cheese Burger, 1 Chicken Mac, 2 McFries, 1 McFizz BluePassion, 1 McFizz Strawberry",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:mix2meal",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Share Box",
        txt = "1 Cheese Burger, 1 Chicken Mac, 1 Big Tasty Chicken, 1 Big Mac, 4 McFries, 1 McFizz BluePassion, 1 McFizz Strawberry, 1 Sprite , 1 CoCa-Cola",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:sharebox",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• McRoyale",
        txt = "1 Beef, 1 Chadder Cheese, 1 Lettuce, 1 Tomatoes, 1 Sliced Pickles, 2 Bun",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:mcroyale",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Big Mac",
        txt = "2 Beef, 3 Chadder Cheese, 2 Lettuce, 2 Tomatoes, 3 Bun",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:bigmac",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Big Tasty",
        txt = "1 Beef, 2 Chadder Cheese, 1 Lettuce, 1 Tomatoes, 2 Bun",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:bigtasty",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Double Big Tasty",
        txt = "2 Beef, 2 Chadder Cheese, 1 Lettuce, 1 Tomatoes, 2 Bun",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:doublebigtasty",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Cheese Burger",
        txt = "2 Beef, 1 Chadder Cheese, 1 Sliced Picklke, 2 Bun",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:cheeseburger",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Big Tasty Chicken",
        txt = "1 Chicken Peace, 2 Chadder Cheese, 1 Tomatoes, 1 Lettuce, 2 Bun",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:bigtastychicken",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Chicken Mac",
        txt = "2 Chicken Peace, 2 Lettuce, 3 Bun",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:chickenmac",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Chicken Fillet",
        txt = "1 Chicken Peace, 1 Lettuce, 1 Tomatoes, 2 Bun",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:chickenfillet",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• McNuggets",
        txt = "1 Chicken Peace",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:mcnuggets",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Garden Salad",
        txt = "3 Lettuce, 3 Tomatoes",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:gardensalad",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Cheddar Cheese Fries",
        txt = "4 Sliced Potatoes, 4 Sliced Pickles, 3 Cheddar Cheese",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:cheddarcheesefries",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• McFries",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:mcfries",
            args = {}
        }
    }
    exports['qb-menu']:openMenu(headerMenu)
end)

RegisterNetEvent('r36-mcdonalds:client:Drinkr36enu')
AddEventHandler('r36-mcdonalds:client:Drinkr36enu', function()
    local headerMenu = {}
    headerMenu[#headerMenu+1] = {
        header = "| Available Drinks |",
        params = {
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Strawberry Milkshake",
        txt = "3 Strwaberry, 2 Milk, 5 Sugure, 1 McDonald's Machine Cup",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:strawberrymilkshake",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Chocolate Milkshake",
        txt = "3 Chocolate, 2 Milk, 5 Sugure, 1 McDonald's Machine Cup",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:chocolatemilkshake",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Vanilla Milkshake",
        txt = "3 Vanilla, 2 Milk, 5 Sugure, 1 McDonald's Machine Cup",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:vanillamilkshake",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• McFizz Blue Passion",
        txt = "1 Syrup, 2 Lemon, 1 Steam, 5 Sugure, 1 McDonald's Machine Cup",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:mcfizzbluepassion",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• McFizz Strawberry",
        txt = "1 Syrup, 2 Strawberry, 1 Steam, 5 Sugure, 1 McDonald's Machine Cup",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:mcfizzstrawberry",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Coca-Cola",
        txt = "1 McDonald's Machine Cup",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:cocacola",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Coca-Cola Zero",
        txt = "1 McDonald's Machine Cup",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:cocacolazero",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Sprite",
        txt = "1 McDonald's Machine Cup",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:sprite",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Fanta",
        txt = "1 McDonald's Machine Cup",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:fanta",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Fanta Green Apple",
        txt = "1 McDonald's Machine Cup",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:fantagreenapple",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Water Bottle",
        txt = "1 McDonald's Machine Cup",
        params = {
            type = "client",
            event = "r36-mcdonalds:client:water",
            args = {}
        }
    }
    exports['qb-menu']:openMenu(headerMenu)
end)



RegisterNetEvent('r36-mcdonalds:client:Desertr36enu')
AddEventHandler('r36-mcdonalds:client:Desertr36enu', function()
    local headerMenu = {}
headerMenu[#headerMenu+1] = {
    header = "| Available Deserts |",
    params = {
        args = {}
    }
}
headerMenu[#headerMenu+1] = {
    header = "• Chocolate Sundea",
    txt = "2 Chocolate, 4 Milk, 1 Sundea Cup",
    params = {
        type = "client",
        event = "r36-mcdonalds:client:chocolatesundea",
        args = {}
    }
}
headerMenu[#headerMenu+1] = {
    header = "• Strawberry Sundea",
    txt = "2 Strawberry, 4 Milk, 1 Sundea Cup",
    params = {
        type = "client",
        event = "r36-mcdonalds:client:strawberrysundea",
        args = {}
    }
}
headerMenu[#headerMenu+1] = {
    header = "• Apple Pie",
    txt = "2 Apple, 1 Baked Lattice Crust",
    params = {
        type = "client",
        event = "r36-mcdonalds:client:applepie",
        args = {}
    }
}
exports['qb-menu']:openMenu(headerMenu)
end)

-- Application Notifications

RegisterNetEvent('r36-mcdonalds:client:mix2meal')
AddEventHandler('r36-mcdonalds:client:mix2meal', function(streetLabel, coords)
    local source = source
    local ped = PlayerPedId()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local playerJob = QBCore.Functions.GetPlayerData().job

    Wait(200)
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    if onDuty then
        TriggerServerEvent("r36-mcdonalds:server:mix2meal", streetLabel, pos)
     end

end)
RegisterNetEvent('r36-mcdonalds:client:sharebox')
AddEventHandler('r36-mcdonalds:client:sharebox', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:sharebox", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:mcroyale')
AddEventHandler('r36-mcdonalds:client:mcroyale', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:mcroyale", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:bigmac')
AddEventHandler('r36-mcdonalds:client:bigmac', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:bigmac", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:bigtasty')
AddEventHandler('r36-mcdonalds:client:bigtasty', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:bigtasty", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:doublebigtasty')
AddEventHandler('r36-mcdonalds:client:doublebigtasty', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:doublebigtasty", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:cheeseburger')
AddEventHandler('r36-mcdonalds:client:cheeseburger', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:cheeseburger", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:bigtastychicken')
AddEventHandler('r36-mcdonalds:client:bigtastychicken', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:bigtastychicken", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:chickenmac')
AddEventHandler('r36-mcdonalds:client:chickenmac', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:chickenmac", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:chickenfillet')
AddEventHandler('r36-mcdonalds:client:chickenfillet', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:chickenfillet", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:cheddarcheesefries')
AddEventHandler('r36-mcdonalds:client:cheddarcheesefries', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:cheddarcheesefries", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:mcnuggets')
AddEventHandler('r36-mcdonalds:client:mcnuggets', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:mcnuggets", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:gardensalad')
AddEventHandler('r36-mcdonalds:client:gardensalad', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:gardensalad", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:strawberrymilkshake')
AddEventHandler('r36-mcdonalds:client:strawberrymilkshake', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:strawberrymilkshake", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:chocolatemilkshake')
AddEventHandler('r36-mcdonalds:client:chocolatemilkshake', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:chocolatemilkshake", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:vanillamilkshake')
AddEventHandler('r36-mcdonalds:client:vanillamilkshake', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:vanillamilkshake", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:mcfizzbluepassion')
AddEventHandler('r36-mcdonalds:client:mcfizzbluepassion', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:mcfizzbluepassion", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:mcfizzstrawberry')
AddEventHandler('r36-mcdonalds:client:mcfizzstrawberry', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:mcfizzstrawberry", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:cocacola')
AddEventHandler('r36-mcdonalds:client:cocacola', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:cocacola", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:cocacolazero')
AddEventHandler('r36-mcdonalds:client:cocacolazero', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:cocacolazero", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:sprite')
AddEventHandler('r36-mcdonalds:client:sprite', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:sprite", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:fanta')
AddEventHandler('r36-mcdonalds:client:fanta', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:fanta", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:fantagreenapple')
AddEventHandler('r36-mcdonalds:client:fantagreenapple', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:fantagreenapple", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:mcfries')
AddEventHandler('r36-mcdonalds:client:mcfries', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:mcfries", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:chocolatesundea')
AddEventHandler('r36-mcdonalds:client:chocolatesundea', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:chocolatesundea", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:strawberrysundea')
AddEventHandler('r36-mcdonalds:client:strawberrysundea', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:strawberrysundea", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:applepie')
AddEventHandler('r36-mcdonalds:client:applepie', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:applepie", streetLabel, pos)
      end
end)

RegisterNetEvent('r36-mcdonalds:client:water')
AddEventHandler('r36-mcdonalds:client:water', function(streetLabel, coords)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
      if onDuty then
         TriggerServerEvent("r36-mcdonalds:server:water", streetLabel, pos)
      end
end)


-- Job Events

RegisterNetEvent("r36-mcdonalds:client:duty")
AddEventHandler("r36-mcdonalds:client:duty", function()
    local ped = PlayerPedId()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if not onDuty then
            QBCore.Functions.Progressbar('eat_something','Changing your clothes', 3000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            })
            Citizen.Wait(3200)
            
            if PlayerData.charinfo.gender == 0 then 
                SetPedComponentVariation(ped, 3, Config.Clothes.male['arms'], 0, 0) --arms
                SetPedComponentVariation(ped, 8, Config.Clothes.male['tshirt_1'], Config.Clothes.male['tshirt_2'], 0) --t-shirt
                SetPedComponentVariation(ped, 11, Config.Clothes.male['torso_1'], Config.Clothes.male['torso_2'], 0) --torso2
                SetPedComponentVariation(ped, 9, Config.Clothes.male['bproof_1'], Config.Clothes.male['bproof_2'], 0) --vest
                SetPedComponentVariation(ped, 10, Config.Clothes.male['decals_1'], Config.Clothes.male['decals_2'], 0) --decals
                SetPedComponentVariation(ped, 7, Config.Clothes.male['chain_1'], Config.Clothes.male['chain_2'], 0) --accessory
                SetPedComponentVariation(ped, 4, Config.Clothes.male['pants_1'], Config.Clothes.male['pants_2'], 0) -- pants
                SetPedComponentVariation(ped, 6, Config.Clothes.male['shoes_1'], Config.Clothes.male['shoes_2'], 0) --shoes
                SetPedPropIndex(ped, 0, Config.Clothes.male['helmet_1'], Config.Clothes.male['helmet_2'], true) --hat
                SetPedPropIndex(ped, 2, Config.Clothes.male['ears_1'], Config.Clothes.male['ears_2'], true) --ear
            elseif PlayerData.charinfo.gender == 1 then 
                SetPedComponentVariation(ped, 3, Config.Clothes.female['arms'], 0, 0) --arms
                SetPedComponentVariation(ped, 8, Config.Clothes.female['tshirt_1'], Config.Clothes.female['tshirt_2'], 0) --t-shirt
                SetPedComponentVariation(ped, 11, Config.Clothes.female['torso_1'], Config.Clothes.female['torso_2'], 0) --torso2
                SetPedComponentVariation(ped, 9, Config.Clothes.female['bproof_1'], Config.Clothes.female['bproof_2'], 0) --vest
                SetPedComponentVariation(ped, 10, Config.Clothes.female['decals_1'], Config.Clothes.female['decals_2'], 0) --decals
                SetPedComponentVariation(ped, 7, Config.Clothes.female['chain_1'], Config.Clothes.female['chain_2'], 0) --accessory
                SetPedComponentVariation(ped, 4, Config.Clothes.female['pants_1'], Config.Clothes.female['pants_2'], 0) -- pants
                SetPedComponentVariation(ped, 6, Config.Clothes.female['shoes_1'], Config.Clothes.female['shoes_2'], 0) --shoes
                SetPedPropIndex(ped, 0, Config.Clothes.female['helmet_1'], Config.Clothes.female['helmet_2'], true) --hat
                SetPedPropIndex(ped, 2, Config.Clothes.female['ears_1'], Config.Clothes.female['ears_2'], true) --ear
            end
            TriggerServerEvent('QBCore:ToggleDuty')
            TriggerServerEvent("r36-mcdonalds:server:UpdateCurrentmcemployes")
            TriggerServerEvent("r36-mcdonalds:server:UpdateBlips")
            onDuty = true
    else
        QBCore.Functions.Progressbar('eat_something','Changing your clothes', 3000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        })
        Citizen.Wait(3200)
        TriggerServerEvent('QBCore:ToggleDuty')
        TriggerServerEvent("qb-clothes:loadPlayerSkin")
        TriggerServerEvent("r36-mcdonalds:server:UpdateCurrentmcemployes")
        TriggerServerEvent("r36-mcdonalds:server:UpdateBlips")
        onDuty = false
    end
end)

RegisterNetEvent('r36-mcdonalds:client:UpdateBlips', function(players)
    onDuty = not OnDuty
    if PlayerJob and (PlayerJob.name == Config.Job) and onDuty then
        if DutyBlips then
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        else
            RemoveBlip(v)
        end
        DutyBlips = {}
        if players then
            for k, data in pairs(players) do
                local id = GetPlayerFromServerId(data.source)
                CreateDutyBlips(id, data.label, data.job, data.location)
            end
        end
    end
end)



RegisterNetEvent("r36-mcdonalds:clien:cook:beef")
AddEventHandler("r36-mcdonalds:client:cook:beef", function()
    local PedCoords = GetEntityCoords(PlayerPedId())
       if onDuty then
        QBCore.Functions.TriggerCallback('r36-mcdonalds:server:cook_beef', function(HasItems)
            if HasItems then
                Working = true
                TriggerEvent('inventory:client:busy:status', true)
                TriggerEvent('animations:client:EmoteCommandStart', {"bbq"})
                QBCore.Functions.Progressbar("pickup_sla", "Cookiing Beef..", math.random(8000, 12000), false, true, {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false,
                }, {
                    animDict = "",
                    anim = "",
                    prop = "",
                    flags = 8,

                }, {}, {}, function()
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    TriggerServerEvent("qb-clothes:loadPlayerSkin")
                    Working = false
                    TriggerEvent('inventory:client:busy:status', false)
                         TriggerServerEvent('QBCore:Server:RemoveItem', "beef", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["beef"], "remove")
                         TriggerServerEvent('QBCore:Server:AddItem', "cooked_beef", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cooked_beef"], "add")
                    QBCore.Functions.Notify("Du stekte en burgare!", "success")
                end, function()
                    TriggerEvent('inventory:client:busy:status', false)
                    QBCore.Functions.Notify("Cancelled..", "error")
                    Working = false
                end)
            else
                   QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
            end
        end)
    else 
        QBCore.Functions.Notify("You must be Clocked into work", "error")
          end
end)

RegisterNetEvent("r36-mcdonalds:clien:cook:chicken")
AddEventHandler("r36-mcdonalds:client:cook:chicken", function()
    local PedCoords = GetEntityCoords(PlayerPedId())
       if onDuty then
        QBCore.Functions.TriggerCallback('r36-mcdonalds:server:cook_chicken', function(HasItems)
            if HasItems then
                Working = true
                TriggerEvent('inventory:client:busy:status', true)
                TriggerEvent('animations:client:EmoteCommandStart', {"bbq"})
                QBCore.Functions.Progressbar("pickup_sla", "Cookiing Chicken..", math.random(8000, 12000), false, true, {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false,
                }, {
                    animDict = "",
                    anim = "",
                    prop = "",
                    flags = 8,

                }, {}, {}, function()
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    TriggerServerEvent("qb-clothes:loadPlayerSkin")
                    Working = false
                    TriggerEvent('inventory:client:busy:status', false)
                         TriggerServerEvent('QBCore:Server:RemoveItem', "chickenpeace", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["chickenpeace"], "remove")
                         TriggerServerEvent('QBCore:Server:AddItem', "cooked_chickenpeace", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cooked_chickenpeace"], "add")
                    QBCore.Functions.Notify("You Cooked a peace of Chiecken!", "success")
                end, function()
                    TriggerEvent('inventory:client:busy:status', false)
                    QBCore.Functions.Notify("Cancelled..", "error")
                    Working = false
                end)
            else
                   QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
            end
        end)
    else 
        QBCore.Functions.Notify("You must be Clocked into work", "error")
          end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:bigmac")
AddEventHandler("r36-mcdonalds:client:prepare:bigmac", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:bigmac', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Cooking a Big Mac..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cooked_beef", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cooked_beef"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cheedercheese", 3)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cheedercheese"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "lettuce", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["lettuce"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "tomatoes", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["tomatoes"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "bun", 3)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bun"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "bigmac", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bigmac"], "add")
                    QBCore.Functions.Notify("You prepared a Big Mac", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)


RegisterNetEvent("r36-mcdonalds:client:prepare:mcroyale")
AddEventHandler("r36-mcdonalds:client:prepare:mcroyale", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:mcroyale', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Cooking a McRoyale..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cooked_beef", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cooked_beef"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cheedercheese", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cheedercheese"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "lettuce", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["lettuce"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "tomatoes", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["tomatoes"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "bun", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bun"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "pickle", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["pickle"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "mcroyale", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcroyale"], "add")
                    QBCore.Functions.Notify("You prepared a McRoyale", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:bigtasty")
AddEventHandler("r36-mcdonalds:client:prepare:bigtasty", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:bigtasty', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Cooking a Big Tasty..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cooked_beef", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cooked_beef"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cheedercheese", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cheedercheese"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "lettuce", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["lettuce"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "tomatoes", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["tomatoes"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "bun", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bun"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "bigtasty", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bigtasty"], "add")
                    QBCore.Functions.Notify("You prepared a Big Tasty", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)


RegisterNetEvent("r36-mcdonalds:client:prepare:doublebigtasty")
AddEventHandler("r36-mcdonalds:client:prepare:doublebigtasty", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:bigtasty', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Cooking a Double Big Tasty..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cooked_beef", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cooked_beef"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cheedercheese", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cheedercheese"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "lettuce", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["lettuce"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "tomatoes", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["tomatoes"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "bun", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bun"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "doublebigtasty", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["doublebigtasty"], "add")
                    QBCore.Functions.Notify("You prepared a Double Big Tasty", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:cheeseburger")
AddEventHandler("r36-mcdonalds:client:prepare:cheeseburger", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:cheeseburger', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Cooking a Cheese Burger..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cooked_beef", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cooked_beef"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cheedercheese", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cheedercheese"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "pickle", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["pickle"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "bun", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bun"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "cheeseburger", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cheeseburger"], "add")
                    QBCore.Functions.Notify("You prepared a Cheese Burger", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:bigtastychicken")
AddEventHandler("r36-mcdonalds:client:prepare:bigtastychicken", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:bigtastychicken', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Cooking a Big Tasty Chicken..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cooked_chickenpeace", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cooked_chickenpeace"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cheedercheese", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cheedercheese"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "tomatoes", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["tomatoes"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "lettuce", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["lettuce"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "bun", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bun"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "bigtastychicken", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bigtastychicken"], "add")
                    QBCore.Functions.Notify("You prepared a Big Tasty Chicken", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:chickenmac")
AddEventHandler("r36-mcdonalds:client:prepare:chickenmac", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:chickenmac', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Cooking a Chicken Mac..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cooked_chickenpeace", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cooked_chickenpeace"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "lettuce", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["lettuce"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "bun", 3)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bun"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "chickenmac", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["chickenmac"], "add")
                    QBCore.Functions.Notify("You prepared a Chicken Mac", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)


RegisterNetEvent("r36-mcdonalds:client:prepare:chickenfillet")
AddEventHandler("r36-mcdonalds:client:prepare:chickenfillet", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:chickenfillet', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Cooking a Chicken Fillet..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cooked_chickenpeace", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cooked_chickenpeace"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "lettuce", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["lettuce"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "tomatoes", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["lettuce"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "bun", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bun"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "chickenfillet", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["chickenfillet"], "add")
                    QBCore.Functions.Notify("You prepared a Chicken Fillet", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:cheddarcheesefries")
AddEventHandler("r36-mcdonalds:client:prepare:cheddarcheesefries", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:cheddarcheesefries', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Cooking a Cheddar Cheese Fries..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "slicedpotatoes", 4)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["slicedpotatoes"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "pickle", 4)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["pickle"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cheedercheese", 3)
					     TriggerServerEvent('QBCore:Server:AddItem', "cheddarcheesefries", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cheddarcheesefries"], "add")
                    QBCore.Functions.Notify("You prepared a Cheddar Cheese Fries", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:mcnuggets")
AddEventHandler("r36-mcdonalds:client:prepare:mcnuggets", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:mcnuggets', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Cooking a McNuggets..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "cooked_chickenpeace", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cooked_chickenpeace"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "mcnuggets", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcnuggets"], "add")
                    QBCore.Functions.Notify("You prepared a McNuggets", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:gardensalad")
AddEventHandler("r36-mcdonalds:client:prepare:gardensalad", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:gardensalad', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Garden Salad..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "lettuce", 3)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["lettuce"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "tomatoes", 3)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["tomatoes"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "gardensalad", 3)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["gardensalad"], "add")
                    QBCore.Functions.Notify("You prepared a Garden Salad", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)


RegisterNetEvent("r36-mcdonalds:client:prepare:strawberrymilkshake")
AddEventHandler("r36-mcdonalds:client:prepare:strawberrymilkshake", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:strawberrymilkshake', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Strawberry MilkShake..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "amb@prop_human_bbq@male@idle_a",
					anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "strawberry", 3)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["strawberry"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "milk", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["milk"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "sugure", 5)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["sugure"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "mcdonaldr36achinecup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcdonaldr36achinecup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "strawberrymilkshake", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["strawberrymilkshake"], "add")
                    QBCore.Functions.Notify("You prepared a Strawberry MilkShake", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)


RegisterNetEvent("r36-mcdonalds:client:prepare:vanillamilkshake")
AddEventHandler("r36-mcdonalds:client:prepare:vanillamilkshake", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:vanillamilkshake', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Vanilla MilkShake..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "Vanilla", 3)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["strawberry"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "milk", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["milk"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "sugure", 5)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["sugure"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "mcdonaldr36achinecup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcdonaldr36achinecup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "vanillamilkshake", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["vanillamilkshake"], "add")
                    QBCore.Functions.Notify("You prepared a Vanilla MilkShake", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)



RegisterNetEvent("r36-mcdonalds:client:prepare:chocolatemilkshake")
AddEventHandler("r36-mcdonalds:client:prepare:chocolatemilkshake", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:chocolatemilkshake', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Chocolate MilkShake..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "chocolate", 3)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["strawberry"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "milk", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["milk"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "sugure", 5)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["sugure"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "mcdonaldr36achinecup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcdonaldr36achinecup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "chocolatemilkshake", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["chocolatemilkshake"], "add")
                    QBCore.Functions.Notify("You prepared a Chocolate MilkShake", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:mcfizzbluepassion")
AddEventHandler("r36-mcdonalds:client:prepare:mcfizzbluepassion", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:mcfizzbluepassion', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a McFizz Blue Passion..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "syrup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["syrup"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "lemon", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["lemon"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "steam", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["steam"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "sugure", 5)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["sugure"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "mcdonaldr36achinecup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcdonaldr36achinecup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "mcfizzbluepassion", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcfizzbluepassion"], "add")
                    QBCore.Functions.Notify("You prepared a McFizz Blue Passion", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)


RegisterNetEvent("r36-mcdonalds:client:prepare:mcfizzstrawberry")
AddEventHandler("r36-mcdonalds:client:prepare:mcfizzstrawberry", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:mcfizzstrawberry', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a McFizz Straw Berry..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "syrup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["syrup"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "strawberry", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["lemon"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "steam", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["steam"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "sugure", 5)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["sugure"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "mcdonaldr36achinecup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcdonaldr36achinecup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "mcfizzstrawberry", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcfizzstrawberry"], "add")
                    QBCore.Functions.Notify("You prepared a McFizz Strawberry", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:cocacola")
AddEventHandler("r36-mcdonalds:client:prepare:cocacola", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:mcdonaldr36achinecup', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Coca-Cola..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "mcdonaldr36achinecup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcdonaldr36achinecup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "cocacola", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cocacola"], "add")
                    QBCore.Functions.Notify("You prepared a Coca-Cola", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:cocacolazero")
AddEventHandler("r36-mcdonalds:client:prepare:cocacolazero", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:mcdonaldr36achinecup', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Coca-Cola Zero..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "mcdonaldr36achinecup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcdonaldr36achinecup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "cocacolazero", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cocacolazero"], "add")
                    QBCore.Functions.Notify("You prepared a Coca-Cola Zero", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:sprite")
AddEventHandler("r36-mcdonalds:client:prepare:sprite", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:mcdonaldr36achinecup', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Sprite..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "mcdonaldr36achinecup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcdonaldr36achinecup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "sprite", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["sprite"], "add")
                    QBCore.Functions.Notify("You prepared a Sprite", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:fanta")
AddEventHandler("r36-mcdonalds:client:prepare:fanta", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:mcdonaldr36achinecup', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Fanta..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "mcdonaldr36achinecup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcdonaldr36achinecup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "fanta", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["fanta"], "add")
                    QBCore.Functions.Notify("You prepared a Fanta", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:fantagreenapple")
AddEventHandler("r36-mcdonalds:client:prepare:fantagreenapple", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:mcdonaldr36achinecup', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Fanta Green Apple..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "mcdonaldr36achinecup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcdonaldr36achinecup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "fantagreenapple", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["fantagreenapple"], "add")
                    QBCore.Functions.Notify("You prepared a Fanta Green Apple", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)


RegisterNetEvent("r36-mcdonalds:client:prepare:water")
AddEventHandler("r36-mcdonalds:client:prepare:water", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:mcdonaldr36achinecup', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Water..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "mcdonaldr36achinecup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcdonaldr36achinecup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "water_bottle", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["water_bottle"], "add")
                    QBCore.Functions.Notify("You prepared a Water", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:mcfries")
AddEventHandler("r36-mcdonalds:client:prepare:mcfries", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:mcfries', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a McFries..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "slicedpotatoes", 4)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["slicedpotatoes"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "mcfries", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcfries"], "add")
                    QBCore.Functions.Notify("You prepared a McFries", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:chocolatesundea")
AddEventHandler("r36-mcdonalds:client:prepare:chocolatesundea", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:chocolatesundea', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Chocolate Sundea..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "chocolate", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["chocolate"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "milk", 4)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["milk"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "sundeacup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["sundeacup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "chocolatesundea", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["chocolatesundea"], "add")
                    QBCore.Functions.Notify("You prepared a Chocolate Sundea", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:strawberrysundea")
AddEventHandler("r36-mcdonalds:client:prepare:strawberrysundea", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:strawberrysundea', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Strawberry Sundea..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "strawberry", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["chocolate"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "milk", 4)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["milk"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "sundeacup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["sundeacup"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "strawberrysundea", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["strawberrysundea"], "add")
                    QBCore.Functions.Notify("You prepared a Strawberry Sundea", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:applepie")
AddEventHandler("r36-mcdonalds:client:prepare:applepie", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:applepie', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Preparing a Apple Pie..", math.random(4000, 4000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
                    animDict = "amb@prop_human_bbq@male@idle_a",
                    anim = "idle_b",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "apple", 2)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["apple"], "remove")
					     TriggerServerEvent('QBCore:Server:RemoveItem', "bakedlatticecrust", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["bakedlatticecrust"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "applepie", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["applepie"], "add")
                    QBCore.Functions.Notify("You prepared a Apple Pie", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:slice:potatoes")
AddEventHandler("r36-mcdonalds:client:slice:potatoes", function()
    local PedCoords = GetEntityCoords(PlayerPedId())
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:slicepotatoes', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Slicing Potatoes..", math.random(9500, 13500), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "anim@amb@business@coc@coc_unpack_cut_left@",
					anim = "coke_cut_v1_coccutter",
                    prop = "prop_knife",
					flags = 8,
                    
				}, {}, {}, function() 
					Working = false
                    local nozyk = CreateObject(GetHashKey('prop_knife'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
                    AttachEntityToEntity(nozyk, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "potatoes", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["potatoes"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "slicedpotatoes", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["slicedpotatoes"], "add")
                    QBCore.Functions.Notify("You Sliced some potatoes", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:slice:pickles")
AddEventHandler("r36-mcdonalds:client:slice:pickles", function()
       if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:slicepickles', function(HasItems)  
    		if HasItems then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Slicing Pickles..", math.random(8000, 12000), false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:RemoveItem', "pickle", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["pickle"], "remove")
					     TriggerServerEvent('QBCore:Server:AddItem', "slicedpickles", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["slicedpickles"], "add")
                    QBCore.Functions.Notify("You Sliced some pickles", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:get:mcdonaldr36achinecup")
AddEventHandler("r36-mcdonalds:client:get:mcdonaldr36achinecup", function()
       if onDuty then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Picking Up a McDonald's Machine Cup..", 1500, false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "pickup_object",
					anim = "pickup_low",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:AddItem', "mcdonaldr36achinecup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mcdonaldr36achinecup"], "add")
                    QBCore.Functions.Notify("You picked up a McDonald's Machine Cup", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent("r36-mcdonalds:client:get:mcdonaldssundeacup")
AddEventHandler("r36-mcdonalds:client:get:mcdonaldssundeacup", function()
       if onDuty then
				Working = true
				TriggerEvent('inventory:client:busy:status', true)
				QBCore.Functions.Progressbar("pickup_sla", "Picking Up a McDonald's Sundea Cup..", 1500, false, true, {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = "pickup_object",
					anim = "pickup_low",
					flags = 8,
				}, {}, {}, function() 
					Working = false
					TriggerEvent('inventory:client:busy:status', false)
					     TriggerServerEvent('QBCore:Server:AddItem', "sundeacup", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["sundeacup"], "add")
                    QBCore.Functions.Notify("You picked up a McDonald's Sundea Cup", "success")
				end, function()
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
					Working = false
				end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	      end
end)

RegisterNetEvent('r36-mcdonalds:client:meals', function(data)
    local headerMenu = {}
    headerMenu[#headerMenu+1] = {
        header = "| Available Meals |",
        params = {
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Mix 2 Meal",
        txt = "1 Cheese Burger, 1 Chicken Mac, 2 McFries, 1 McFizz BluePassion, 1 McFizz Strawberry",
        params = {
            event = "r36-mcdonalds:client:prepare:mix2meal",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Share Box",
        txt = "1 Cheese Burger, 1 Chicken Mac, 1 Big Tasty Chicken, 1 Big Mac, 4 McFries, 1 McFizz BluePassion, 1 McFizz Strawberry, 1 Sprite , 1 CoCa-Cola",
        params = {
            event = "r36-mcdonalds:client:prepare:sharebox",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• McRoyale Burger Box",
        txt = "1 Cooked Beef, 1 Chadder Cheese, 1 Lettuce, 1 Tomatoes, 1 Sliced Pickles, 2 Bun",
        params = {
            event = "r36-mcdonalds:client:prepare:mcroyale",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Big Mac",
        txt = "2 Cooked Beef, 3 Chadder Cheese, 2 Lettuce, 2 Tomatoes, 3 Bun",
        params = {
            event = "r36-mcdonalds:client:prepare:bigmac",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Big Tasty",
        txt = "1 Cooked Beef, 2 Chadder Cheese, 1 Lettuce, 1 Tomatoes, 2 Bun",
        params = {
            event = "r36-mcdonalds:client:prepare:bigtasty",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Double Big Tasty",
        txt = "2 Cooked Beef, 2 Chadder Cheese, 1 Lettuce, 1 Tomatoes, 2 Bun",
        params = {
            event = "r36-mcdonalds:client:prepare:doublebigtasty",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Cheese Burger",
        txt = "2 Cooked Beef, 1 Chadder Cheese, 1 Sliced Picklke, 2 Bun",
        params = {
            event = "r36-mcdonalds:client:prepare:cheeseburger",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Big Tasty Chicken",
        txt = "1 Chicken Peace, 2 Chadder Cheese, 1 Tomatoes, 1 Lettuce, 2 Bun",
        params = {
            event = "r36-mcdonalds:client:prepare:bigtastychicken",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Chicken Mac",
        txt = "2 Chicken Peace, 2 Lettuce, 3 Bun",
        params = {
            event = "r36-mcdonalds:client:prepare:chickenmac",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Chicken Fillet",
        txt = "1 Chicken Peace, 1 Lettuce, 1 Tomatoes, 2 Bun",
        params = {
            event = "r36-mcdonalds:client:prepare:chickenfillet",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• McNuggets",
        txt = "1 Chicken Peace",
        params = {
            event = "r36-mcdonalds:client:prepare:mcnuggets",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Garden Salad",
        txt = "3 Lettuce, 3 Tomatoes",
        params = {
            event = "r36-mcdonalds:client:prepare:gardensalad",
            args = {}
        }
    }
    exports['qb-menu']:openMenu(headerMenu)
end)
RegisterNetEvent('r36-mcdonalds:client:mcfriesprepare', function(data)
    local headerMenu = {}
    headerMenu[#headerMenu+1] = {
        header = "| Available Fries |",
        params = {
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Cheddar Cheese Fries",
        txt = "4 Sliced Potatoes, 4 Sliced Pickles, 3 Cheddar Cheese",
        params = {
            event = "r36-mcdonalds:client:prepare:cheddarcheesefries",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• McFries",
        txt = "4 Sliced Potatoes",
        params = {
            event = "r36-mcdonalds:client:prepare:mcfries",
            args = {}
        }
    }
    exports['qb-menu']:openMenu(headerMenu)

end)

RegisterNetEvent('r36-mcdonalds:client:drinks', function(data)
    local headerMenu = {}
    headerMenu[#headerMenu+1] = {
        header = "| Available Drinks |",
        params = {
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Strawberry Milkshake",
        txt = "3 Strwaberry, 2 Milk, 5 Sugure, 1 McDonald's Machine Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:strawberrymilkshake",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Chocolate Milkshake",
        txt = "3 Chocolate, 2 Milk, 5 Sugure, 1 McDonald's Machine Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:chocolatemilkshake",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Vanilla Milkshake",
        txt = "3 Vanilla, 2 Milk, 5 Sugure, 1 McDonald's Machine Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:vanillamilkshake",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• McFizz Blue Passion",
        txt = "1 Syrup, 2 Lemon, 1 Steam, 5 Sugure, 1 McDonald's Machine Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:mcfizzbluepassion",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• McFizz Strawberry",
        txt = "1 Syrup, 2 Strawberry, 1 Steam, 5 Sugure, 1 McDonald's Machine Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:mcfizzstrawberry",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Coca-Cola",
        txt = "1 McDonald's Machine Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:cocacola",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Coca-Cola Zero",
        txt = "1 McDonald's Machine Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:cocacolazero",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Sprite",
        txt = "1 McDonald's Machine Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:sprite",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Fanta",
        txt = "1 McDonald's Machine Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:fanta",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Fanta Green Apple",
        txt = "1 McDonald's Machine Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:fantagreenapple",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Water Bottle",
        txt = "1 McDonald's Machine Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:water",
            args = {}
        }
    }
    exports['qb-menu']:openMenu(headerMenu)
end)

RegisterNetEvent('r36-mcdonalds:client:deserts', function(data)
    local headerMenu = {}
    headerMenu[#headerMenu+1] = {
        header = "| Available Deserts |",
        params = {
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Chocolate Sundea",
        txt = "2 Chocolate, 4 Milk, 1 Sundea Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:chocolatessundea",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Strawberry Sundea",
        txt = "2 Strawberry, 4 Milk, 1 Sundea Cup",
        params = {
            event = "r36-mcdonalds:client:prepare:strawberrysundea",
            args = {}
        }
    }
    headerMenu[#headerMenu+1] = {
        header = "• Apple Pie",
        txt = "2 Apple, 1 Baked Lattice Crust",
        params = {
            event = "r36-mcdonalds:client:prepare:applepie",
            args = {}
        }
    }
    exports['qb-menu']:openMenu(headerMenu)
end)

RegisterNetEvent('r36-mcdonalds:client:washHands', function()
    QBCore.Functions.Progressbar('washing_hands', 'Washing hands', 5000, false, false, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, },
	{ animDict = "mp_arresting", anim = "a_uncuff", flags = 8, }, {}, {}, function()
		TriggerEvent('QBCore:Notify', "You washed your hands !", 'success')
	end, function()
        TriggerEvent('inventory:client:busy:status', false)
		TriggerEvent('QBCore:Notify', "Canceled", 'error')
    end)
end)

-- McDonald's Garage Events

RegisterNetEvent("r36-mcdonalds:client:VehicleMenuHeader", function (data)
    MenuGarage(data.currentSelection)
    currentGarage = data.currentSelection
end)

RegisterNetEvent('r36-mcdonalds:client:TakeOutVehicle', function(data)
    if inGarage then
        local vehicle = data.vehicle
        TakeOutVehicle(vehicle)
    end
end)
-- Consunmbles
RegisterNetEvent('r36-mcdonalds:client:mcdrink', function(itemName)
    if itemName == "cocacola" or itemName == "cocacolazero" then
        TriggerEvent('animations:client:EmoteCommandStart', {"drink1"})
    elseif itemName == "sprite" or itemName == "fanta" or itemName == "fantagreenapple" then
        TriggerEvent('animations:client:EmoteCommandStart', {"drink2"})
    elseif itemName == "strawberrymilkshake" or itemName == "chocolatemilkshake" or itemName == "vanillamilkshake" then
        TriggerEvent('animations:client:EmoteCommandStart', {"drink3"})
    elseif itemName == "mcfizzbluepassion" or itemName == "mcfizzstrawberry" then
        TriggerEvent('animations:client:EmoteCommandStart', {"cup"})
    end
    QBCore.Functions.Progressbar("drink_something", "Drinking "..QBCore.Shared.Items[itemName].label.."..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove", 1)
        TriggerServerEvent("QBCore:Server:RemoveItem", itemName, 1)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + ConsumeablesDrink[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
    end)
end)

RegisterNetEvent('r36-mcdonalds:client:mceat', function(itemName)
    if itemName == "cheddarcheesefries" or itemName == "mcfries" then
        TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
    elseif itemName == "mcroyale" or itemName == "bigmac" or itemName == "gardensalad" then
        TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
    elseif itemName == "bigtasty" or itemName == "doublebigtasty" or itemName == "mcnuggets" then
        TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
    elseif itemName == "cheeseburger" or itemName == "chickenmac" or itemName == "chickenfillet" then
        TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
    elseif itemName == "applepie" then
        TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
    end
    QBCore.Functions.Progressbar("eat_something", "Eating "..QBCore.Shared.Items[itemName].label.."..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove", 1)
        TriggerServerEvent("QBCore:Server:RemoveItem", itemName, 1)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + ConsumeablesEat[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
    end)
end)


RegisterNetEvent("r36-mcdonalds:client:usemix2meal")
AddEventHandler("r36-mcdonalds:client:usemix2meal", function()
    TriggerServerEvent('QBCore:Server:RemoveItem', "mix2meal", 1)
	TriggerServerEvent('QBCore:Server:AddItem', "cheeseburger", 1)
	TriggerServerEvent('QBCore:Server:AddItem', "chickenmac", 1)
	TriggerServerEvent('QBCore:Server:AddItem', "mcfries", 2)
    TriggerServerEvent('QBCore:Server:AddItem', "mcfizzbluepassion", 1)
    TriggerServerEvent('QBCore:Server:AddItem', "mcfizzstrawberry", 1)
end)

-- Mcdonald's Meals
RegisterNetEvent("r36-mcdonalds:client:prepare:mix2meal")
AddEventHandler("r36-mcdonalds:client:prepare:mix2meal", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:getmix2meal', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Packaging the meal ..", 10000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "cheeseburger", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "chickenmac", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "mcfries ", 2)
					TriggerServerEvent('QBCore:Server:RemoveItem', "mcfizzbluepassion", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "mcfizzstrawberry", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "mix2meal", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mix2meal"], "add")
                    QBCore.Functions.Notify("You packaged the meal", "success")
				end, function()
					QBCore.Functions.Notify("Canceled..", "error")
				end)
			else
   				QBCore.Functions.Notify("You don't have any item to package", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be clocked in!", "error")
	end  
end)

RegisterNetEvent("r36-mcdonalds:client:usesharebox")
AddEventHandler("r36-mcdonalds:client:usesharebox", function()
    TriggerServerEvent('QBCore:Server:RemoveItem', "sharebox", 1)
	TriggerServerEvent('QBCore:Server:AddItem', "cheeseburger", 1)
	TriggerServerEvent('QBCore:Server:AddItem', "chickenmac", 1)
	TriggerServerEvent('QBCore:Server:AddItem', "bigtastychicken", 1)
	TriggerServerEvent('QBCore:Server:AddItem', "bigmac", 1)
	TriggerServerEvent('QBCore:Server:AddItem', "mcfries", 4)
    TriggerServerEvent('QBCore:Server:AddItem', "mcfizzbluepassion", 1)
    TriggerServerEvent('QBCore:Server:AddItem', "mcfizzstrawberry", 1)
    TriggerServerEvent('QBCore:Server:AddItem', "cocacola", 1)
    TriggerServerEvent('QBCore:Server:AddItem', "sprite", 1)
end)

RegisterNetEvent("r36-mcdonalds:client:prepare:sharebox")
AddEventHandler("r36-mcdonalds:client:prepare:sharebox", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('r36-mcdonalds:server:getsharebox', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Packaging the meal ..", 10000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "cheeseburger", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "chickenmac", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "bigtastychicken", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "bigmac", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "mcfries", 4)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "mcfizzbluepassion", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "mcfizzstrawberry", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "cocacola", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "sprite", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "sharebox", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["sharebox"], "add")
                    QBCore.Functions.Notify("You packaged the meal", "success")
				end, function()
					QBCore.Functions.Notify("Canceled..", "error")
				end)
			else
   				QBCore.Functions.Notify("You don't have any item to package", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be clocked in!", "error")
	end  
end)

-- Receipt Event
RegisterNetEvent("r36-mcdonalds:client:receipt")
AddEventHandler("r36-mcdonalds:client:receipt", function()
    if onDuty then
            local bill = exports['qb-input']:ShowInput({
                header = "Create Receipt",
                submitText = "Bill",
                inputs = {
                    {
                        text = "Server ID(#)",
                        name = "citizenid", -- name of the input should be unique otherwise it might override
                        type = "text", -- type of the input
                        isRequired = true -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                    },
                    {
                        text = "Bill Price ($)", -- text you want to be displayed as a place holder
                        name = "billprice", -- name of the input should be unique otherwise it might override
                        type = "number", -- type of the input - number will not allow non-number characters in the field so only accepts 0-9
                        isRequired = false -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                    }
                    
                }
            })
            if bill ~= nil then
                if bill.citizenid == nil or bill.billprice == nil then 
                    return 
                end
                TriggerServerEvent("r36-mcdonalds:bill:player", bill.citizenid, bill.billprice)
            end
        end
end)

-- Threads
CreateThread(function()
    Blip = AddBlipForCoord(Config.Blip["main"].coords)
    SetBlipSprite(Blip, 78)
    SetBlipDisplay(Blip, 3)
    SetBlipColour(Blip, 1)
    SetBlipScale(Blip, 0.8)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Blip["main"].label)
    EndTextCommandSetBlipName(Blip)
end)

CreateThread(function()
        exports['qb-target']:AddBoxZone("McDonald's_Order_Main", vector3(89.53, 285.67, 110.21), 7.55, 1.5, {
            name = "McDonald's_Order_Main",
            heading = 160,
            debugPoly = false,
            minZ=107.01,
            maxZ=111.01,
        }, {
            options = {
                
                {
                    event = "r36-mcdonalds:client:stash1",
                    icon = "fa-solid fa-box",
                    label = "Pick Up Order",
                },
                {
                    type = "client",
                    event = "r36-mcdonalds:client:Sandwicher36enu",
                    icon = "fa-solid fa-book-open",
                    label = "Get the Sandwiches Menu",
                },
                {
                    type = "client",
                    event = "r36-mcdonalds:client:Drinkr36enu",
                    icon = "fa-solid fa-book-open",
                    label = "Get the Drinks Menu",
                },
                {
                    type = "client",
                    event = "r36-mcdonalds:client:Desertr36enu",
                    icon = "fa-solid fa-book-open",
                    label = "Get the Deserts Menu",
                },
                {   type = "client",
                    event = "r36-mcdonalds:client:receipt",
                    job = Config.Job,
                    icon = "fas fa-credit-card",
                    label = "Create Receipt",
                },
                {
                    type = "client",
                    event = "r36-mcdonalds:client:duty",
                    job = Config.Job,
                    icon = "far fa-clipboard",
                    label = "Clock In/Out",
                },
                
            },
            distance = 1.5
        })
        exports['qb-target']:AddBoxZone("McDonald's_Order_Main_two", vector3(89.11, 290.41, 110.21), 5.1, 1.5, {
            name = "McDonald's_Order_Main_two",
            heading = 70,
            debugPoly = false,
            minZ=106.81,
            maxZ=110.81,
        }, {
            options = {
                {
                    event = "r36-mcdonalds:client:stash2",
                    icon = "fa-solid fa-box",
                    label = "Pick Up Order",
                },
                {
                    type = "client",
                    event = "r36-mcdonalds:client:Sandwicher36enu",
                    icon = "fa-solid fa-book-open",
                    label = "Get the Sandwiches Menu",
                },
                {
                    type = "client",
                    event = "r36-mcdonalds:client:Drinkr36enu",
                    icon = "fa-solid fa-book-open",
                    label = "Get the Drinks Menu",
                },
                {
                    type = "client",
                    event = "r36-mcdonalds:client:Desertr36enu",
                    icon = "fa-solid fa-book-open",
                    label = "Get the Deserts Menu",
                },
                {   type = "client",
                    event = "r36-mcdonalds:client:receipt",
                    job = Config.Job,
                    icon = "fas fa-credit-card",
                    label = "Create Receipt",
                },
                {
                    type = "client",
                    event = "r36-mcdonalds:client:duty",
                    job = Config.Job,
                    icon = "far fa-clipboard",
                    label = "Clock In/Out",
                },
                
            },
            distance = 1.5
        })
        exports['qb-target']:AddBoxZone("McDonald's_Order_Main_three", vector3(79.61, 283.71, 110.21), 1.5, 1.5, {
            name = "McDonald's_Order_Main_three",
            heading = 341,
            debugPoly = false,
            minZ=106.81,
            maxZ=110.81,
        }, {
            options = {
                {
                    type = "client",
                    event = "r36-mcdonalds:client:Sandwicher36enu",
                    icon = "fa-solid fa-book-open",
                    label = "Get the Sandwiches Menu",
                },
                {
                    type = "client",
                    event = "r36-mcdonalds:client:Drinkr36enu",
                    icon = "fa-solid fa-book-open",
                    label = "Get the Drinks Menu",
                },
                {
                    type = "client",
                    job = Config.Job,
                    event = "r36-mcdonalds:client:Desertr36enu",
                    icon = "fa-solid fa-book-open",
                    label = "Get the Deserts Menu",
                },
            },
            distance = 1.5
        })
        exports['qb-target']:AddBoxZone("McDonald's_Order_Main_four", vector3(78.2, 279.86, 110.21), 1.5, 1.5, {
            name = "McDonald's_Order_Main_four",
            heading = 340,
            debugPoly = false,
            minZ=106.81,
            maxZ=110.81,
        }, {
            options = {
                {
                    type = "client",
                    event = "r36-mcdonalds:client:Sandwicher36enu",
                    icon = "fa-solid fa-book-open",
                    label = "Get the Sandwiches Menu",
                },
                {
                    type = "client",
                    event = "r36-mcdonalds:client:Drinkr36enu",
                    icon = "fa-solid fa-book-open",
                    label = "Get the Drinks Menu",
                },
                {
                    type = "client",
                    event = "r36-mcdonalds:client:Desertr36enu",
                    icon = "fa-solid fa-book-open",
                    label = "Get the Deserts Menu",
                },
                {   type = "client",
                    job = Config.Job,
                    event = "r36-mcdonalds:client:receipt",
                    icon = "fas fa-credit-card",
                    label = "Create Receipt",
                },
            },
            distance = 1.5
        })
        -- Drive Thru
        exports['qb-target']:SpawnPed({
            model = 'u_m_y_burgerdrug_01',
            coords = vector4(94.2, 285.4, 110.22, 251.55),
            minusOne = true,
            freeze = true,
            invincible = true,
            blockevents = true,
            target = {
                options = {
                    {
                        type = "client",
                        event = "r36-mcdonalds:client:Sandwicher36enu",
                        icon = "fa-solid fa-book-open",
                        label = "Get the Sandwiches Menu",
                    },
                    {
                        type = "client",
                        event = "r36-mcdonalds:client:Drinkr36enu",
                        icon = "fa-solid fa-book-open",
                        label = "Get the Drinks Menu",
                    },
                    {
                        type = "client",
                        event = "r36-mcdonalds:client:Desertr36enu",
                        icon = "fa-solid fa-book-open",
                        label = "Get the Deserts Menu",
                    },
                    {   type = "client",
                        job = Config.Job,
                        event = "r36-mcdonalds:client:receipt",
                        icon = "fas fa-credit-card",
                        label = "Create Receipt",
                    },
                },
            distance = 15,
            },
            spawnNow = true,
          })
                exports['qb-target']:AddBoxZone("McFries", vector3(92.07, 292.37, 110.21), 4.7, 1.5, {
                    name = "McFries",
                    heading = 250,
                    debugPoly = false,
                    minZ=107.21,
                    maxZ=111.21,
                }, {
                    options = {
                        {
                            type = "client",
                            Job = Config.Job,
                            event = "r36-mcdonalds:client:mcfriesprepare",
                            icon = "fa-solid fa-utensils",
                            label = "Prepare McFries",
                        },
                
                    },
                    distance = 1.5
                })
                exports['qb-target']:AddBoxZone("prepareMeals", vector3(93.07, 295.54, 110.21), 3.5, 1.5, {
                    name = "prepareMeals",
                    heading = 250,
                    debugPoly = false,
                    minZ=106.81,
                    maxZ=110.81,
                }, {
                    options = {
                        {
                            type = "client",
                            Job = Config.Job,
                            event = "r36-mcdonalds:client:meals",
                            icon = "fa-solid fa-utensils",
                            label = "Prepare Meals",
                        },
                        {
                            type = "client",
                            Job = Config.Job,
                            event = "r36-mcdonalds:client:slice:potatoes",
                            icon = "fa-solid fa-utensils",
                            label = "Slice Potatoes",
                        },
                        {
                            type = "client",
                            Job = Config.Job,
                            event = "r36-mcdonalds:client:slice:pickles",
                            icon = "fa-solid fa-utensils",
                            label = "Slice Pickles",
                        },
                
                    },
                    distance = 1.5
                })
                exports['qb-target']:AddBoxZone("cook", vector3(95.53, 294.7, 110.21), 1.7, 1.5, {
                    name = "cook",
                    heading = 70,
                    debugPoly = false,
                    minZ=107.01,
                    maxZ=111.01,
                }, {
                    options = {
                        {
                            type = "client",
                            Job = Config.Job,
                            event = "r36-mcdonalds:client:cook:beef",
                            icon = "fa-solid fa-fire-burner",
                            label = "Cook Beef",
                        },
                        {
                            type = "client",
                            Job = Config.Job,
                            event = "r36-mcdonalds:client:cook:chicken",
                            icon = "fa-solid fa-fire-burner",
                            label = "Cook Chicken",
                        },
                
                    },
                    distance = 1.5
                })
                exports['qb-target']:AddBoxZone("drinks", vector3(95.77, 290.86, 110.21), 5.1, 1.5, {
                    name = "drinks",
                    heading = 340,
                    debugPoly = false,
                    minZ=107.21,
                    maxZ=111.21,
                }, {
                    options = {
                        {
                            type = "client",
                            Job = Config.Job,
                            event = "r36-mcdonalds:client:get:mcdonaldr36achinecup",
                            icon = "fa-solid fa-hand-spock",
                            label = "Pick Up a McDonald's Machine Cup",
                        },
                        {
                            type = "client",
                            Job = Config.Job,
                            event = "r36-mcdonalds:client:get:mcdonaldssundeacup",
                            icon = "fa-solid fa-hand-spock",
                            label = "Pick Up a McDonald's Sundea Cup",
                        },
                        {
                            type = "client",
                            Job = Config.Job,
                            event = "r36-mcdonalds:client:drinks",
                            icon = "fa-solid fa-utensils",
                            label = "Prepare Drinks",
                        },
                        {
                            type = "client",
                            Job = Config.Job,
                            event = "r36-mcdonalds:client:deserts",
                            icon = "fa-solid fa-utensils",
                            label = "Prepare Deserts",
                        },
                
                    },
                    distance = 1.5
                })
                exports['qb-target']:AddBoxZone("fridges", vector3(89.45, 296.75, 110.21), 1.5, 1.5, {
                    name = "fridges",
                    heading = 340,
                    debugPoly = false,
                    minZ=107.81,
                    maxZ=111.81,
                }, {
                    options = {
                        {
                            type = "client",
                            Job = Config.Job,
                            event = "r36-mcdonalds:client:fridge:food",
                            icon = "fa-solid fa-shop",
                            label = "Fridge",
                        },
                
                    },
                    distance = 1.5
                })
                exports['qb-target']:AddBoxZone("washhands", vector3(97.1, 294.45, 110.21), 1.1, 1.5, {
                    name = "washhands",
                    heading = 340,
                    debugPoly = false,
                    minZ=106.41,
                    maxZ=110.41,
                }, {
                    options = {
                        {
                            type = "client",
                            Job = Config.Job,
                            event = "r36-mcdonalds:client:washHands",
                            icon = "fas fa-hand-holding-water",
                            label = "Wash Hands",
                        },
                
                    },
                    distance = 1.5
                })
                exports['qb-target']:AddGlobalPed({
                    options = {
                        {
                        type = "client",
                        event = "r36-mcdonalds:client:receipt",
                        job = Config.Job,
                        icon = 'fas fa-credit-card',
                        label = 'Give Receipt',		
                        },
                    }
                })
        
end)

-- McDonald's Garage

CreateThread(function()
    local garageZones = {}
    for k, v in pairs(Config.Locations["vehicle"]) do
        garageZones[#garageZones+1] = BoxZone:Create(
            vector3(v.x, v.y, v.z), 3, 3, {
            name="box_zone",
            debugPoly = false,
            minZ = v.z - 1,
            maxZ = v.z + 1,
        })
    end

    local garageCombo = ComboZone:Create(garageZones, {name = "garageCombo", debugPoly = false})
    garageCombo:onPlayerInOut(function(isPointInside, point)
        if isPointInside then
            inGarage = true
            if onDuty and PlayerJob.name == 'mc' then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    exports['qb-core']:DrawText('Store Vehicles', 'left')
                else
                    local currentSelection = 0

                    for k, v in pairs(Config.Locations["vehicle"]) do
                        if #(point - vector3(v.x, v.y, v.z)) < 4 then
                            currentSelection = k
                        end
                    end
                    exports['qb-menu']:showHeader({
                        {
                            header = "McDonald's Garage",
                            params = {
                                event = 'r36-mcdonalds:client:VehicleMenuHeader',
                                args = {
                                    currentSelection = currentSelection,
                                }
                            }
                        }
                    })
                end
            end
        else
            inGarage = false
            exports['qb-menu']:closeMenu()
            exports['qb-core']:HideText()
        end
    end)
end)

CreateThread(function ()
    Wait(1000)
    while true do
        local sleep = 1000
        if inGarage and PlayerJob.name == "mc" then
            if onDuty then sleep = 5 end
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                if IsControlJustReleased(0, 38) then
                    QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                end
            end
        else
            sleep = 1000
        end
        Wait(sleep)
    end
end)

