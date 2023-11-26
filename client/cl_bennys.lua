RegisterNUICallback("vnx-laptop:BennysShopPurchaseItems", function(data, cb)
  TriggerServerEvent("vnx-laptop:BennysShopPurchaseItems:ServerEvent", data)

  cb({})
end)
