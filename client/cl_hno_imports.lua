RegisterNUICallback("vnx-laptop:VerifyUserJobHnO", function(data, cb)
  local jobs = exports["str-business"]:IsEmployedAt("hno_imports")

  print("vnx-laptop:VerifyUserJobHnO => Client Process => HnO Employed At => " .. tostring(jobs))

  if jobs then
    cb({ hnoEmployee = true })
    print("vnx-laptop:VerifyUserJobHnO => Client Process => hnoEmployee = true")
    return
  end

  print("vnx-laptop:VerifyUserJobHnO => Client Process => hnoEmployee = false")
  cb({ hnoEmployee = false })
end)

RegisterNUICallback('vnx-laptop:SpawnVehicleHNO', function(data, cb)
  if (data) then
    local carModelID = data.selectedCar.id

    local coord = GetEntityCoords(PlayerPedId())

    pVeh = tostring(carModelID)
    local Hash = tostring(carModelID)

    if not IsModelInCdimage(Hash) then
      return
    end

    RequestModel(Hash)
    while not HasModelLoaded(Hash) do
      Citizen.Wait(10)
    end

    veh = CreateVehicle(Hash, coord.x - 2, coord.y, coord.z, 0.0, true, false)

    SetModelAsNoLongerNeeded(Hash)
    SetVehicleEngineOn(veh, false, false)
    SetVehicleDoorsLocked(veh, 2)

    local plate = SetVehicleNumberPlateText(veh, "HNOSALE" .. tostring(math.random(10, 99)))
    TriggerEvent("vehicle:keys:addNew", veh, plate)

    toggleNuiFrame(false)
    debugPrint('Hide NUI frame')

    DeleteEntity(tabletObject)
    ClearPedTasks(PlayerPedId())
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
