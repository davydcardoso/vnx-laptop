local tabletObject, isInTablet, VehicleStoled = nil, false, nil

local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)

  SendReactMessage('setVisible', shouldShow)
end

RegisterNetEvent("vnx-laptop:ClientEvent:Client")
AddEventHandler("vnx-laptop:ClientEvent:Client", function()
  toggleNuiFrame(false)
  -- debugPrint('Hide NUI frame')


  DeleteEntity(tabletObject)
  ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("vnx-laptop:openTablet")
AddEventHandler("vnx-laptop:openTablet", function()
  toggleNuiFrame(true)
  -- debugPrint('Show NUI frame')

  local Employed = exports["str-business"]:IsEmployedAt("hno_imports")
  local existsVpnForBennys = exports["str-inventory"]:hasEnoughOfItem("vpnxj", 1, false)
  local existsPhoneDongleUser = exports["str-inventory"]:hasEnoughOfItem("racingusb1", 1, false)
  local existsPuppetUsbDevice = exports["str-inventory"]:hasEnoughOfItem("puppet_usbdevice", 1, false)
  local existsExistsPhoneWeed = exports["str-inventory"]:hasEnoughOfItem("stolennokia", 1, false)

  if Employed then
    SendReactMessage("ButtonsVisibilityContext:setHnoImpostsVisible", true)
  end

  SendReactMessage("ButtonsVisibilityContext:setBennysVisible", existsVpnForBennys)
  SendReactMessage("ButtonsVisibilityContext:setRacingVisible", existsPhoneDongleUser)
  SendReactMessage("ButtonsVisibilityContext:setWeedAppVisible", existsExistsPhoneWeed)
  SendReactMessage("ButtonsVisibilityContext:setBoostingVisible", existsPhoneDongleUser)

  if (existsPhoneDongleUser) then
    SendReactMessage("BoostingContext:setPlayerIsPuppet", existsPuppetUsbDevice)
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
  local dict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"

  RequestAnimDict(dict)

  if tabletObject == nil then
    tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
    AttachEntityToEntity(
      tabletObject,
      playerPed,
      GetPedBoneIndex(playerPed, 28422),
      0.0,
      0.0,
      0.03,
      0.0,
      0.0,
      0.0,
      1,
      1,
      0,
      1,
      0,
      1
    )
  end

  while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end

  if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
    TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
  end
end
