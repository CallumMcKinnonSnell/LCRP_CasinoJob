Config = {}
Config.Locale = 'en'

Config.FrontDoorCoods = vector3(925.45, 46.24, 81.11)

-- Edit as required
Config.Garage = {
    ZonePos = vector3(927.15, 23.6, 81.33),
    LoadPos = vector3(948.51, 22.4, 80.6),
    DelPos = vector3(941.28, 44.53, 81.16),
}

Config.DelDistance = 1.5

-- Vehicles the employees will be able to spawn
Config.Vehicles = {
    {label = "Porsche 2019 GT3 RS", code = "2019gt3rs"},
    {label = "Adder", code = "adder"},
    {label = "Pariah", code = "pariah"},
}

Config.SpawnPeds = true

--Job peds
Config.Peds = {
    -- Boss/Vault Ped
    {hash = "a_f_y_business_01", x = 951.51,  y = 29.03, z = 70.84, heading = 46.35 }, -- Menu Ped
    -- Lift Peds
    {hash = "s_m_y_valet_01",    x = 966.91,  y = 15.00, z = 70.84, heading = 280.0 }, -- Menu Ped
    {hash = 's_m_y_valet_01',    x = 949.26,  y = 58.63, z = 58.88, heading = 203.0}, -- Lowest Level Vault
    {hash = 's_m_y_valet_01',    x = 978.88,  y = 74.27, z = 69.23, heading = 112.0}, -- Lift behind Mgmt Doors
    {hash = 's_m_y_valet_01',    x = 952.77,  y = 57.01, z = 74.73, heading = 286.0}, -- Managers Office
    {hash = 's_m_y_valet_01',    x = 965.57,  y = 59.69, z = 111.55, heading = 69.0}, -- Rooftop
    {hash = 's_m_y_valet_01',    x = 983.00,  y = 56.84, z = 115.16, heading = 114.0}, -- Penthouse
    {hash = 's_m_y_valet_01',    x = 967.20,  y = 07.09, z = 80.16, heading = 49.19}, -- Location
}


Config.TPLocations = {
    {
        label = "cctv",
        coords = vector3(968.23, 15.65, 71.84),
        heading = 241.0,
        camHeading = 241.0,
    },
    {
        label = "vault",
        coords = vector3(950.47, 56.69, 58.88),
        heading = 237.0,
        camHeading = 237.0,
    },
    {
        label = "lower",
        coords = vector3(977.16, 73.40, 69.23),
        heading = 147.25,
        camHeading = 147.25,
    },
    {
        label = "office",
        coords = vector3(953.59, 58.31, 74.43),
        heading = 244.0,
        camHeading = 244.0,
    },
    {
        label = "roof",
        coords = vector3(964.80, 58.78, 111.55),
        heading = 59.0,
        camHeading = 59.0,
    },
    {
        label = "pent",
        coords = vector3(982.25, 55.74, 115.16),
        heading = 62.0,
        camHeading = 62.0,
    },
    {
        label = "garage",
        coords = vector3(966.17, 8.18, 80.16),
        heading = 61.0,
        camHeading = 61.0,
    },
}