RegisterNUICallback("vnx-laptop:BennysShopPurchaseItems", function(data, cb)
  print("vnx-laptop:BennysShopPurchaseItems:ClientEvent")

  TriggerServerEvent("vnx-laptop:BennysShopPurchaseItems:ServerEvent", data)

  cb({})
end)

RegisterNetEvent("vnx-laptop:BennysShopPurchaseItems:LocationPurchase")
AddEventHandler("vnx-laptop:BennysShopPurchaseItems:LocationPurchase", function(pSource)
  blipMarker = AddBlipForCoord(1726.253, 4765.265, 41.93)

  SetBlipSprite(blipMarker, 280)
  SetBlipAsShortRange(blipMarker, false)
  
  BeginTextCommandSetBlipName("STRING")
  SetBlipColour(blipMarker, 4)
  SetBlipScale(blipMarker, 1.2)
  
  EndTextCommandSetBlipName(blipMarker)
  
  exports['str-phone']:SendAlert('success', 'You know where to go!!!', 3000)

  SetTimeout(60000, function()
    if DoesBlipExist(blipMarker) then
      RemoveBlip(blipMarker)
    end
  end)
end)
