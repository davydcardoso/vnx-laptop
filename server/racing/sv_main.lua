--Racing
local BuiltMaps = {}
local Races = {}

RegisterServerEvent("vnx-laptop:ServerEvent:Racing:GlobalRace")
AddEventHandler("vnx-laptop:ServerEvent:Racing:GlobalRace",
  function(map, laps, counter, reverseTrack, uniqueid, cid, raceName, startTime, mapCreator, mapDistance, mapDescription,
           street1, street2)
    Races[uniqueid] = {
      ["identifier"] = uniqueid,
      ["map"] = map,
      ["laps"] = laps,
      ["counter"] = counter,
      ["reverseTrack"] = reverseTrack,
      ["cid"] = cid,
      ["racers"] = {},
      ["open"] = true,
      ["raceName"] = raceName,
      ["startTime"] = startTime,
      ["mapCreator"] = mapCreator,
      ["mapDistance"] = mapDistance,
      ["mapDescription"] = mapDescription,
      ["raceComplete"] = false
    }

    TriggerEvent("vnx-laptop:ServerEvent:Racing:SendData", uniqueid, -1, "event", "open")
    -- TriggerEvent("vnx-laptop:ServerEvent:Racing:SendData")

    local waitperiod = (counter * 100)
    Wait(waitperiod)

    -- Races[uniqueid]["open"] = false

    -- TriggerEvent("vnx-laptop:ServerEvent:Racing:SendData", uniqueid, -1, "event", "close")
  end
)

RegisterServerEvent("vnx-laptop:ServerEvent:Racing:JoinRace")
AddEventHandler("vnx-laptop:ServerEvent:Racing:JoinRace", function(identifier)
  local src = source
  local player = exports["str-base"]:getModule("Player"):GetUser(src)
  local char = player:getCurrentCharacter()

  local cid = char.id
  local playername = "" .. char.first_name .. " " .. char.last_name .. ""

  Races[identifier]["racers"][cid] = { ["name"] = PlayerName, ["cid"] = cid, ["total"] = 0, ["fastest"] = 0 }
  TriggerEvent("vnx-laptop:ServerEvent:Racing:SendData", identifier, src, 'event')
end)

RegisterServerEvent("vnx-laptop:ServerEvent:Racing:Completed")
AddEventHandler("vnx-laptop:ServerEvent:Racing:Completed", function(stLap, overall, sprint, identifier)
  local src = source
  local player = exports["str-base"]:getModule("Player"):GetUser(src)
  local char = player:getCurrentCharacter()

  local cid = char.id
  local playername = "" .. char.first_name .. " " .. char.last_name .. ""

  Races[identifier]["racers"][cid] = {
    ["name"] = PlayerName,
    ["cid"] = cid,
    ["total"] = overall,
    ["fastest"] = fastestLap
  }

  Races[identifier].sprint = sprint

  TriggerEvent('vnx-laptop:ServerEvent:Racing:SendData', identifier, -1, 'event')

  if not Races[identifier]["raceComplete"] then
    exports.oxmysql:executeSync(
      "UPDATE racing_tracks SET races = races+1 WHERE id = '" .. tonumber(Races[identifier].map) .. "'",
      function(results)
        if results.changedRows > 0 then
          Races[identifier]["raceComplete"] = true
        end
      end
    )
  end

  if Races[identifier].sprint and Races[identifier]["racers"][cid]["total"] then
    exports.oxmysql:executeSync(
      "UPDATE racing_tracks SET fastest_sprint = " .. tonumber(Races[identifier]["racers"][cid]["total"]) ..
      ", fastest_sprint_name = '" .. tostring(PlayerName) ..
      "' WHERE id = " .. tonumber(Races[identifier].map) ..
      " and (fastest_sprint IS NULL or fastest_sprint > " .. tonumber(Races[identifier]["racers"][cid]["total"]) .. ")",
      function(results)
        if results.changedRows > 0 then
        end
      end
    )
  else
    exports.oxmysql:executeSync(
      "UPDATE racing_tracks SET fastest_lap = " .. tonumber(Races[identifier]["racers"][cid]["fastest"]) ..
      ", fastest_name = '" .. tostring(PlayerName) ..
      "' WHERE id = " .. tonumber(Races[identifier].map) ..
      " and (fastest_lap IS NULL or fastest_lap > " .. tonumber(Races[identifier]["racers"][cid]["fastest"]) .. ")",
      function(results)
        if results.changedRows > 0 then
        end
      end
    )
  end
end)

