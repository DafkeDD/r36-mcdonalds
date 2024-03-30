
local QBCore = exports['qb-core']:GetCoreObject()

-- Functions

local function UpdateBlips()
    local dutyPlayers = {}
    local players = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(players) do
        if (v.PlayerData.job.name == Config.Job and v.PlayerData.job.onduty) then
            local coords = GetEntityCoords(GetPlayerPed(v.PlayerData.source))
            local heading = GetEntityHeading(GetPlayerPed(v.PlayerData.source))
            dutyPlayers[#dutyPlayers+1] = {
                source = v.PlayerData.source,
                label = "McDonald's Employee".."["..v.PlayerData.metadata["callsign"].."]",
                job = v.PlayerData.job.name,
                location = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    w = heading
                }
            }
        end
    end
    TriggerClientEvent("r36-mcdonalds:client:UpdateBlips", -1, dutyPlayers)
end

local function GetCurrentmcemployes()
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == Config.Job and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    return amount
end

RegisterNetEvent('r36-mcdonalds:server:UpdateCurrentmcemployes', function()
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == Config.Job and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    TriggerClientEvent("r36-mcdonalds:SetmcemployesCount", -1, amount)
end)

-- CallBacks
QBCore.Functions.CreateCallback('r36-mcdonalds:server:cook_beef', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local beef = Player.Functions.GetItemByName("beef")
    if beef ~= nil then
        cb(true)
    else
        cb(false)
    end
end)
QBCore.Functions.CreateCallback('r36-mcdonalds:server:cook_chicken', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local chickenpeace = Player.Functions.GetItemByName("chickenpeace")
    if chickenpeace ~= nil then
        cb(true)
    else
        cb(false)
    end
end)
QBCore.Functions.CreateCallback('r36-mcdonalds:server:getmix2meal', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cheeseburger = Player.Functions.GetItemByName("cheeseburger")
    local chickenmac = Player.Functions.GetItemByName("chickenmac")
    local mcfries = Player.Functions.GetItemByName("mcfries")
    local mcfizzbluepassion = Player.Functions.GetItemByName("mcfizzbluepassion")
    local mcfizzstrawberry = Player.Functions.GetItemByName("mcfizzstrawberry")
    if cheeseburger ~= nil and chickenmac ~= nil and mcfries ~= nil and mcfizzbluepassion ~= nil and mcfizzstrawberry ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:getsharebox', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cheeseburger = Player.Functions.GetItemByName("cheeseburger")
    local chickenmac = Player.Functions.GetItemByName("chickenmac")
    local bigtastychicken = Player.Functions.GetItemByName("bigtastychicken")
    local bigmac = Player.Functions.GetItemByName("bigmac")
    local mcfries = Player.Functions.GetItemByName("mcfries")
    local mcfizzbluepassion = Player.Functions.GetItemByName("mcfizzbluepassion")
    local mcfizzstrawberry = Player.Functions.GetItemByName("mcfizzstrawberry")
    local cocacola = Player.Functions.GetItemByName("cocacola")
    local sprite = Player.Functions.GetItemByName("sprite")

    if cheeseburger ~= nil and chickenmac ~= nil and bigtastychicken ~= nil and bigmac ~= nil and mcfries ~= nil and mcfizzbluepassion ~= nil and mcfizzstrawberry ~= nil and cocacola ~= nil and sprite ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:mcroyale', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cooked_beef = Player.Functions.GetItemByName("cooked_beef")
    local slicedpickles = Player.Functions.GetItemByName("slicedpickles")
    local cheese = Player.Functions.GetItemByName("cheese")
    local lettuce = Player.Functions.GetItemByName("lettuce")
    local bun = Player.Functions.GetItemByName("bun")
    local tomatoes = Player.Functions.GetItemByName("tomatoes")
    if cooked_beef ~= nil and slicedpickles ~= nil and cheese ~= nil and lettuce ~= nil and bun ~= nil and tomatoes ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:bigmac', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cooked_beef = Player.Functions.GetItemByName("cooked_beef")
    local cheese = Player.Functions.GetItemByName("cheese")
    local lettuce = Player.Functions.GetItemByName("lettuce")
    local bun = Player.Functions.GetItemByName("bun")
    local tomatoes = Player.Functions.GetItemByName("tomatoes")
    if cooked_beef ~= nil and cheese ~= nil and lettuce ~= nil and bun ~= nil and tomatoes ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:bigtasty', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cooked_beef = Player.Functions.GetItemByName("cooked_beef")
    local cheese = Player.Functions.GetItemByName("cheese")
    local lettuce = Player.Functions.GetItemByName("lettuce")
    local bun = Player.Functions.GetItemByName("bun")
    local tomatoes = Player.Functions.GetItemByName("tomatoes")
    if cooked_beef ~= nil and cheese ~= nil and lettuce ~= nil and bun ~= nil and tomatoes ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:chickenmac', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local chickenpeace = Player.Functions.GetItemByName("chickenpeace")
    local lettuce = Player.Functions.GetItemByName("lettuce")
    local bun = Player.Functions.GetItemByName("bun")
    if chickenpeace ~= nil and lettuce ~= nil and bun ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:chickenfillet', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local chickenpeace = Player.Functions.GetItemByName("chickenpeace")
    local lettuce = Player.Functions.GetItemByName("lettuce")
    local bun = Player.Functions.GetItemByName("bun")
    local tomatoes = Player.Functions.GetItemByName("tomatoes")
    if chickenpeace ~= nil and lettuce ~= nil and bun ~= nil and tomatoes ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:cheddarcheesefries', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local slicedpotatoes = Player.Functions.GetItemByName("slicedpotatoes")
    local cheedercheese = Player.Functions.GetItemByName("cheedercheese")
    if slicedpotatoes ~= nil and cheedercheese ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:mcnuggets', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local chickenpeace = Player.Functions.GetItemByName("chickenpeace")
    if chickenpeace ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:gardensalad', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local lettuce = Player.Functions.GetItemByName("lettuce")
    local tomatoes = Player.Functions.GetItemByName("tomatoes")
    if lettuce ~= nil and tomatoes ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:strawberrymilkshake', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local strawberry = Player.Functions.GetItemByName("strawberry")
    local milk = Player.Functions.GetItemByName("milk")
    local sugure = Player.Functions.GetItemByName("sugure")
    local mcdonaldr36achinecup = Player.Functions.GetItemByName("mcdonaldr36achinecup")
    if strawberry ~= nil and milk ~= nil and sugure ~= nil and mcdonaldr36achinecup ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:chocolatemilkshake', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local chocolate = Player.Functions.GetItemByName("chocolate")
    local milk = Player.Functions.GetItemByName("milk")
    local sugure = Player.Functions.GetItemByName("sugure")
    local mcdonaldr36achinecup = Player.Functions.GetItemByName("mcdonaldr36achinecup")
    if chocolate ~= nil and milk ~= nil and sugure ~= nil and mcdonaldr36achinecup ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:vanillamilkshake', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local vanilla = Player.Functions.GetItemByName("vanilla")
    local milk = Player.Functions.GetItemByName("milk")
    local sugure = Player.Functions.GetItemByName("sugure")
    local mcdonaldr36achinecup = Player.Functions.GetItemByName("mcdonaldr36achinecup")
    if vanilla ~= nil and milk ~= nil and sugure ~= nil and mcdonaldr36achinecup ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:mcfizzbluepassion', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local syrup = Player.Functions.GetItemByName("syrup")
    local lemon = Player.Functions.GetItemByName("lemon")
    local steam = Player.Functions.GetItemByName("steam")
    local sugure = Player.Functions.GetItemByName("steam")
    local mcdonaldr36achinecup = Player.Functions.GetItemByName("mcdonaldr36achinecup")
    if syrup ~= nil and lemon ~= nil and steam ~= nil and sugure ~= nil and mcdonaldr36achinecup ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:mcfizzstrawberry', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local syrup = Player.Functions.GetItemByName("syrup")
    local strawberry = Player.Functions.GetItemByName("strawberry")
    local steam = Player.Functions.GetItemByName("steam")
    local sugure = Player.Functions.GetItemByName("steam")
    local mcdonaldr36achinecup = Player.Functions.GetItemByName("mcdonaldr36achinecup")
    if syrup ~= nil and strawberry ~= nil and steam ~= nil and sugure ~= nil and mcdonaldr36achinecup ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:mcdonaldr36achinecup', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local mcdonaldr36achinecup = Player.Functions.GetItemByName("mcdonaldr36achinecup")
    if mcdonaldr36achinecup ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:mcfries', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local slicedpotatoes = Player.Functions.GetItemByName("slicedpotatoes")
    if slicedpotatoes ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:chocolatesundea', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local chocolate = Player.Functions.GetItemByName("chocolate")
    local milk = Player.Functions.GetItemByName("milk")
    local sundeacup = Player.Functions.GetItemByName("sundeacup")
    if chocolate ~= nil and milk ~= nil and sundeacup ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:strawberrysundea', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local strawberry = Player.Functions.GetItemByName("strawberry")
    local milk = Player.Functions.GetItemByName("milk")
    local sundeacup = Player.Functions.GetItemByName("sundeacup")
    if strawberry ~= nil and milk ~= nil and sundeacup ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:applepie', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local apple = Player.Functions.GetItemByName("apple")
    local bakedlatticecrust = Player.Functions.GetItemByName("bakedlatticecrust")
    if bakedlatticecrust ~= nil and apple ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:slicepotatoes', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local potatoes = Player.Functions.GetItemByName("potatoes")
    if potatoes ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('r36-mcdonalds:server:slicepickles', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pickle = Player.Functions.GetItemByName("pickle")
    if pickle ~= nil then
        cb(true)
    else
        cb(false)
    end
end)
-- Events
RegisterNetEvent('r36-mcdonalds:server:mix2meal', function(streetLabel, coords)
    local orderName = "Mix 2 Meal"
    local msg = ""
        bankLabel = "Mix 2 Meal"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Mix 2 Meal",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:sharebox', function(streetLabel, coords)
    local orderName = "Share Box"
    local msg = ""
        bankLabel = "Share Box"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Share Box",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:mcroyale', function(streetLabel, coords)
    local orderName = "McRoyale"
    local msg = ""
        bankLabel = "McRoyale"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "McRoyale",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:bigmac', function(streetLabel, coords)
    local orderName = "Big Mac"
    local msg = ""
        bankLabel = "Big Mac"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Big Mac",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:bigtasty', function(streetLabel, coords)
    local orderName = "Big Tasty"
    local msg = ""
        bankLabel = "Big Tasty"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Big Tasty",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:doublebigtasty', function(streetLabel, coords)
    local orderName = "Double Big Tasty"
    local msg = ""
        bankLabel = "Double Big Tasty"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Double Big Tasty",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:cheeseburger', function(streetLabel, coords)
    local orderName = "Cheese Burger"
    local msg = ""
        bankLabel = "Cheese Burger"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Cheese Burger",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:bigtastychicken', function(streetLabel, coords)
    local orderName = "Big Tasty Chicken"
    local msg = ""
        bankLabel = "Big Tasty Chicken"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Big Tasty Chicken",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:chickenmac', function(streetLabel, coords)
    local orderName = "Chicken Mac"
    local msg = ""
        bankLabel = "Chicken Mac"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Chicken Mac",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:chickenfillet', function(streetLabel, coords)
    local orderName = "Chicken Fillet"
    local msg = ""
        bankLabel = "Chicken Fillet"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Chicken Fillet",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:cheddarcheesefries', function(streetLabel, coords)
    local orderName = "Cheddar Cheese Fries"
    local msg = ""
        bankLabel = "Cheddar Cheese Fries"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Cheddar Cheese Fries",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:mcnuggets', function(streetLabel, coords)
    local orderName = "McNuggets"
    local msg = ""
        bankLabel = "McNuggets"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "McNuggets",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:gardensalad', function(streetLabel, coords)
    local orderName = "Garden Salad"
    local msg = ""
        bankLabel = "Garden Salad"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Garden Salad",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:strawberrymilkshake', function(streetLabel, coords)
    local orderName = "Strawberry MilkShake"
    local msg = ""
        bankLabel = "Strawberry MilkShake"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Strawberry MilkShake",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:chocolatemilkshake', function(streetLabel, coords)
    local orderName = "Chocolate MilkShake"
    local msg = ""
        bankLabel = "Chocolate MilkShake"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Chocolate MilkShake",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:vanillamilkshake', function(streetLabel, coords)
    local orderName = "Vanilla MilkShake"
    local msg = ""
        bankLabel = "Vanilla MilkShake"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Vanilla MilkShake",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:mcfizzbluepassion', function(streetLabel, coords)
    local orderName = "McFizz Blue Passion"
    local msg = ""
        bankLabel = "McFizz Blue Passion"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "McFizz Blue Passion",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:mcfizzstrawberry', function(streetLabel, coords)
    local orderName = "McFizz Strawberry"
    local msg = ""
        bankLabel = "McFizz Strawberry"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "McFizz Strawberry",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:cocacola', function(streetLabel, coords)
    local orderName = "Coca-Cola"
    local msg = ""
        bankLabel = "Coca-Cola"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Coca-Cola",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:cocacolazero', function(streetLabel, coords)
    local orderName = "Coca-Cola Zero"
    local msg = ""
        bankLabel = "Coca-Cola Zero"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Coca-Cola Zero",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:sprite', function(streetLabel, coords)
    local orderName = "Sprite"
    local msg = ""
        bankLabel = "Sprite"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Sprite",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:fanta', function(streetLabel, coords)
    local orderName = "Fanta"
    local msg = ""
        bankLabel = "Fanta"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Fanta",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:fantagreenapple', function(streetLabel, coords)
    local orderName = "Fanta Green Apple"
    local msg = ""
        bankLabel = "Fanta Green Apple"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Fanta Green Apple",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:mcfries', function(streetLabel, coords)
    local orderName = "McFries"
    local msg = ""
        bankLabel = "McFries"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "McFries",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:chocolatesundea', function(streetLabel, coords)
    local orderName = "Chocolate Sundea"
    local msg = ""
        bankLabel = "Chocolate Sundea"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Chocolate Sundea",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:strawberrysundea', function(streetLabel, coords)
    local orderName = "Strawberry Sundea"
    local msg = ""
        bankLabel = "Strawberry Sundea"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Strawberry Sundea",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:applepie', function(streetLabel, coords)
    local orderName = "Apple Pie"
    local msg = ""
        bankLabel = "Apple Pie"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Apple Pie",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

RegisterNetEvent('r36-mcdonalds:server:water', function(streetLabel, coords)
    local orderName = "Water Bottle"
    local msg = ""
        bankLabel = "Water Bottle"
        msg = orderName.. " at " ..streetLabel..""
    local alertData = {
        title = "Water Bottle",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("r36-mcdonalds:client:mcorderNotification", -1, alertData)
end)

-- Receipt Event

RegisterServerEvent("r36-mcdonalds:bill:player")
AddEventHandler("r36-mcdonalds:bill:player", function(playerId, amount)
        local biller = QBCore.Functions.GetPlayer(source)
        local billed = QBCore.Functions.GetPlayer(tonumber(playerId))
        local amount = tonumber(amount)
        if biller.PlayerData.job.name == 'mc' then
            if billed ~= nil then
                if biller.PlayerData.citizenid ~= billed.PlayerData.citizenid then
                    if amount and amount > 0 then
                        MySQL.Async.insert(
                        'INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (?, ?, ?, ?, ?)',
                        {billed.PlayerData.citizenid, amount, biller.PlayerData.job.name,
                         biller.PlayerData.charinfo.firstname, biller.PlayerData.citizenid})
                        TriggerClientEvent('qb-phone:RefreshPhone', billed.PlayerData.source)
                        TriggerClientEvent('QBCore:Notify', source, 'Receipt have been sent', 'success')
                        TriggerClientEvent('QBCore:Notify', billed.PlayerData.source, 'Receieved a New Receipt')
                    else
                        TriggerClientEvent('QBCore:Notify', source, 'Price Must be above zero', 'error')
                    end
                else
                    TriggerClientEvent('QBCore:Notify', source, 'You can not bill yourself', 'error')
                end
            else
                TriggerClientEvent('QBCore:Notify', source, 'Player does not exist', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', source, 'No Access', 'error')
        end
end)


-- Itmes Events

QBCore.Functions.CreateUseableItem("mix2meal", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:usemix2meal", src, item.name)
end)
QBCore.Functions.CreateUseableItem("sharebox", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:usesharebox", src, item.name)
end)
QBCore.Functions.CreateUseableItem("mcroyale", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mceat", src, item.name)
end)
QBCore.Functions.CreateUseableItem("bigmac", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mceat", src, item.name)
end)
QBCore.Functions.CreateUseableItem("bigtasty", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mceat", src, item.name)
end)
QBCore.Functions.CreateUseableItem("doublebigtasty", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mceat", src, item.name)
end)
QBCore.Functions.CreateUseableItem("cheeseburger", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mceat", src, item.name)
end)
QBCore.Functions.CreateUseableItem("bigtastychicken", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mceat", src, item.name)
end)
QBCore.Functions.CreateUseableItem("chickenmac", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mceat", src, item.name)
end)
QBCore.Functions.CreateUseableItem("chickenfillet", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mceat", src, item.name)
end)
QBCore.Functions.CreateUseableItem("cheddarcheesefries", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mceat", src, item.name)
end)
QBCore.Functions.CreateUseableItem("mcnuggets", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mceat", src, item.name)
end)
QBCore.Functions.CreateUseableItem("gardensalad", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mceat", src, item.name)
end)
QBCore.Functions.CreateUseableItem("strawberrymilkshake", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)
QBCore.Functions.CreateUseableItem("chocolatemilkshake", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)
QBCore.Functions.CreateUseableItem("vanillamilkshake", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)
QBCore.Functions.CreateUseableItem("mcfizzbluepassion", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)
QBCore.Functions.CreateUseableItem("mcfizzstrawberry", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)
QBCore.Functions.CreateUseableItem("cocacola", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)
QBCore.Functions.CreateUseableItem("cocacolazero", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)
QBCore.Functions.CreateUseableItem("sprite", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)
QBCore.Functions.CreateUseableItem("fanta", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)
QBCore.Functions.CreateUseableItem("fantagreenapple", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)
QBCore.Functions.CreateUseableItem("mcfries", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mceat", src, item.name)
end)
QBCore.Functions.CreateUseableItem("chocolatesundea", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)
QBCore.Functions.CreateUseableItem("applepie", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)
QBCore.Functions.CreateUseableItem("strawberrysundea", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("r36-mcdonalds:client:mcdrink", src, item.name)
end)


-- Threads
CreateThread(function()
    while true do
        Wait(1000 * 60 * 10)
        local curmcemployes = GetCurrentmcemployes()
        TriggerClientEvent("r36-mcdonalds:SetmcemployesCount", -1, curmcemployes)
    end
end)

CreateThread(function()
    while true do
        Wait(5000)
        UpdateBlips()
    end
end)
