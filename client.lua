-- CONFIGURATION
Global = false --If you want the script to work to for all vehicles
PlayClientSound = false -- Set this to false if you dont want the set sound to broadcast on the client when switching the extra on and off.
PlaySoundInCar = true -- Set this to false if you dont want the set sound to broadcast to everyone in the car when switching the extras on and off 
LeoOnly = true --  THIS IS FOR IF YOU WANT TO SET CIV CARS WITH MUSIC | CAUTION THIS REPAIRS THE PLAYERS CAR Regardless
AllowAutoRepair = false -- Buggy on vehicles with toggleable lightbars. Reccomend to keep on false unless you are only using this for civ cars or cars with light bars that are permanent.
CarConfigurations = {
    -- SO VEHICLES
    ["so1"] = {
        [1] = 121,
        [2] = 212,
        ["soundName"] = 'soundfx'
	}, 
    ["so2"] = {
    [1] = 121,
    [2] = 212,
    ["soundName"] = 'soundfx'
    }, 
    ["so3"] = {
    [1] = 121,
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    ["so4"] = {
    [1] = 121,
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    ["so5"] = {
    [1] = 121,
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    ["so6"] = {
    [1] = 121,
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    ["so7"] = {
    [1] = 121,
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    -- PD Vehicles
    ["pd1"] = {
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    ["pd2"] = {
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    ["pd3"] = {
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    ["pd4"] = {
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    ["pd5"] = {
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    -- SVPD // PBPD
    ["pd10"] = {
    [1] = 121,
    ["soundName"] = 'soundfx'
    },
    ["pd11"] = {
    [1] = 121,
    ["soundName"] = 'soundfx'
    },
    ["pd12"] = {
    [1] = 121,
    ["soundName"] = 'soundfx'
    },
    -- SASP Vehicles
    ["sp1"] = {
        [2] = 212,
        ["soundName"] = 'soundfx'
	}, 
    ["sp2"] = {
    [2] = 212,
    ["soundName"] = 'soundfx'
    }, 
    ["sp3"] = {
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    ["sp4"] = {
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    ["sp5"] = {
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
    ["sp6"] = {
    [2] = 212,
    ["soundName"] = 'soundfx'
    },
}
GlobalConfiguration = {}

local vehicle
local index

Citizen.CreateThread(function()
    while true do 
        Wait(10)

        if Global then
            if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then
                if vehicle ~= GetVehiclePedIsIn(PlayerPedId()) then
                    vehicle = GetVehiclePedIsIn(PlayerPedId())
                    if AllowAutoRepair then
                        SetVehicleAutoRepairDisabled(vehicle, true)
                    end
                end
                if LeoOnly then
                    if GetVehicleClass(vehicle) == 18 then
                        checkTables(GlobalConfiguration)
                    end
                else
                    checkTables(GlobalConfiguration)
                end 
            end  
        else
            if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then
                if vehicle ~= GetVehiclePedIsIn(PlayerPedId()) then
                    vehicle = GetVehiclePedIsIn(PlayerPedId())
                    

                    local carModel = GetEntityModel(vehicle)
		            local carName = GetDisplayNameFromVehicleModel(carModel)
                    local found = false
                    for k, _ in pairs(CarConfigurations) do
                        if string.lower(k) == string.lower(carName) then
                            if AllowAutoRepair then
                                SetVehicleAutoRepairDisabled(vehicle, true)
                            end
                            index = k
                            found = true
                            break
                        end
                    end

                    if not found then
                        index = nil
                    end
                end

                if index ~= nil then
                    if LeoOnly then
                        if GetVehicleClass(vehicle) == 18 then
                            checkTables(CarConfigurations[index])
                        end
                    else
                        checkTables(CarConfigurations[index])                   
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('PlaySoundOnClient')
AddEventHandler('PlaySoundOnClient', function(soundFile, soundVolume)
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = soundFile,
        transactionVolume   = soundVolume
    })
end)

RegisterNetEvent('ClientPlayWithinDistanceOS')
AddEventHandler('ClientPlayWithinDistanceOS', function(playerCoords, maxDistance, soundFile, soundVolume)
    local lCoords = GetEntityCoords(GetPlayerPed(-1))
    local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, playerCoords.x, playerCoords.y, playerCoords.z)
    if(distIs <= maxDistance) then
        SendNUIMessage({
            transactionType     = 'playSound',
            transactionFile     = soundFile,
            transactionVolume   = soundVolume
        })
    end
end)

function PlaySound(soundFile) 
    if PlayClientSound then
        TriggerEvent('PlaySoundOnClient', soundFile, 1.0)
        if PlaySoundInCar then
            TriggerServerEvent('PlayWithinDistance', soundFile)
        end
    end
end

function checkTables(array)
    for k, v in pairs(array) do
        if type(k) == 'number' and type(v) == 'number' and k <= 14 then
            if DoesExtraExist(vehicle, k) then
                if IsDisabledControlJustPressed(0, v) then
                    if IsVehicleExtraTurnedOn(vehicle, k) then
                        SetVehicleExtra(vehicle, k, 1)
                        PlaySound(array['soundName']) 
                    else
                        SetVehicleExtra(vehicle, k, 0)                  
                        PlaySound(array['soundName']) 
                    end  
                end
            end
        end
    end
end