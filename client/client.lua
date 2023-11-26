local tabletObject, isInTablet, VehicleStoled = nil, false, nil

local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)

  print("vnx-laptop:VerifyUserJobHnO => Client Process => hnoEmployee = false")
  SendReactMessage('setVisible', shouldShow)
end

RegisterNetEvent("vnx-laptop:openTablet")
AddEventHandler("vnx-laptop:openTablet", function()
  toggleNuiFrame(true)
  debugPrint('Show NUI frame')

  local Employed = exports["str-business"]:IsEmployedAt("hno_imports")
  local existsVpnForBennys = exports["str-inventory"]:hasEnoughOfItem("vpnxj", 1, false)

  print("vnx-laptop:openTablet => Client Process => HnO Employed At => " .. tostring(Employed))

  if Employed then
    SendReactMessage("ButtonsVisibilityContext:setBennysVisible", existsVpnForBennys)
    -- SendReactMessage("ButtonsVisibilityContext:setBoostingVisible", false)
    SendReactMessage("ButtonsVisibilityContext:setHnoImpostsVisible", true)
  end

  doTablet()
end)

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  debugPrint('Hide NUI frame')


  DeleteEntity(tabletObject)
  ClearPedTasks(PlayerPedId())
  cb({})
end)

function doTablet()
  local playerPed = PlayerPedId()
  local dict = "amb@world_human_seat_wall_tablet@female@base"

  RequestAnimDict(dict)

  if tabletObject == nil then
    tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
    AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1,
      0, 1, 0, 1)
  end

  while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end

  if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
    TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
  end
end
