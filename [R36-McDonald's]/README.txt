## r36-mcdonalds installation guide
Step 1: go to qb-core > shared > jobs.lua

add this new job

['mc'] = {
		label = 'McDonalds',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Cleaner',
                payment = 50
            },
			['1'] = {
                name = 'Driver',
                payment = 75
            },
			['2'] = {
                name = 'Sales',
                payment = 100
            },
			['3'] = {
                name = 'Chief',
                payment = 125
            },
			['4'] = {
                name = 'CEO',
				isboss = true,
                payment = 150
            },
        },
	},

Step 2: go to qb-core > shared > items.lua - copy all the items from the items.txt and paste it there

Step 3: go to [standlone] folder > dpemotes > client > AnimationList.lua and find this

    ["drink"] = {"mp_player_intdrink", "loop_bottle", "Drink", AnimationOptions =
    {
         Prop = "prop_ld_flow_bottle",
         PropBone = 18905,
         PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0},
         EmoteMoving = true,
         EmoteLoop = true,
    }},

and replace it with this

    ["drink"] = {"mp_player_intdrink", "loop_bottle", "Drink", AnimationOptions =
    {
         Prop = "prop_ld_flow_bottle",
         PropBone = 18905,
         PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0},
         EmoteMoving = true,
         EmoteLoop = true,
    }},
    ["drink1"] = {"mp_player_intdrink", "loop_bottle", "Drink1", AnimationOptions =
    {
         Prop = "prop_ecola_can",
         PropBone = 18905,
         PropPlacement = {0.12, 0.030, 0.03, 240.0, -60.0},
         EmoteMoving = true,
         EmoteLoop = true,
    }},
    ["drink2"] = {"mp_player_intdrink", "loop_bottle", "Drink2", AnimationOptions =
    {
         Prop = "v_res_tt_can03",
         PropBone = 18905,
         PropPlacement = {0.12, 0.020, 0.03, 240.0, -60.0},
         EmoteMoving = true,
         EmoteLoop = true,
    }},
    ["drink3"] = {"mp_player_intdrink", "loop_bottle", "Drink3", AnimationOptions =
    {
         Prop = "v_ret_fh_bscup",
         PropBone = 18905,
         PropPlacement = {0.12, 0.020, 0.03, 240.0, -60.0},
         EmoteMoving = true,
         EmoteLoop = true,
    }},
    ["drink4"] = {"mp_player_intdrink", "loop_bottle", "Drink4", AnimationOptions =
    {
         Prop = "prop_food_cb_juice01",
         PropBone = 18905,
         PropPlacement = {0.12, 0.020, 0.03, 240.0, -60.0},
         EmoteMoving = true,
         EmoteLoop = true,
    }},

Step 4: go to in the downloaded rar you'll find folder called inventory-icons copy all the icons that are inside and go to 
qb-inventory > html > images and paste all of them there.


## r36-mcdonalds phone applications installation guide

Step 1: go to qb-phone > client > main.lua > search for this NUI Call back

RegisterNUICallback('SetAlertWaypoint', function(data)
    local coords = data.alert.coords
    QBCore.Functions.Notify('GPS Location set: '..data.alert.title)
    SetNewWaypoint(coords.x, coords.y)
end)

