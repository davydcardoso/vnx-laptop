-- local BoostingQueueIsEnabled = "ENABLED"

local existsPhoneDongleUser = exports["str-inventory"]:hasEnoughOfItem("racingusb1", 1, false)

RegisterNetEvent("vnx-laptop:BoostingEnabledOrDisabledBoosting:ResponseToFront")
AddEventHandler("vnx-laptop:BoostingEnabledOrDisabledBoosting:ResponseToFront", function(pStatus)
  print("vnx-laptop:BoostingEnabledOrDisabledBoosting:ResponseToFront:TRHEADS")
  BoostingQueueIsEnabled = pStatus
end)

Citizen.CreateThread(function()
  while true do
    -- DEFAULT VALUES Citizen.Wait(60 * 1000)
    Citizen.Wait(60 * 1000)

    if existsPhoneDongleUser then
      TriggerServerEvent("vnx-laptop:Boosting:UpdateBoostingInfo")
    end
  end
end)
