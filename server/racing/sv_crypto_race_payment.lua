RegisterNetEvent("vnx-laptop:ClientEvent:Racing:PaymentForRacingInCrypto")
AddEventHandler("vnx-laptop:ClientEvent:Racing:PaymentForRacingInCrypto", function(pAmount)
  local src = source

  local user = exports['str-base']:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  local resultPlayerCrypto = Await(SQL.execute("SELECT * FROM `user_crypto` WHERE cryptocid = @stateId AND cryptoid = 2",
    { ["@stateId"] = stateId }
  ))

  if resultPlayerCrypto[1] == nil then
    return
  end

  local resultUpdate = Await(SQL.execute(
    "UPDATE `user_crypto` SET cryptoamount = @cryptoAmount WHERE cryptocid = @stateId AND cryptoid = 2", {
      ["@cryptoAmount"] = tonumber(resultPlayerCrypto[1].cryptoamount) + tonumber(pAmount),
      ["@stateId"] = stateId
    }
  ))

end)