Paste this under the end) [Preview: https://imgur.com/3V9ik8r]

-- McDonald's Application Alerts
RegisterNUICallback('mix2meal', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:mix2meal", streetLabel, pos)
end)
RegisterNUICallback('sharebox', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:sharebox", streetLabel, pos)
end)
RegisterNUICallback('mcroyale', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:mcroyale", streetLabel, pos)
end)
RegisterNUICallback('bigmac', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:bigmac", streetLabel, pos)
end)
RegisterNUICallback('bigtasty', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:bigtasty", streetLabel, pos)
end)
RegisterNUICallback('doublebigtasty', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:doublebigtasty", streetLabel, pos)
end)
RegisterNUICallback('cheeseburger', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:cheeseburger", streetLabel, pos)
end)
RegisterNUICallback('bigtastychicken', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:bigtastychicken", streetLabel, pos)
end)
RegisterNUICallback('chickenmac', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:chickenmac", streetLabel, pos)
end)
RegisterNUICallback('chickenfillet', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:chickenfillet", streetLabel, pos)
end)
RegisterNUICallback('cheddarcheesefries', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:cheddarcheesefries", streetLabel, pos)
end)
RegisterNUICallback('mcnuggets', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:mcnuggets", streetLabel, pos)
end)
RegisterNUICallback('gardensalad', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:gardensalad", streetLabel, pos)
end)
RegisterNUICallback('strawberrymilkshake', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:strawberrymilkshake", streetLabel, pos)
end)
RegisterNUICallback('chocolatemilkshake', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:chocolatemilkshake", streetLabel, pos)
end)
RegisterNUICallback('vanillamilkshake', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:vanillamilkshake", streetLabel, pos)
end)
RegisterNUICallback('mcfizzbluepassion', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:mcfizzbluepassion", streetLabel, pos)
end)
RegisterNUICallback('mcfizzstrawberry', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:mcfizzstrawberry", streetLabel, pos)
end)
RegisterNUICallback('cocacola', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:cocacola", streetLabel, pos)
end)
RegisterNUICallback('cocacolazero', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:cocacolazero", streetLabel, pos)
end)
RegisterNUICallback('sprite', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:sprite", streetLabel, pos)
end)
RegisterNUICallback('fanta', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:fanta", streetLabel, pos)
end)
RegisterNUICallback('fantagreenapple', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:fantagreenapple", streetLabel, pos)
end)
RegisterNUICallback('mcfries', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:mcfries", streetLabel, pos)
    copsCalled = true
end)
RegisterNUICallback('chocolatesundea', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:chocolatesundea", streetLabel, pos)
end)
RegisterNUICallback('strawberrysundea', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:strawberrysundea", streetLabel, pos)
end)
RegisterNUICallback('applepie', function(streetLabel, coords)
        local ped = PlayerPedId()
local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 then streetLabel = streetLabel .. " " .. street2 end
    TriggerServerEvent("r36-mcdonalds:server:applepie", streetLabel, pos)
end)
-----------
Step 2: In the same file search for this event

RegisterNetEvent('qb-phone:client:addPoliceAlert', function(alertData)
    PlayerJob = QBCore.Functions.GetPlayerData().job
    if PlayerJob.name == 'police' and PlayerJob.onduty then
        SendNUIMessage({
            action = "AddPoliceAlert",
            alert = alertData,
        })
    end
end)

paste this under it

RegisterNetEvent('r36-mcdonalds:client:mcorderNotification', function(alertData)
    PlayerJob = QBCore.Functions.GetPlayerData().job
    if PlayerJob.name == 'mc' and PlayerJob.onduty then
        SendNUIMessage({
            action = "mcorderNotification",
            alert = alertData,
        })
    end
end)

---------
Step 3: go to qb-phone > config.lua [Preview: https://imgur.com/numsRMq]
Find this

["meos"] = {
        app = "meos",
        color = "#004682",
        icon = "fas fa-ad",
        tooltipText = "MDT",
        job = "police",
        blockedjobs = {},
        slot = 13,
        Alerts = 0,
    },

paste this under it 
["mc"] = {
        app = "mc",
        color = "#264e3698",
        icon = "fas fa-ad",
        tooltipText = "McDonald's Employes",
        job = "mc",
        blockedjobs = {},
        slot = 13,
        Alerts = 0,
},
["mcp"] = {
        app = "mcp",
        color = "#990808ab",
        icon = "fas fa-ad",
        tooltipText = "McDonald's",
        blockedjobs = {},
        slot = 14,
        Alerts = 0,
},
---------
Step 4: go to qb-phone > html > index.html
find this line 
    <link rel="stylesheet" href="./css/meos.css">
and paste this under it
    <link rel="stylesheet" href="./css/mcp.css">
    <link rel="stylesheet" href="./css/mc.css">

Step 5: in the same file find 
    <title>QBCore Phone</title>
and paste this above it
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

Step 6: in the same file find

<div class="advert-app">

and paste this above the line
                    <div class="mc-app">
                        <br>
                        <br>
                        <div class="mcdonalds" style="color: white;font-family: 'Anek Latin', sans-serif;font-size: 3vh;text-align: center;border-bottom: 2px solid rgb(175, 173, 25);animation: fadeIn 2s"><span style="color:yellow">M</span>cDonald's Orders</div>
                        <div class="mc-homescreen">
                            <div class="mc-alerts" style="animation: slideInLeft 0.7s;">
                            </div>
                        </div>
                            <div class="mc-alerts-page">
                                <div class="mc-alerts">
                                </div>
                            </div>
                    </div>

                    <div class="mcp-app">
                    <br>
                    <br>
                        <div class="mcdonalds" style="color: white;font-family: 'Anek Latin', sans-serif;font-size: 3vh;text-align: center;border-bottom: 2px solid rgb(175, 173, 25);animation: fadeIn 2s"><span style="color:yellow">M</span>cDonald's Menu</div>
                        <br>
                        <div class="meals">
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Mix 2 Meal</div>

                                    <img class="img" src="./img/mc/mix2meal.png" width="180">
                                    <br>
                                    <button class="order-btn" id="mix2meal">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Share Box</div>
                                    <img class="img" src="./img/mc/sharebox.png" width="180">
                                    <br>
                                    <button class="order-btn" id="sharebox">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Beef | McRoyale</div>
                                    <img class="img" src="./img/mc/mcroyal.png" width="180">
                                    <br>
                                    <button class="order-btn" id="mcroyale">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Beef | Big Mac</div>
                                    <img class="img" src="./img/mc/bigmac.png" width="180">
                                    <br>
                                    <button class="order-btn" id="bigmac">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Beef | Big Tasty</div>
                                    <img class="img" src="./img/mc/bigtasty.png" width="180">
                                    <br>
                                    <button class="order-btn" id="bigtasty">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Double Big Tasty</div>
                                    <img class="img" src="./img/mc/doublebigtasty.png" width="180">
                                    <br>
                                    <button class="order-btn" id="doublebigtasty">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Cheese Burger</div>
                                    <img class="img" src="./img/mc/cheeseburger.png" width="180">
                                    <br>
                                    <button class="order-btn" id="cheeseburger">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Chicken | Big Tasty</div>
                                    <img class="img" src="./img/mc/bigtastychicken.png" width="180">
                                    <br>
                                    <button class="order-btn" id="bigtastychicken">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Chicken Mac</div>
                                    <img class="img" src="./img/mc/chickenmac.png" width="180">
                                    <br>
                                    <button class="order-btn" id="chickenmac">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Chicken Fillet</div>
                                    <img class="img" src="./img/mc/chickenfillet.png" width="180">
                                    <br>
                                    <button class="order-btn" id="chickenfillet">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Cheddar Cheese Fries</div>
                                    <img class="img" src="./img/mc/cheddarcheesefries.png" width="180">
                                    <br>
                                    <button class="order-btn" id="cheddarcheesefries">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">McNuggets</div>
                                    <img class="img" src="./img/mc/mcnuggets.png" width="180">
                                    <br>
                                    <button class="order-btn" id="mcnuggets">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Garden Salad</div>
                                    <img class="img" src="./img/mc/gardensalad.png" width="180">
                                    <br>
                                    <button class="order-btn" id="gardensalad">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Strawbarry MilkShake</div>
                                    <img class="img" src="./img/mc/strawberrymilkshake.png" width="180">
                                    <br>
                                    <button class="order-btn" id="strawberrymilkshake">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Chocolate MilkShake</div>
                                    <img class="img" src="./img/mc/chocolatemilkshake.png" width="180">
                                    <br>
                                    <button class="order-btn" id="chocolatemilkshake">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Vanilla MilkShake</div>
                                    <img class="img" src="./img/mc/vanillamilkshake.png" width="180">
                                    <br>
                                    <button class="order-btn" id="vanillamilkshake">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">McFizz Strawberry</div>
                                    <img class="img" src="./img/mc/mcfizzstrawberry.png" width="180">
                                    <br>
                                    <button class="order-btn" id="mcfizzstrawberry">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">McFizz Blue Passion</div>
                                    <img class="img" src="./img/mc/mcfizzbluepassion.png" width="180">
                                    <br>
                                    <button class="order-btn" id="mcfizzbluepassion">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">CoCa-Cola</div>
                                    <img class="img" src="./img/mc/cocacola.png" width="180">
                                    <br>
                                    <button class="order-btn" id="cocacola">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">CoCa-Cola Zero</div>
                                    <img class="img" src="./img/mc/cocacolazero.png" width="180">
                                    <br>
                                    <button class="order-btn" id="cocacolazero">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Sprite</div>
                                    <img class="img" src="./img/mc/sprite.png" width="180">
                                    <br>
                                    <button class="order-btn" id="sprite">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Fanta</div>
                                    <img class="img" src="./img/mc/fanta.png" width="180">
                                    <br>
                                    <button class="order-btn" id="fanta">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Fanta Green Apple</div>
                                    <img class="img" src="./img/mc/fantagreenapple.png" width="180">
                                    <br>
                                    <button class="order-btn" id="fantagreenapple">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">McFires</div>
                                    <img class="img" src="./img/mc/mcfries.png" width="180">
                                    <br>
                                    <button class="order-btn" id="mcfries">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Chocolate Sundea</div>
                                    <img class="img" src="./img/mc/chocolatesundea.png" width="180">
                                    <br>
                                    <button class="order-btn" id="chocolatesundea">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Strawberry Sundea</div>
                                    <img class="img" src="./img/mc/strawberrysundea.png" width="180">
                                    <br>
                                    <button class="order-btn" id="strawberrysundea">Order Now</button>
                                </div>
                            </div>
                            <br>
                            <div class="bigmac">
                                <div class="meal-name">
                                    <div class="title">Apple Pie</div>
                                    <img class="img" src="./img/mc/applepie.png" width="180">
                                    <br>
                                    <button class="order-btn" id="applepie">Order Now</button>
                                </div>
                            </div>
                            <br>
                        </div>
                                </div>
Step 7: in the same file find
 <script src="./js/meos.js"></script>
 and paste this under it
         <script src="./js/mc.js"></script>
         <script src="./js/mcp.js"></script>

Step 8: copy the css files that are in css folder in the downloaded rar and paste it in qb-phone > html > css
Step 9: copy the js files that are in js folder in the downloaded rar resource and paste it in qb-phone > html > js
Step 10: go to the downloaded rar > mc folder > copy it and paste it in qb-phone > html > img
Step 11: go to qb-phone > fxmanifest.lua > in the files { 

    add this line  [Preview: https://imgur.com/Oe29E2S]

'html/img/mc/*.png',


Step 12: go to qb-phone > html > js > app.js [Preview: https://imgur.com/r6jSJAs]
find this line

            if (app.app == "meos") {
                icon = '<img src="./img/politie.png" class="police-icon">';
            }
and paste this under it so it looks exactly like the preview [Preview: https://imgur.com/r6jSJAs]

            if (app.app == "mc") {
                icon = '<img src="./img/mc/mc.png" class="mc-icon">';
            }
            if (app.app == "mcp") {
                icon = '<img src="./img/mc/mc.png" class="mc-icon">';
            }
Step 13: in the same file find this line

                } else if (PressedApplication == "meos") {
                    SetupMeosHome();

and paste this under it so it looks exactly like the preview [Preview: https://imgur.com/29DAYu8]

                } else if (PressedApplication == "mc") {
                    SetupmcHome();
                } else if (PressedApplication == "mcp") {
                    SetupMCPHome();

Step 14: in the same file find this line

        } else if (QB.Phone.Data.currentApplication == "meos") {
            $(".meos-alert-new").remove();
            setTimeout(function(){
                $(".meos-recent-alert").removeClass("noodknop");
                $(".meos-recent-alert").css({"background-color":"#004682"});
            }, 400)

and paste this under it [Preview: https://imgur.com/ap30H6r]

        } else if (QB.Phone.Data.currentApplication == "mc") {
            $(".mc-alert-new").remove();
            setTimeout(function(){
                $(".mc-recent-alert").removeClass("noodknop");
                $(".mc-recent-alert").css({"background-color":"#004682"});
            }, 400)
        }

Step 15: in the same file find this line

    } else if (QB.Phone.Data.currentApplication == "meos") {
        $(".meos-alert-new").remove();
        $(".meos-recent-alert").removeClass("noodknop");
        $(".meos-recent-alert").css({"background-color":"#004682"});

and paste this under it [Preview: https://imgur.com/5Z3nLPE]

/* Be careful with this and check the preview above */

    } else if (QB.Phone.Data.currentApplication == "mc") {
        $(".mc-alert-new").remove();
        $(".mc-recent-alert").removeClass("noodknop");
        $(".mc-recent-alert").css({"background-color":"#004682"});
    } 

Step 16: in the same file find this line

            case "AddPoliceAlert":
                AddPoliceAlert(event.data)
                break;
and paste this one under it [Preview: https://imgur.com/9u7jQMO]

            case "mcorderNotification":
                mcorderNotification(event.data)
                break;
