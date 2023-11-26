RegisterServerEvent("vnx-laptop:SaleVehicleForPlayer:ServerEvent")
AddEventHandler("vnx-laptop:SaleVehicleForPlayer:ServerEvent", function(stateId, selectedCar)
  local src = source

  -- TriggerClientEvent('DoShortHudText', source, 'Car charge request sent!!', 0)

  -- print("vnx-laptop:SaleVehicleForPlayer:ServerEvent => Player Comprador => " .. playerState)
  -- print("Player Comprador => " .. playerState or "Null")

  print("vnx-laptop:SaleVehicleForPlayer:ServerEvent => " .. stateId)
  print("vnx-laptop:SaleVehicleForPlayer:ServerEvent => " .. selectedCar.id)
  print("vnx-laptop:SaleVehicleForPlayer:ServerEvent => " .. selectedCar.class)
  print("vnx-laptop:SaleVehicleForPlayer:ServerEvent => " .. selectedCar.name)
  print("vnx-laptop:SaleVehicleForPlayer:ServerEvent => " .. selectedCar.stock)
  print("vnx-laptop:SaleVehicleForPlayer:ServerEvent => " .. selectedCar.price)

  -- local user = exports["str-base"]:getModule("Player"):GetUser(src)
  -- local characterId = user:getCurrentCharacter().id
  -- local cash = user:getCash()
  local pPrice = selectedCar.price
  local pModel = selectedCar.id

  -- if tonumber(cash) >= pPrice then
  -- user:removeMoney(pPrice)
  local vehicleSpawn = exports["str-vehicles"]:GenerateVehicleInfo(src, stateId, pModel, "pd", "pd", nil, selectedCar.id)
  TriggerEvent("str:vehicles:InsertVehicleData", target, vehicleSpawn)
  TriggerClientEvent("phone:purchaseCar", src)
  TriggerClientEvent('DoLongHudText', src, "Sale made successfully!", 0)
  -- elseif tonumber(cash) <= pPrice then
  -- TriggerClientEvent('DoLongHudText', src, "You don't have enough money!", 2)
  -- end
end)



-- Citizen.CreateThread(function()
--   function GetPlayerFromCid(pCid)
--     local Retval = nil
--     GetPlayerServerId
--     for k, _playerId in pairs(GetPlayers()) do

--       print("GetPlayerFromCid" .. xPlayer)

--       local user = exports['str-base']:getModule("Player"):GetUser(_playerId)
--       local cid = user:getCurrentCharacter().id

--       if cid == pCid then
--         Retval = _playerId
--       end
--     end

--     return Retval
--   end
-- end)