RegisterServerEvent("vnx-laptop:ServerEvent:Racing:SendData")
AddEventHandler("vnx-laptop:ServerEvent:Racing:SendData", function(pEventId, clientId, changeType, pSubEvent)
  local dataObject = {
    eventId = pEventId,
    event = changeType,
    subEvent = pSubEvent,
    data = {}
  }

  if (changeType == "event") then
    dataObject.data = (pEventId ~= -1 and Races[pEventId] or Races)
  elseif (changeType == "map") then
    dataObject.data = (pEventId ~= -1 and BuiltMaps[pEventId] or BuiltMaps)
  end

  TriggerClientEvent("vnx-laptop:ClientEvent:Racing:Set", -1, dataObject)
end)

function BuildMaps(subEvent)
  local src = source
  subEvent = subEvent or nil

  BuiltMaps = {}

  exports.oxmysql:executeSync("SELECT * FROM racing_tracks", {}, function(result)
    for i = 1, #result do
      local correctId = tostring(result[i].id)
      BuiltMaps[correctId] = {
        checkpoints = json.decode(result[i].checkpoints),
        track_name = result[i].track_name,
        creator = result[i].creator,
        distance = result[i].distance,
        races = result[i].races,
        fastest_car = result[i].fastest_car,
        fastest_name = result[i].fastest_name,
        fastest_lap = result[i].fastest_lap,
        fastest_sprint = result[i].fastest_sprint,
        fastest_sprint_name = result[i].fastest_sprint_name,
        description = result[i].description
      }
    end

    local target = -1

    if (subEvent == 'mapUpdate') then
      target = src
    end

    TriggerEvent('vnx-laptop:ServerEvent:Racing:SendData', -1, target, 'map', subEvent)
  end)
end

RegisterServerEvent("vnx-laptop:ServerEvent:Racing:BuildMaps")
AddEventHandler("vnx-laptop:ServerEvent:Racing:BuildMaps", function()
  BuiltMaps("mapUpdate")
end)

RegisterServerEvent("vnx-laptop:ServerEvent:Racing:DeleteRaceMap")
AddEventHandler("vnx-laptop:ServerEvent:Racing:DeleteRaceMap", function(deleteID)
  exports.oxmysql:executeSync("DELETE FROM racing_tracks WHERE id = @id", {
    ['id'] = deleteID
  })

  Wait(1000)

  BuildMaps()
end)

RegisterServerEvent("vnx-laptop:ServerEvent:Racing:RetreiveMap")
AddEventHandler("vnx-laptop:ServerEvent:Racing:RetreiveMap", function()
  local src = source

  BuiltMaps("noNUI", src)
end)

RegisterServerEvent("vnx-laptop:ServerEvent:Racing:SaveRace")
AddEventHandler("vnx-laptop:ServerEvent:Racing:SaveRace", function(currentMap, name, description, distanceMap)
  local src = source
  local player = exports['str-base']:getModule("Player"):GetUser(src)
  local char = player:getCurrentCharacter()

  local playername = char.first_name .. " " .. char.last_name

  exports.oxmysql:executeSync(
    "INSERT INTO `racing_tracks` (`checkpoints`, `creator`, `track_name`, `distance`, `description`) VALUES ('" ..
    json.encode(currentMap) ..
    "', '" .. tostring(playername) .. "', '" .. tostring(name) .. "', '" .. distanceMap .. "',  '" .. description .. "')",
    function(results)
      Wait(1000)
    end
  )
end)


RPC.register("vnx-laptop:ServerEvent:Racing:ListRacesEvents", function(pSource)
  local resultQuery = Await(SQL.execute("SELECT * FROM `racing_tracks`"))

  return resultQuery
end)
