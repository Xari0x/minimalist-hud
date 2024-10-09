local playerId = PlayerId()
local playerPed = PlayerPedId()
local playerCoords = GetEntityCoords(playerPed)
local inVehicle = IsPedInAnyVehicle(playerPed)

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        inVehicle = IsPedInAnyVehicle(playerPed)

        Citizen.Wait(100)
    end
end)

local hudVisible = true
local QBCore = nil

exports('hudVisibility', function(toggle)
    hudVisible = toggle
end)

--
-- HIDE HEALTH
--

Citizen.CreateThread(function()
    local scaleform = RequestScaleformMovie('minimap')

    SetRadarBigmapEnabled(true, false)

    Citizen.Wait(0)

    SetRadarBigmapEnabled(false, false)

    while true do
        BeginScaleformMovieMethod(scaleform, 'SETUP_HEALTH_ARMOUR')

        if Config.vanilla then
            ScaleformMovieMethodAddParamInt(1)
            EndScaleformMovieMethod()
            return
        end

        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        SetRadarBigmapEnabled(false, false)

        Citizen.Wait(0)
    end
end)

--
-- HUD COMPONENTS
--

if Config.componentsDisabler then
    Citizen.CreateThread(function()
        while true do
            HideHudComponentThisFrame(1)
            HideHudComponentThisFrame(3)
            HideHudComponentThisFrame(4)
            HideHudComponentThisFrame(6)
            HideHudComponentThisFrame(8)
            HideHudComponentThisFrame(7)
            HideHudComponentThisFrame(9)

            Citizen.Wait(0)
        end
    end)
end

--
-- RADAR IN VEHICLE
--

local bypass = false

exports('bypassRadar', function(toggle)
    bypass = toggle
end)

Citizen.CreateThread(function()
    DisplayRadar(true)

    if not Config.radarOnlyInCar then
        return
    end

    while true do
        if bypass then
            DisplayRadar(true)
        else
            if not inVehicle then
                DisplayRadar(false)
            else
                DisplayRadar(true)
            end
        end

        Citizen.Wait(1000)
    end
end)

--
-- HUD LOCATION
--

local activeCoords = vec2(0.0, 0.0)
local postalText = 'CP 0000'
local directionText = 'N'
local postals = {}
local zones = {}

Citizen.CreateThread(function()
    local postalsJson = LoadResourceFile(GetCurrentResourceName(), 'zips.json')
    postalsJson = json.decode(postalsJson)

    for i, postal in ipairs(postalsJson) do
        postals[i] = { vec2(postal.x, postal.y), code = postal.code }
    end

    local zonesJson = LoadResourceFile(GetCurrentResourceName(), 'zones.json')
    zonesJson = json.decode(zonesJson)

    for _, zone in pairs(zonesJson) do
        zones[zone.zone] = zone.name
    end
end)

Citizen.CreateThread(function()
    while not postals do
        Citizen.Wait(0)
    end

    while true do
        local nearestIndex, nearestDist

        for i = 1, #postals do
            local dist = #(playerCoords.xy - postals[i][1])

            if not nearestDist or dist < nearestDist then
                nearestIndex = i
                nearestDist = dist
                activeCoords = postals[i][1]
            end
        end

        local code = postals[nearestIndex].code

        postalText = string.format('CP %s', code)

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', }

    while true do
        for k, v in pairs(directions) do
            direction = GetEntityHeading(playerPed)

            if math.abs(direction - k) < 22.5 then
                directionText = v
                break
            end
        end

        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if not IsRadarHidden() and Config.location.enabled and hudVisible then
            local zone = GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z)
            local streetname, _ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
            local streetnameText = GetStreetNameFromHashKey(streetname)
            local dist = #(playerCoords.xy - activeCoords)
            local distanceText = string.format('%sm', math.floor(dist))
            local zoneText = streetnameText

            if zones[string.upper(zone)] then
                zoneText = zones[string.upper(zone)]
            end

            SendNUIMessage({
                component = 'position',
                heading = GetEntityHeading(playerPed),
                postal = postalText,
                direction = directionText,
                distance = distanceText,
                street = streetnameText,
                zone = zoneText
            })
        else
            SendNUIMessage({
                component = 'position',
                visible = false
            })
        end

        Citizen.Wait(Config.globalUpdateTime)
    end
end)

--
-- HUD STATUS
--

local hunger = 100
local thirst = 100
local voice_type = 'mic_mute.png'
local voice_talking = false
local voice_radio = false

exports('setThirst', function(val)
    thirst = val
end)

exports('setHunger', function(val)
    hunger = val
end)

exports('setVoiceDistance', function(val)
    if val == 0 then
        voice_type = 'mic_mute.png'
    elseif val == 1 then
        voice_type = 'mic_one.png'
    elseif val == 2 then
        voice_type = 'mic_two.png'
    elseif val == 3 then
        voice_type = 'mic_three.png'
    end
end)

