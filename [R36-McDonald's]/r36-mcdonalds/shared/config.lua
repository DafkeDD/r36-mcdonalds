Config = {}

Config.Blip = {
     ["main"] = {
        label = "McDonald's",
        coords = vector3(80.94, 272.66, 109.96),
     } 
}

Config.Job = "mc"

Config.Locations = {
    ["vehicle"] = {
        [1] = vector4(92.1, 308.83, 109.61, 158.75),
        [2] = vector4(95.86, 307.83, 109.61, 158.76),
        [3] = vector4(99.38, 306.63, 109.61, 159.3),
        [4] = vector4(102.75, 305.42, 109.61, 158.93),
    },
}

Config.AuthorizedVehicles = {
	-- Grade 0
	[0] = {
		["faggio2"] = "McDonald's Motorcycle",
	}
}


Config.Clothes = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0, -- pants 24-4, shoes 10-0 arm 40 hats 142-0
        ['torso_1'] = 3,   ['torso_2'] = 0,
        ['arms'] = 41,
        ['pants_1'] = 24,   ['pants_2'] = 0,
        ['shoes_1'] = 10,   ['shoes_2'] = 0,
        ['helmet_1'] = 142,  ['helmet_2'] = 0,
        ['ears_1'] = -1,  ['ears_2'] = 0,
    },
    female = {
        ['tshirt_1'] = -1,  ['tshirt_2'] = 0,
        ['torso_1'] = 3,   ['torso_2'] = 1,
        ['arms'] = 44,
        ['pants_1'] = 6,   ['pants_2'] = 0,
        ['shoes_1'] = 29,   ['shoes_2'] = 0,
        ['helmet_1'] = 141,  ['helmet_2'] = 0,
        ['ears_1'] = -1,  ['ears_2'] = 0,
    }
}

ConsumeablesEat = {
    ["mix2meal"] = math.random(35, 54),
    ["sharebox"] = math.random(35, 54),
    ["mcroyale"] = math.random(35, 54),
    ["bigmac"] = math.random(35, 54),
    ["bigtasty"] = math.random(35, 54),
    ["doublebigtasty"] = math.random(35, 54),
    ["cheeseburger"] = math.random(35, 54),
    ["bigtastychicken"] = math.random(35, 54),
    ["chickenmac"] = math.random(35, 54),
    ["chickenfillet"] = math.random(35, 54),
    ["cheddarcheesefries"] = math.random(35, 54),
    ["mcnuggetschicken"] = math.random(35, 54),
    ["gardensalad"] = math.random(35, 54),
    ["mcfries"] = math.random(35, 54),
    ["applepie"] = math.random(35, 54),
}

ConsumeablesDrink = {
    ["strawberrymilkshake"] = math.random(40, 50),
    ["chocolatemilkshake"] = math.random(40, 50),
    ["vanillamilkshake"] = math.random(40, 50),
    ["mcfizzbluepassion"] = math.random(40, 50),
    ["mcfizzstrawberry"] = math.random(40, 50),
    ["cocacola"] = math.random(40, 50),
    ["cocacolazero"] = math.random(40, 50),
    ["sprite"] = math.random(40, 50),
    ["fanta"] = math.random(40, 50),
    ["fantagreenapple"] = math.random(40, 50),
}

Config.Food = {
    label = "McDonald's Fridge",
        slots = 17,
        items = {
            [1] = {
                name = "beef",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 1,
            },
            [2] = {
                name = "chickenpeace",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 2,
            },
            [3] = {
                name = "lettuce",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 3,
            },
            [4] = {
                name = "bun",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 4,
            },
            [5] = {
                name = "tomatoes",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 5,
            },
            [6] = {
                name = "pickle",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 6,
            },
            [7] = {
                name = "cheedercheese",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 7,
            },
            [8] = {
                name = "strawberry",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 8,
            },
            [9] = {
                name = "chocolate",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 9,
            },
            [10] = {
                name = "vanilla",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 10,
            },
            [11] = {
                name = "potatoes",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 11,
            },
            [12] = {
                name = "apple",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 12,
            },
            [13] = {
                name = "bakedlatticecrust",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 13,
            },
            [14] = {
                name = "lemon",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 14,
            },
            [15] = {
                name = "sugure",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 15,
            },
            [16] = {
                name = "syrup",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 16,
            },
            [17] = {
                name = "steam",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 17,
            },
            [18] = {
                name = "milk",
                price = 0,
                amount = 500,
                info = {},
                type = "item",
                slot = 18,
            },
        }
}