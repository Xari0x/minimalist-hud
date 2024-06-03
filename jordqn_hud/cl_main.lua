postals = nil
zones = {}

--
-- HIDE HEALTH
--

Citizen.CreateThread(function()
    local scaleform = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
		Citizen.Wait(1)
        BeginScaleformMovieMethod(scaleform, "SETUP_HEALTH_ARMOUR")
        if Config.vanilla == true then
            ScaleformMovieMethodAddParamInt(1)
            EndScaleformMovieMethod()
            return
        end
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

--
-- HUD COMPONENTS
--

Citizen.CreateThread(function()
    if Config.componentsDisabler == false then return end
    while true do

        HideHudComponentThisFrame(1)
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(9)

		Citizen.Wait(1)
	end
end)

--
-- RADAR IN VEHICLE
--

local bypass = false
exports("bypassRadar", function(toggle)
    bypass = toggle
end)

Citizen.CreateThread(function()
    DisplayRadar(true)
    if Config.radarOnlyInCar == false then return end
    while true do
        if(bypass) then
            DisplayRadar(true)
        else
            if not IsPedInAnyVehicle(PlayerPedId()) then
                DisplayRadar(false)
            elseif IsPedInAnyVehicle(PlayerPedId()) then
                DisplayRadar(true)
            end
        end
		Citizen.Wait(1000)
	end
end)

-- 
-- HUD LOCATION
-- 

local activeCoords
local postalText = "CP 0000"
local directionText = "N"
local distanceText = "0m"

Citizen.CreateThread(function()
    local zonesJson = nil
    postals = LoadResourceFile(GetCurrentResourceName(), 'zips.json')
    zonesJson = LoadResourceFile(GetCurrentResourceName(), 'zones.json')
    postals = json.decode(postals)
    for i, postal in ipairs(postals) do
        postals[i] = { vector2(postal.x, postal.y), code = postal.code }
    end
    zonesJson = json.decode(zonesJson)
    for i, zone in ipairs(zonesJson) do
        zones[zone.zone] = zone.name
    end
end)

Citizen.CreateThread(function()
    while postals == nil do Wait(1) end

    while true do
        local coords = GetEntityCoords(PlayerPedId())
        coords = vec(coords[1], coords[2])

        local nearestIndex, nearestDist
        for i = 1, #postals do
            local dist = #(coords - postals[i][1])
            if not nearestDist or dist < nearestDist then
                nearestIndex = i
                nearestDist = dist
                activeCoords = postals[i][1]
            end
        end

        local code = postals[nearestIndex].code
        postalText = string.format("CP %s", code)

        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', }

    while true do
        for k,v in pairs(directions)do
            direction = GetEntityHeading(PlayerPedId())
            if(math.abs(direction - k) < 22.5)then
                directionText = v
                break;
            end
        end
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if not IsRadarHidden() and Config.location == true then
            local coords = GetEntityCoords(PlayerPedId())
            local zone = GetNameOfZone(coords.x, coords.y, coords.z);
            local streetname, _ = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            local streetnameText = GetStreetNameFromHashKey(streetname);
            coords = vec(coords[1], coords[2])
            local dist = #(coords - activeCoords)
            distanceText = string.format("%sm", math.floor(dist))
            local zoneText = streetnameText
            if zones[string.upper(zone)] ~= nil then
                zoneText = zones[string.upper(zone)]
            end
            local data = {
                component="position",
                heading=GetEntityHeading(PlayerPedId()),
                postal=postalText,
                direction=directionText,
                distance=distanceText,
                street=streetnameText,
                zone=zoneText
            }
            SendNuiMessage(json.encode(data))
        else
            local data = {
                component="position",
                visible=false
            }
            SendNuiMessage(json.encode(data))
        end
        Wait(1)
    end
end)

-- 
-- HUD STATUS
-- 

local hunger = 100
local thirst = 100
local voice_type = "mic_mute.png"
local voice_talking = false
local voice_radio = false

exports("setThirst", function(val)
    thirst = val
end)

exports("setHunger", function(val)
    hunger = val
end)

exports("setVoiceDistance", function(val)
    if(val == 1) then
        voice_type = "mic_mute.png"
    end
    if(val == 1) then
        voice_type = "mic_one.png"
    end
    if(val == 2) then
        voice_type = "mic_two.png"
    end 
    if(val == 3) then
        voice_type = "mic_three.png"
    end
end)

exports("setVoiceRadio", function(toggle)
    voice_radio = toggle
end)

exports("setVoiceTalking", function(toggle)
    voice_talking = toggle
end)

Citizen.CreateThread(function()
    while true do
        local voice = voice_type
        if voice_radio then
            voice = "mic_radio.png"
        end
        if Config.status == true then
            local data = {
                component="status",
                hungerVisible=Config.enableHunger,
                thirstVisible=Config.enableThirst,
                voiceVisible=Config.enableVoice,
                voiceType=voice,
                voiceTalking=voice_talking,
                health=GetEntityHealth(PlayerPedId()),
                maxhealth=GetEntityMaxHealth(PlayerPedId()),
                armor=GetPedArmour(PlayerPedId()),
                hunger=hunger,
                thirst=thirst,
                oxygen=GetPlayerUnderwaterTimeRemaining(PlayerId())
            }
            SendNuiMessage(json.encode(data))
        else
            local data = {
                component="status",
                visible=false
            }
            SendNuiMessage(json.encode(data))
        end
        Wait(1)
    end
end)

--
-- HUD SPEEDOMETER
--

local seatbelt = false

exports("setSeatBelt", function(toggle)
    seatbelt = toggle
end)

Citizen.CreateThread(function()
    while true do
        if Config.status == true then
            if IsPedInAnyVehicle(PlayerPedId()) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if DoesEntityExist(vehicle) then
                    local maxSpeed = GetVehicleEstimatedMaxSpeed(vehicle)*3.6
                    local speed = GetEntitySpeed(vehicle)*3.6

                    if Config.useMiles then
                        maxSpeed = GetVehicleEstimatedMaxSpeed(vehicle)*2.236936
                        speed = GetEntitySpeed(vehicle)*2.236936
                    end

                    local maxFuel = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fPetrolTankVolume')
                    local fuel = GetVehicleFuelLevel(vehicle)

                    local _,_,highbeams = GetVehicleLightsState(vehicle)

                    local engine = GetIsVehicleEngineRunning(vehicle)
                    
                    local data = {
                        component="speedometer",
                        seatbeltVisible=Config.enableSeatBelt,
                        fuelVisible=Config.enableFuel,
                        useMiles=Config.useMiles,
                        speed=speed,
                        maxspeed=maxSpeed,
                        fuel=fuel,
                        maxfuel=maxFuel,
                        highbeams=highbeams,
                        engine=engine,
                        seatbelt=seatbelt
                    }
                    SendNuiMessage(json.encode(data))
                else
                    local data = {
                        component="speedometer",
                        visible=false
                    }
                    SendNuiMessage(json.encode(data))
                end
            else
                local data = {
                    component="speedometer",
                    visible=false
                }
                SendNuiMessage(json.encode(data))
            end
        else
            local data = {
                component="speedometer",
                visible=false
            }
            SendNuiMessage(json.encode(data))
        end
        Wait(1)
    end
end)