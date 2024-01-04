RegisterNUICallback("vnx-laptop:VerifyUserJobHnO", function(data, cb)
  local jobs = exports["str-business"]:IsEmployedAt("hno_imports")

  if jobs then
    cb({ hnoEmployee = true })
    return
  end

  cb({ hnoEmployee = false })
end)

RegisterNUICallback('vnx-laptop:SpawnVehicleHNO', function(data, cb)
  if data then
    local playerPosition = GetEntityCoords(GetPlayerPed(-1))

    if (#(playerPosition - vector3(-47.100, -1099.729, 26.422)) > 10.0) then
      TriggerEvent("DoLongHudText", "You are not in an HNO garage!!!", 2)
      return
    end

    local carModelID = data.selectedCar.id

    local coord = GetEntityCoords(PlayerPedId())

    local Hash = tostring(carModelID)

    if not IsModelInCdimage(Hash) then
      return
    end

    RequestModel(Hash)
    while not HasModelLoaded(Hash) do
      Citizen.Wait(10)
    end

    local heading = GetEntityHeading(PlayerPedId())

    local veh = CreateVehicle(Hash, coord.x, coord.y - 2, coord.z, heading, true, false)

    SetModelAsNoLongerNeeded(Hash)
    SetVehicleEngineOn(veh, false, false)
    SetVehicleDoorsLocked(veh, 2)

    local plate = SetVehicleNumberPlateText(veh, "HNOSALE" .. tostring(math.random(10, 99)))

    TriggerEvent("vehicle:keys:addNew", veh, plate)

    TriggerEvent("vnx-laptop:ClientEvent:Client")
  end

  cb({})
end)

RegisterNUICallback('vnx-laptop:SaleVehicleForPlayer', function(data, cb)
  local stateId = data.StateId
  local selectedCar = data.selectedCar

  TriggerEvent("vnx-laptop:SaleVehicleForPlayer:ServerEvent", stateId, selectedCar)
  TriggerServerEvent("vnx-laptop:SaleVehicleForPlayer:ServerEvent", stateId, selectedCar)

  cb({})
end)
