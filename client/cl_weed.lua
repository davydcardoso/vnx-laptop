RegisterNUICallback("vnx-laptop:NUIEvent:Weed:GetWedData", function(data, cb)
  print("vnx-laptop:NUIEvent:Weed:GetWedData")

  TriggerEvent("str-weed:ClientEvent:Weed:GetPlayerData")
  
  cb({})
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Weed:SendPlayerData")
AddEventHandler("vnx-laptop:ClientEvent:Weed:SendPlayerData", function (data)
  print("vnx-laptop:ClientEvent:Weed:SendPlayerData:DataResult =>"..json.encode(data))
  SendReactMessage("WeedSystem:setPlayerData", data)
end)

RegisterNuiCallback("vnx-laptop:NUIEvent:Weed:ExitJobQueue", function (data, cb)
  TriggerEvent("str-weed:ClientEvent:Weed:ExitWeedRunJob")

  cb({})
end)
