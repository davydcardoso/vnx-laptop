RPC.register("vnx-laptop:ServerEvent:Racing:GetRaceData", function(source, raceid)
  local result = Await(SQL.execute("SELECT * FROM racing_tracks rt WHERE id = @race_id", {
    ["race_id"] = raceid.param
  }))

  return result[1]
end)

RegisterServerEvent("vnx-laptop:ServerEvent:Racing:CreateRaceEvent")
AddEventHandler("vnx-laptop:ServerEvent:Racing:CreateRaceEvent", function(data)
  local src = source
  local user = exports["str-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  local stateId = char.id

  local resultQueryRacingDoungle = exports.oxmysql:executeSync(
    "SELECT * FROM inventory i WHERE name = @stateID AND item_id = @itemID", {
      ["@stateID"] = 'ply-' .. tostring(stateId),
      ["@itemID"] = 'racingusb1'
    }
  )

  if resultQueryRacingDoungle[1] == nil then
    TriggerClientEvent(
      "DoLongHudText",
      src,
      "Your pendrive is defective...",
      2
    );
    return
  end

  local doungleInformation = json.decode(resultQueryRacingDoungle[1].information)

  if doungleInformation["pseudônimo"] == nil then
    TriggerClientEvent(
      "DoLongHudText",
      src,
      "Your pendrive is defective...",
      2
    );
    return
  end

  TriggerClientEvent("vnx-laptop:ClientEvent:Racing:CreateRaceEvent", -1, data, {
    name = doungleInformation["pseudônimo"],
    stateId = stateId,
  })
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Racing:JoinEvent")
AddEventHandler("vnx-laptop:ServerEvent:Racing:JoinEvent", function(pRaceUniqueID, pPlayerSource)
  local src = source
  local user = exports["str-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  local stateId = char.id

  local resultQueryRacingDoungle = exports.oxmysql:executeSync(
    "SELECT * FROM inventory i WHERE name = @stateID AND item_id = @itemID", {
      ["@stateID"] = 'ply-' .. tostring(stateId),
      ["@itemID"] = 'racingusb1'
    }
  )

  if resultQueryRacingDoungle[1] == nil then
    TriggerClientEvent(
      "DoLongHudText",
      src,
      "Your pendrive is defective...",
      2
    );
    return
  end

  local doungleInformation = json.decode(resultQueryRacingDoungle[1].information)

  if doungleInformation["pseudônimo"] == nil then
    TriggerClientEvent(
      "DoLongHudText",
      src,
      "Your pendrive is defective...",
      2
    );
    return
  end

  TriggerClientEvent("vnx-laptop:ClientEvent:Racing:JoinEvent", -1, {
    raceUniqueID = pRaceUniqueID,
    playerSource = pPlayerSource,
    playerName = doungleInformation["pseudônimo"],
    playerStateId = stateId,
  })
end)


RegisterServerEvent("vnx-laptop:ServerEvent:Racing:CancelEvent")
AddEventHandler("vnx-laptop:ServerEvent:Racing:CancelEvent", function(raceUniqueID)
  TriggerClientEvent("vnx-laptop:ClientEvent:Racing:CancelEvent", -1, raceUniqueID)
end)

RegisterServerEvent("vnx-laptop:ServerEvent:Racing:ExitRaceEvent")
AddEventHandler("vnx-laptop:ServerEvent:Racing:ExitRaceEvent", function(raceUniqueID, player)
  TriggerClientEvent("vnx-laptop:ClientEvent:Racing:ExitRaceEvent", -1, raceUniqueID, player)
end)

RegisterServerEvent("vnx-laptop:ServerEvent:Racing:StartRaceEvent")
AddEventHandler("vnx-laptop:ServerEvent:Racing:StartRaceEvent", function(raceUniqueID, playerSource)
  TriggerClientEvent("vnx-laptop:ClientEvent:Racing:StartRaceEvent", -1, raceUniqueID, playerSource)
end)

RegisterServerEvent("vnx-laptop:ServerEvent:Racing:FinishRaceEvent")
AddEventHandler("vnx-laptop:ServerEvent:Racing:FinishRaceEvent", function(raceUniqueID, playerSource)
  TriggerClientEvent("vnx-laptop:ClientEvent:Racing:FinishRaceEvent", -1, {
    raceUniqueID = raceUniqueID,
    playerSource = playerSource
  })
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Racing:FinishedRace")
AddEventHandler("vnx-laptop:ServerEvent:Racing:FinishedRace", function(raceUniqueID, player)
  TriggerClientEvent("vnx-laptop:ClientEvent:Racing:PlayerFinished", -1, raceUniqueID, player)
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Racing:UpdateRacePlayers")
AddEventHandler("vnx-laptop:ServerEvent:Racing:UpdateRacePlayers", function(raceUniqueID, playerSource, playersRace)
  TriggerClientEvent("vnx-laptop:ClientEvent:Racing:UpdateRacePlayers", -1, raceUniqueID, playerSource, playersRace)
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Racing:UpdateRaceData")
AddEventHandler("vnx-laptop:ServerEvent:Racing:UpdateRaceData", function(raceUniqueID, raceData)
  TriggerClientEvent("vnx-laptop:ClientEvent:Racing:UpdateRaceData", -1, raceUniqueID, raceData)
end)
