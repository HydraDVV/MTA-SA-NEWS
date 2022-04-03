settings = {
    item = "client_items",
    global = "client_global",
    mysql = "client_mysql",
        
    skins = {280, 281, 282, 283, 284}, -- erkek1, erkek2, erkek3, kadın1, kadın2

    dutyVehicles = { -- MTA ARAÇ MODELİDİR! (https://wiki.multitheftauto.com/wiki/Vehicle_IDs)
        [528] = true, -- FBI Truck
        [490] = true, -- FBI Rancher
        [427] = true, -- Enforcer
        [596] = true, -- Police LS
        [597] = true, -- Police SF
        [598] = true, -- Police LS
        [599] = true, -- Police Ranger
        [601] = true, -- S.W.A.T.
        [428] = true, -- Securicar
    },

    colshapes = {
        -- x, y, z, büyüklük, interior, dimension
        [1] = {935.9072265625, -1432.681640625, 30.7734375, 3, 0, 0},
        [2] = {939.173828125, -1447.556640625, 30.7734375, 3, 0, 0},
    }
}

shared_dutyPerks = {
    [1] = {
        weapons = {24}, -- deagle
    },

    [2] = {
        weapons = {24, 25}, -- deagle, shotgun
    },

    [3] = {
        weapons = {24, 25, 29}, -- deagle, shotgun, mp5
    },

    [4] = {
        weapons = {24, 25, 29, 31}, -- deagle, shotgun, mp5, mp4
    },

    [5] = {
        weapons = {24, 25, 27, 29, 31, 34}, -- deagle, shotgun, mp5, m4, sniper
    },
}