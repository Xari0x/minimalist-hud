Config = {}

 -- Can be "qbcore", "esx" or "standalone".
Config.framework = "standalone" -- Default = "standalone"

 -- Toggle LegacyFuel hook.
Config.LegacyFuel = false -- Default = false

 -- Toggle pmaVoice hook.
Config.pmaVoice = false -- Default = false

 -- Configure the location component.
Config.location = {
    enabled = true, -- Default = true
    left = 310, -- Default = 310
    bottom = 30 -- Default = 30
}

 -- Defines the hud update time, a higher value may reduce script consumption.
Config.globalUpdateTime = 1 -- Default = 1

 -- Configure the speedometer component.
Config.speedometer = {
    enabled = true, -- Default = true
    bottom = -50 -- Default = -50
}

 -- Configure the status component.
Config.status = {
    enabled = true, -- Default = true
    right = 20, -- Default = 20
    bottom = 30 -- Default = 30
}

 -- Activates/deactivates GTA's vanilla hud for life and armor. [default = false]
Config.vanilla = false 

 -- Enables/disables components that may interfere with the use of this HUD. [default = true]
Config.componentsDisabler = true

 -- Enables/disables radar display only in vehicle (also affects position hud). [default = true]
Config.radarOnlyInCar = true

-- Activates/deactivates the hunger bar display. [default = true]
Config.enableHunger = true

-- Activates/deactivates the thirst bar display. [default = true]
Config.enableThirst = true

-- Activates/deactivates the seat belt display. [default = true]
Config.enableSeatBelt = true

-- Activates/deactivates the fuel level display. [default = true]
Config.enableFuel = true

-- Activates/deactivates the voice display. [default = true]
Config.enableVoice = true

-- Determines whether you want to use miles or kilometers. [default = true]
Config.useMiles = true

-- List of electric vehicles.
Config.electricVehicles = {
    "buffalo5",
    "cyclone",
    "cyclone2",
    "dilettante",
    "dilettante2",
    "iwagen",
    "imorgon",
    "khamelion",
    "coureur",
    "neon",
    "omnisegt",
    "powersurge",
    "raiden",
    "voltic2",
    "surge",
    "tezeract",
    "virtue",
    "voltic",
    "caddy",
    "caddy2",
    "caddy3",
    "airtug"
}