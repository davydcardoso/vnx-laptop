RegisterNUICallback("vnx-laptop:NUIEvent:Racing:CheckPlayerData", function(data, cb)
  local existsPuppetUsbDevice = exports["str-inventory"]:hasEnoughOfItem("puppet_usbdevice", 1, false)


  SendReactMessage("RacingSystem:setPlayerSource", GetPlayerPed(-1))
  SendReactMessage("RacingSystem:setPlayerIsPuppet", existsPuppetUsbDevice)

  cb({})
end)

function GetCardinalDirectionFromHeading()
  local heading = GetEntityHeading(PlayerPedId())

  if heading >= 315 or heading < 45 then
    return "North Bound"
  elseif heading >= 45 and heading < 135 then
    return "West Bound"
  elseif heading >= 135 and heading < 225 then
    return "South Bound"
  elseif heading >= 225 and heading < 315 then
    return "East Bound"
  end
end