exports('setVoiceRadio', function(toggle)
    voice_radio = toggle
end)

exports('setVoiceTalking', function(toggle)
    voice_talking = toggle
end)

Citizen.CreateThread(function()
    if Config.framework == 'esx' then
        AddEventHandler('esx_status:onTick', function(data)
            for i = 1, #data do
                if data[i].name == 'thirst' then
                    thirst = math.floor(data[i].percent)
                end

                if data[i].name == 'hunger' then
                    hunger = math.floor(data[i].percent)
                end
            end
        end)
    end

    if Config.framework == 'qbcore' then
        QBCore = exports['qb-core']:GetCoreObject()
    end

    while true do
        ::redo::

        Citizen.Wait(Config.globalUpdateTime)

        local voice = voice_type

        if voice_radio then
            voice = 'mic_radio.png'
        end

        if Config.status.enabled and hudVisible then
            if Config.framework == 'qbcore' then
                local PlayerData = QBCore.Functions.GetPlayerData()

                if (PlayerData.metadata ~= nil) then
                    hunger = PlayerData.metadata['hunger']
                    thirst = PlayerData.metadata['thirst']
                else
                    SendNUIMessage({
                        component = 'status',
                        visible = false
                    })

                    goto redo
                end
            end

            if Config.pmaVoice then
                exports['jordqn_hud']:setVoiceDistance(LocalPlayer.state.proximity.index)

                if not MumbleIsPlayerTalking(playerId) then
                    voice_talking = false
                else
                    voice_talking = true
                end
            end

            SendNUIMessage({
                component = 'status',
                framework = Config.framework,
                hungerVisible = Config.enableHunger,
                thirstVisible = Config.enableThirst,
                voiceVisible = Config.enableVoice,
                voiceType = voice,
                voiceTalking = voice_talking,
                health = GetEntityHealth(playerPed),
                maxhealth = GetEntityMaxHealth(playerPed),
                armor = GetPedArmour(playerPed),
                hunger = hunger,
                thirst = thirst,
                oxygen = GetPlayerUnderwaterTimeRemaining(playerId)
            })
        else
            SendNUIMessage({
                component = 'status',
                visible = false
            })
        end
    end
end)

--
-- PMA VOICE
--

if Config.pmaVoice then
    AddEventHandler('pma-voice:radioActive', function(toggle)
        voice_radio = toggle
    end)
end

--
-- HUD SPEEDOMETER
--

local seatbelt = false

exports('setSeatBelt', function(toggle)
    seatbelt = toggle
end)

Citizen.CreateThread(function()
    while true do
        if Config.speedometer.enabled and hudVisible then
            if inVehicle then
                local vehicle = GetVehiclePedIsIn(playerPed, false)

                if DoesEntityExist(vehicle) then
                    local multipler = Config.useMiles and 2.236936 or 3.6
                    local maxSpeed = GetVehicleEstimatedMaxSpeed(vehicle) * multipler
                    local speed = GetEntitySpeed(vehicle) * multipler
                    local maxFuel = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fPetrolTankVolume')
                    local fuel = GetVehicleFuelLevel(vehicle)
                    local hasMotor = true
                    local isElectric = false

                    if maxFuel < 5.0 then
                        hasMotor = false
                    end

                    if Config.LegacyFuel then
                        fuel = math.floor(exports['LegacyFuel']:GetFuel(vehicle))
                    end

                    local model = GetEntityModel(vehicle)

                    for _, v in pairs(Config.electricVehicles) do
                        if v == model then
                            isElectric = true
                            break
                        end
                    end

                    local _, _, highbeams = GetVehicleLightsState(vehicle)

                    SendNUIMessage({
                        component = 'speedometer',
                        framework = Config.framework,
                        seatbeltVisible = Config.enableSeatBelt,
                        fuelVisible = Config.enableFuel,
                        useMiles = Config.useMiles,
                        speed = speed,
                        maxspeed = maxSpeed,
                        fuel = fuel,
                        hasmotor = hasMotor,
                        iselectric = isElectric,
                        maxfuel = maxFuel,
                        highbeams = highbeams,
                        engine = GetIsVehicleEngineRunning(vehicle),
                        seatbelt = seatbelt
                    })
                else
                    SendNUIMessage({
                        component = 'speedometer',
                        visible = false
                    })
                end
            else
                SendNUIMessage({
                    component = 'speedometer',
                    visible = false
                })
            end
        else
            SendNUIMessage({
                component = 'speedometer',
                visible = false
            })
        end

        Citizen.Wait(Config.globalUpdateTime)
    end
end)

--
-- CONFIGURATION
--

Citizen.CreateThread(function()
    SendNUIMessage({
        component = 'configuration',
        locationleft = Config.location.left,
        locationbottom = Config.location.bottom,
        statusright = Config.status.right,
        statusbottom = Config.status.bottom,
        speedometerbottom = Config.speedometer.bottom
    })
end)
