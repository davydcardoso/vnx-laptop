Races = {}
FinishRacePlayes = {}

local SetBlips = {}
local SetBlipsView = {}
local SetObjectCheckpoints = {}
local playerInRace = false
local checkpointMarkers = {}
local playerRaceUniqueID = nil
local raceInViewer = false

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:CreateEvent", function(data, cb)
  TriggerServerEvent("vnx-laptop:ServerEvent:Racing:CreateRaceEvent", data)

  cb({})
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:JoinEvent", function(data, cb)
  TriggerServerEvent("vnx-laptop:ServerEvent:Racing:JoinEvent", data.raceUniqueID, data.playerSource)
  exports["str-phone"]:DoPhoneNotification("home-screen", "Puppet Master", 'You entered the event...', 1)

  cb({})
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:MarkerRaceInMap", function(data, cb)
  for i = 1, #Races do
    if Races[i].uniqueID == data.raceUniqueID then
      local checkpoints = json.decode(Races[i].checkpoints)

      SetNewWaypoint(checkpoints[1].x, checkpoints[1].y)
    end
  end

  cb({})
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:KickPlayerRace", function(data, cb)
  cb({})
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:ExitRaceEvent", function(data, cb)
  TriggerServerEvent("vnx-laptop:ServerEvent:Racing:ExitRaceEvent", data.raceUniqueID, data.playerSource)

  cb({})
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:BanPlayerRaces", function(data, cb)
  cb({})
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:GetPlayerRaceList", function(data, cb)
  local resultRace = nil

  for i = 1, #Races do
    if Races[i].uniqueID == data.raceUniqueID then
      resultRace = Races[i]
    end
  end

  cb(resultRace)
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:CancelEvent", function(data, cb)
  TriggerServerEvent("vnx-laptop:ServerEvent:Racing:CancelEvent", data.raceUniqueID)
  cb({})
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:ViewRaceEvent", function(data, cb)
  local existsPhoneDongleUser = exports["str-inventory"]:hasEnoughOfItem("racingusb1", 1, false)

  if not existsPhoneDongleUser then
    cb({})
    return
  end

  if data.raceUniqueID == nil then
    cb({})
    return
  end

  if raceInViewer then
    TriggerEvent("DoLongHudText", "Race in view mode (OFF)...", 0);

    for i = 1, #SetBlipsView do
      Wait(5)
      RemoveBlip(SetBlipsView[i])
    end

    SetBlipsView = {}
    raceInViewer = false

    cb({})
    return
  end

  local raceUniqueID = data.raceUniqueID

  local result = RPC.execute("vnx-laptop:ServerEvent:Racing:GetRaceData", tonumber(raceUniqueID))

  if result ~= nil then
    local raceCheckpoints = json.decode(result.checkpoints)

    for checkpointIndex = 1, #raceCheckpoints do
      SetBlipsView[checkpointIndex] = AddBlipForCoord(
        raceCheckpoints[checkpointIndex].x,
        raceCheckpoints[checkpointIndex].y,
        raceCheckpoints[checkpointIndex].z
      )

      if checkpointIndex == 1 then
        SetBlipSprite(SetBlipsView[checkpointIndex], 38)
      else
        ShowNumberOnBlip(SetBlipsView[checkpointIndex], checkpointIndex)
      end

      SetBlipColour(SetBlipsView[checkpointIndex], 0)
      Wait(5)
    end

    raceInViewer = true

    TriggerEvent("DoLongHudText", "Race in view mode...", 0);
  else
    TriggerEvent("DoLongHudText", "Race not found...", 2);
  end

  cb({})
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Racing:JoinEvent")
AddEventHandler("vnx-laptop:ClientEvent:Racing:JoinEvent", function(data)
  local existsPhoneDongleUser = exports["str-inventory"]:hasEnoughOfItem("racingusb1", 1, false)

  if not existsPhoneDongleUser then
    return
  end

  local playerSource = GetPlayerPed(-1)

  for i = 1, #Races do
    if Races[i].uniqueID == data.raceUniqueID then
      for playerIndex = 1, #Races[i].players do
        if Races[i].players[playerIndex].src == data.playerSource then
          TriggerEvent("DoLongHudText", "You already joined event...", 2);
          return
        end
      end

      Races[i].players[#Races[i].players + 1] = {
        src = data.playerSource,
        name = data.playerName,
        stateId = data.playerStateId,
      }


      if Races[i].creatorId == playerSource then
        exports["str-phone"]:DoPhoneNotification("home-screen", "Puppet Master", 'Someone entered the race.', 1)
      end
    end
  end

  SendReactMessage("RacingSystem:setRacesEvents", Races)
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:FinishRaceEvent", function(data, cb)
  TriggerServerEvent("vnx-laptop:ServerEvent:Racing:FinishRaceEvent", data.raceUniqueID, data.playerSource)

  cb({})
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Racing:UpdateRaceData")
AddEventHandler("vnx-laptop:ClientEvent:Racing:UpdateRaceData", function(raceUniqueID, racedata)
  local existsPhoneDongleUser = exports["str-inventory"]:hasEnoughOfItem("racingusb1", 1, false)

  if not existsPhoneDongleUser then
    return
  end

  for i = 1, #Races do
    if Races[i].uniqueID == raceUniqueID then
      Races[i] = racedata
    end
  end

  SendReactMessage("RacingSystem:setRacesEvents", Races)
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Racing:ExitRaceEvent")
AddEventHandler("vnx-laptop:ServerEvent:Racing:ExitRaceEvent", function(raceUniqueID, playerSource)
  local existsPhoneDongleUser = exports["str-inventory"]:hasEnoughOfItem("racingusb1", 1, false)

  if not existsPhoneDongleUser then
    return
  end

  for i = 1, #Races do
    if Races[i].uniqueID == raceUniqueID then
      local newPlayersList = {}

      for playerIndex = 1, #Races[i].players do
        if Races[i].players[playerIndex].src ~= playerSource then
          newPlayersList[#newPlayersList + 1] = Races[i].players[playerIndex]
        end
      end

      Races[i].players = newPlayersList
    end
  end

  SendReactMessage("RacingSystem:setRacesEvents", Races)
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:StartRaceEvent", function(data, cb)
  local race = nil
  local playerSource = GetPlayerPed(-1)

  local playerIsInVehicle = GetVehiclePedIsIn(playerSource, false)

  if not playerIsInVehicle then
    TriggerEvent("DoLongHudText", "You need to be in a vehicle to start...", 2);
    return
  end

  for i = 1, #Races do
    if Races[i].uniqueID == data.raceUniqueID then
      if Races[i].creatorId ~= data.playerSource then
        TriggerEvent("DoLongHudText", "You are not the creator of the race...", 2);
        return
      end

      race = Races[i]
    end
  end

  if race == nil then
    return
  end

  local raceCheckpoints = json.decode(race.checkpoints)

  local ped = GetPlayerPed(-1)
  local pedCoords = GetEntityCoords(ped)
  local distance = Vdist(
    raceCheckpoints[1].x,
    raceCheckpoints[1].y,
    raceCheckpoints[1].z,
    pedCoords.x,
    pedCoords.y,
    pedCoords.z
  )

  if distance > 150.0 then
    exports["str-phone"]:DoPhoneNotification(
      "home-screen",
      "Puppet Master",
      'You`re too far away to start the race...',
      1
    )
    return;
  end

  for i = 1, #Races do
    if Races[i].uniqueID == raceUniqueID then
      Races[i].started = true

      TriggerServerEvent("vnx-laptop:ServerEvent:Racing:UpdateRaceData", data.raceUniqueID, Races[i])
    end
  end

  TriggerServerEvent("vnx-laptop:ServerEvent:Racing:StartRaceEvent", data.raceUniqueID, data.playerSource)
  cb({})
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Racing:CancelEvent")
AddEventHandler("vnx-laptop:ClientEvent:Racing:CancelEvent", function(raceUniqueID)
  local _races = {}
  for i = 1, #Races do
    if Races[i].uniqueID ~= raceUniqueID then
      _races[#races] = Races[id]
    end
  end

  Races = _races

  TriggerEvent("vnx-laptop:NUIEvent:Racing:RemoveBlips")
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Racing:CreateRaceEvent")
AddEventHandler("vnx-laptop:ClientEvent:Racing:CreateRaceEvent", function(race, creator)
  local existsPhoneDongleUser = exports["str-inventory"]:hasEnoughOfItem("racingusb1", 1, false)

  if not existsPhoneDongleUser then
    return
  end

  local playerSource = GetPlayerPed(-1)

  for i = 1, #Races do
    if Races[i].creatorId == playerSource and not Races[i].finished then
      return
    end
  end

  Races[#Races + 1] = {
    uniqueID = race.raceUniqueID,
    name = race.name,
    laps = tonumber(race.laps),
    reverse = false,
    distance = tonumber(race.distance),
    countdown = tonumber(race.countdown),
    creatorId = race.playerSource,
    checkpoints = race.raceEvent.checkpoints,
    players = {}
  }

  FinishRacePlayes[#FinishRacePlayes + 1] = {
    raceUniqueID = race.raceUniqueID,
    players = {}
  }

  for i = 1, #Races do
    if Races[i].uniqueID == race.raceUniqueID then
      Races[i].players[#Races[i].players + 1] = {
        src = race.playerSource,
        name = creator.name,
        stateId = creator.cid,
      }
    end
  end

  local initialCheckpoint = json.decode(race.raceEvent.checkpoints)

  local leftMarker = CreateObject(
    GetHashKey("prop_beachflag_01"),
    vector3(initialCheckpoint[1]["flare1x"], initialCheckpoint[1]["flare1y"], initialCheckpoint[1]["flare1z"]),
    false,
    false,
    false
  )

  local rightMarker = CreateObject(
    GetHashKey("prop_beachflag_01"),
    vector3(initialCheckpoint[1]["flare2x"], initialCheckpoint[1]["flare2y"], initialCheckpoint[1]["flare2z"]),
    false,
    false,
    false
  )

  SendReactMessage("RacingSystem:setRacesEvents", Races)

  Citizen.Wait(200)
  exports["str-phone"]:DoPhoneNotification("home-screen", "Puppet Master", 'New Race Event.', 1)
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Racing:FinishRaceEvent")
AddEventHandler("vnx-laptop:ClientEvent:Racing:FinishRaceEvent", function(data)
  local playerSource = GetPlayerPed(-1)

  for i = 1, #Races do
    if Races[i].creatorId == data.playerSource then
      if Races[i].uniqueID == data.raceUniqueID then
        Races[i].finished = true

        TriggerEvent("vnx-racing:ClientEvent:RacingHUD:UpdateStatus", "finished", {
          eventId = Races[i].uniqueID,
          player = playerSource
        })

        Wait(2000)
        TriggerEvent("vnx-racing:ClientEvent:RacingHUD:UpdateStatus", "clear")
      end
    else
      TriggerEvent(
        "DoLongHudText",
        "You are not the creator of the race...",
        2
      );
      return
    end
  end

  SendReactMessage("RacingSystem:setRacesEvents", Races)
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Racing:StartRaceEvent")
AddEventHandler("vnx-laptop:ClientEvent:Racing:StartRaceEvent", function(raceUniqueID, pPlayerSource)
  local existsPhoneDongleUser = exports["str-inventory"]:hasEnoughOfItem("racingusb1", 1, false)

  if not existsPhoneDongleUser then
    return
  end

  local race = {}
  local playerSource = GetPlayerPed(-1)

  for i = 1, #Races do
    if Races[i].uniqueID == raceUniqueID then
      Races[i].started = true
      race = Races[i]

      for playerIndex = 1, #Races[i].players do
        if race.players[playerIndex].src == playerSource then
          playerInRace = true
        end
      end
    end
  end

  if race == nil then
    return
  end

  if not playerInRace then
    return
  end

  SendReactMessage("RacingSystem:setRacesEvents", Races)

  local raceCheckpoints = json.decode(race.checkpoints)

  local ped = GetPlayerPed(-1)
  local pedCoords = GetEntityCoords(ped)
  local distance = Vdist(
    raceCheckpoints[1].x,
    raceCheckpoints[1].y,
    raceCheckpoints[1].z,
    pedCoords.x,
    pedCoords.y,
    pedCoords.z
  )

  if distance > 150.0 then
    exports["str-phone"]:DoPhoneNotification("home-screen", "Puppet Master", 'You were kicked out of the race...', 1)
    --- Criar endrace
    return
  end

  local myLap = 0
  local myCheckpoint = 1
  local raceIsSprint = true

  SetBlipColour(SetBlips[1], 3)
  SetBlipScale(SetBlips[1], 1.6)

  Citizen.Wait(3000)

  for i = race.countdown, 1, -1 do
    TriggerEvent("DoLongHudText", "Race Starts in " .. tostring(i), 14)
    PlaySound(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0, 0, 1)
    Citizen.Wait(1000)

    if i - 1 == 0 then
      PlaySound(-1, "GO", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
      TriggerEvent("DoLongHudText", "GO!", 14)
    end
  end

  -- Criar atualização de status decorrida
  TriggerEvent("vnx-racing:ClientEvent:RacingHUD:StartingRace")

  Wait(5)

  TriggerEvent("vnx-racing:ClientEvent:RacingHUD:UpdateStatus", "start", {
    maxLaps = race.laps,
    isSprint = true,
    maxCheckpoints = #raceCheckpoints,
    playerId = ped
  })

  while myLap < race.laps + 1 and playerInRace and not race.finished do
    Wait(1)
    local playerInRaceDistance = GetEntityCoords(ped)

    local distanceCheckpoint = Vdist(
      raceCheckpoints[myCheckpoint].x,
      raceCheckpoints[myCheckpoint].y,
      raceCheckpoints[myCheckpoint].z,
      playerInRaceDistance.x, playerInRaceDistance.y, playerInRaceDistance.z
    )

    for racePlayersIndex = 1, #race.players do
      if race.players[racePlayersIndex].src == ped then
        -- race.players[racePlayersIndex].checkpointNumber = myCheckpoint
        race.players[racePlayersIndex].distance = distanceCheckpoint
      end
    end

    -- TriggerServerEvent("vnx-laptop:ServerEvent:Racing:UpdateRacePlayers", raceUniqueID, ped, race.players)

    -- TriggerEvent("vnx-racing:ClientEvent:RacingHUD:UpdateStatus", "update", {
    --   curLap = myLap,
    --   curCheckpoint = myCheckpoint - 1,
    --   players = race.players
    -- })

    if (distanceCheckpoint < raceCheckpoints[myCheckpoint].dist) then
      SetBlipColour(SetBlips[myCheckpoint], 3)
      SetBlipScale(SetBlips[myCheckpoint], 1.0)

      myCheckpoint = myCheckpoint + 1

      SetBlipColour(SetBlips[myCheckpoint], 2)
      SetBlipScale(SetBlips[myCheckpoint], 1.6)
      SetBlipAsShortRange(SetBlips[myCheckpoint - 1], true)
      SetBlipAsShortRange(SetBlips[myCheckpoint], false)

      if myCheckpoint > #raceCheckpoints then
        myCheckpoint = 1
      end

      if myCheckpoint < #raceCheckpoints then
        local key = #SetBlips + 1

        SetBlips[key] = AddBlipForCoord(
          raceCheckpoints[myCheckpoint].x,
          raceCheckpoints[myCheckpoint].y,
          raceCheckpoints[myCheckpoint].z
        )

        SetBlips[key + 1] = AddBlipForCoord(
          raceCheckpoints[myCheckpoint + 1].x,
          raceCheckpoints[myCheckpoint + 1].y,
          raceCheckpoints[myCheckpoint + 1].z
        )

        SetBlipSprite(SetBlips[key], 1)
        SetBlipSprite(SetBlips[key + 1], 1)

        local keyObject = #SetObjectCheckpoints + 1

        SetObjectCheckpoints[keyObject] = CreateObject(
          GetHashKey("prop_offroad_tyres02"),
          vector3(
            raceCheckpoints[myCheckpoint]["flare1x"],
            raceCheckpoints[myCheckpoint]["flare1y"],
            raceCheckpoints[myCheckpoint]["flare1z"] - 0.2
          ),
          false,
          false,
          false
        )

        SetObjectCheckpoints[keyObject + 1] = CreateObject(
          GetHashKey("prop_offroad_tyres02"),
          vector3(
            raceCheckpoints[myCheckpoint]["flare2x"],
            raceCheckpoints[myCheckpoint]["flare2y"],
            raceCheckpoints[myCheckpoint]["flare2z"] - 0.2
          ),
          false,
          false,
          false
        )

        SetObjectCheckpoints[keyObject + 2] = CreateObject(
          GetHashKey("prop_offroad_tyres02"),
          vector3(
            raceCheckpoints[myCheckpoint + 1]["flare1x"],
            raceCheckpoints[myCheckpoint + 1]["flare1y"],
            raceCheckpoints[myCheckpoint + 1]["flare1z"] - 0.2
          ),
          false,
          false,
          false
        )

        SetObjectCheckpoints[keyObject + 3] = CreateObject(
          GetHashKey("prop_offroad_tyres02"),
          vector3(
            raceCheckpoints[myCheckpoint + 1]["flare2x"],
            raceCheckpoints[myCheckpoint + 1]["flare2y"],
            raceCheckpoints[myCheckpoint + 1]["flare2z"] - 0.2
          ),
          false,
          false,
          false
        )

        RemoveBlip(SetBlips[key - 1])
        DeleteObject(SetObjectCheckpoints[keyObject - 1])

        RemoveBlip(SetBlips[key - 2])
        DeleteObject(SetObjectCheckpoints[keyObject - 2])
      end

      ClearGpsMultiRoute()
      StartGpsMultiRoute(0x1C1646FF, true, false)

      if myCheckpoint <= #raceCheckpoints then
        AddPointToGpsMultiRoute(
          raceCheckpoints[myCheckpoint].x,
          raceCheckpoints[myCheckpoint].y,
          raceCheckpoints[myCheckpoint].z
        )
      end

      if myCheckpoint < #raceCheckpoints then
        AddPointToGpsMultiRoute(
          raceCheckpoints[myCheckpoint + 1].x,
          raceCheckpoints[myCheckpoint + 1].y,
          raceCheckpoints[myCheckpoint + 1].z
        )
      end

      if myCheckpoint < #raceCheckpoints - 1 then
        AddPointToGpsMultiRoute(
          raceCheckpoints[myCheckpoint + 2].x,
          raceCheckpoints[myCheckpoint + 2].y,
          raceCheckpoints[myCheckpoint + 2].z
        )
      end

      if myCheckpoint < #raceCheckpoints - 2 then
        AddPointToGpsMultiRoute(
          raceCheckpoints[myCheckpoint + 3].x,
          raceCheckpoints[myCheckpoint + 3].y,
          raceCheckpoints[myCheckpoint + 3].z
        )
      end

      if myCheckpoint < #raceCheckpoints - 3 then
        AddPointToGpsMultiRoute(
          raceCheckpoints[myCheckpoint + 4].x,
          raceCheckpoints[myCheckpoint + 4].y,
          raceCheckpoints[myCheckpoint + 4].z
        )
      end

      SetGpsMultiRouteRender(true)

      if not raceIsSprint and myCheckpoint == 2 then
        myLap = myLap + 1

        SetBlipColour(SetBlips[1], 3)
        SetBlipScale(SetBlips[1], 1.0)
        SetBlipColour(SetBlips[2], 2)
        SetBlipScale(SetBlips[2], 1.6)
      elseif raceIsSprint and myCheckpoint == 1 then
        myLap = myLap + 2
      end

      -- for racePlayersIndex = 1, #race.players do
      --   if race.players[racePlayersIndex].src == ped then
      --     race.players[racePlayersIndex].checkpointNumber = myCheckpoint
      --     -- race.players[racePlayersIndex].distance = distanceCheckpoint
      --   end
      -- end

      local currentRace = {}

      for raceIndex = 1, #Races do
        if Races[raceIndex].uniqueID == raceUniqueID then
          currentRace = Races[raceIndex]
        end
      end

      TriggerServerEvent("vnx-laptop:ServerEvent:Racing:UpdateRacePlayers", raceUniqueID, ped, race.players)

      TriggerEvent("vnx-racing:ClientEvent:RacingHUD:UpdateStatus", "update", {
        curLap = myLap,
        curCheckpoint = (myCheckpoint - 1),
        players = currentRace.players
      })
    end
  end

  TriggerEvent("vnx-racing:ClientEvent:RacingHUD:UpdateStatus", "finished", {
    eventId = race.uniqueID,
    player = playerSource
  })

  DeleteWaypoint()
  ClearGpsMultiRoute()

  playerInRace = false

  for i = 1, #Races do
    if Races[i].uniqueID == raceUniqueID then
      Races[i].started = true
      race = Races[i]

      for playerIndex = 1, #race.players do
        if race.players[playerIndex].src == playerSource then
          playerInRace = false
        end
      end
    end
  end

  TriggerServerEvent("vnx-laptop:ServerEvent:Racing:FinishedRace", race.uniqueID, playerSource)
  TriggerServerEvent("vnx-laptop:ClientEvent:Racing:PaymentForRacingInCrypto", math.random(10, 25))

  -- Wait(40000)
  TriggerEvent("vnx-racing:ClientEvent:RacingHUD:UpdateStatus", "clear")

  for i = 1, #SetBlips do
    -- Wait(1)
    RemoveBlip(SetBlips[i])
  end

  for i = 1, #SetObjectCheckpoints do
    DeleteObject(SetObjectCheckpoints[i])
  end

  SetBlips = {}
  SetObjectCheckpoints = {}
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Racing:UpdateRacePlayers")
AddEventHandler("vnx-laptop:ClientEvent:Racing:UpdateRacePlayers", function(raceUniqueID, playerSource, racePlayers)
  for i = 1, #Races do
    if Races[i].uniqueID == raceUniqueID then
      Races[i].players = racePlayers
    end
  end

  SendReactMessage("RacingSystem:setRacesEvents", Races)
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Racing:PlayerFinished")
AddEventHandler("vnx-laptop:ClientEvent:Racing:PlayerFinished", function(racingUniqueID, playerSourceID)
  local existsPhoneDongleUser = exports["str-inventory"]:hasEnoughOfItem("racingusb1", 1, false)

  if not existsPhoneDongleUser then
    return
  end

  local thisPlayerSourceID = GetPlayerPed(-1)

  local playerThisRace = false

  for i = 1, #Races do
    if Races[i].uniqueID == racingUniqueID then
      for playerIndex = 1, #Races[i].players do
        if Races[i].players[playerIndex].src == thisPlayerSourceID then
          playerThisRace = true
        end
      end
    end
  end

  if not playerThisRace then
    return
  end

  for i = 1, #Races do
    if Races[i].uniqueID == racingUniqueID then
      for playerIndex = 1, #Races[i].players do
        if Races[i].players[playerIndex].src == playerSourceID then
          for finishRacePlayesIndex = 1, #FinishRacePlayes do
            if FinishRacePlayes[finishRacePlayesIndex].raceUniqueID == racingUniqueID then
              local newFinishRacePlayesIndex = #FinishRacePlayes[finishRacePlayesIndex].players + 1

              FinishRacePlayes[finishRacePlayesIndex].players[newFinishRacePlayesIndex] = Races[i].players[playerIndex]
            end
          end
        end
      end

      for finishRacePlayesIndex = 1, #FinishRacePlayes do
        if FinishRacePlayes[finishRacePlayesIndex].raceUniqueID == racingUniqueID then
          if #Races[i].players == #FinishRacePlayes[finishRacePlayesIndex].players then
            Races[i].finished = true

            print("Total de Player na corrida: ", tostring(#Races[i].players))
            print("Total de Players finalizados: ", tostring(#FinishRacePlayes[finishRacePlayesIndex].players))

            Wait(9000)
            TriggerEvent("vnx-racing:ClientEvent:RacingHUD:UpdateStatus", "clear")
            FinishRacePlayes[finishRacePlayesIndex].players = {}
            -- Criar rotina: vnx-laptop:ServerEvent:Racing:SaveRacePlayerStatus
          end
        end
      end
    end
  end

  SendReactMessage("RacingSystem:setRacesEvents", Races)
end)

function AddCheckpointMarker(leftMarker, rightMarker)
  local model = #checkpointMarkers == 0 and 'prop_beachflag_01' or 'prop_offroad_tyres02'

  local checkpointLeft = CreateObject(GetHashKey(model), leftMarker, false, false, false)
  local checkpointRight = CreateObject(GetHashKey(model), rightMarker, false, false, false)

  checkpointMarkers[#checkpointMarkers + 1] = {
    left = checkpointLeft,
    right = checkpointRight
  }

  PlaceObjectOnGroundProperly(checkpointLeft)
  SetEntityAsMissionEntity(checkpointLeft)
  PlaceObjectOnGroundProperly(checkpointRight)
  SetEntityAsMissionEntity(checkpointRight)
end

function CalcDistanceCheckpoints(angle, distance, positionX, positionY)
  local radians = math.rad(angle)
  local newX = positionX + distance * math.cos(radians)
  local newy = positionY + distance * math.cos(radians)

  return newX, newy
end
