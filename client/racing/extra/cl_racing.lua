local racing = false
local currentMap = {}
local customMaps = {}
local distance = 30.0
local creatingMap = false
local SetBlips = {}
local particleList = {}
local currentRaces = {}
local JoinedRaces = {}
local racesStarted = 0
local mylastid = "NA"

function DrawText3D(x, y, z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local px, py, pz = table.unpack(GetGameplayCamCoords())

  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x, _y)

  local factor = (string.len(text)) / 370

  DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

Citizen.CreateThread(function()
  local focus = true

  while true do
    if guiEnabled then
      DisableControlAction(0, 1, guiEnabled)        -- LookLeftRight
      DisableControlAction(0, 2, guiEnabled)        -- LookUpDown
      DisableControlAction(0, 14, guiEnabled)       -- INPUT_WEAPON_WHEEL_NEXT
      DisableControlAction(0, 15, guiEnabled)       -- INPUT_WEAPON_WHEEL_PREV
      DisableControlAction(0, 16, guiEnabled)       -- INPUT_SELECT_NEXT_WEAPON
      DisableControlAction(0, 17, guiEnabled)       -- INPUT_SELECT_PREV_WEAPON
      DisableControlAction(0, 99, guiEnabled)       -- INPUT_VEH_SELECT_NEXT_WEAPON
      DisableControlAction(0, 100, guiEnabled)      -- INPUT_VEH_SELECT_PREV_WEAPON
      DisableControlAction(0, 115, guiEnabled)      -- INPUT_VEH_FLY_SELECT_NEXT_WEAPON
      DisableControlAction(0, 116, guiEnabled)      -- INPUT_VEH_FLY_SELECT_PREV_WEAPON
      DisableControlAction(0, 142, guiEnabled)      -- MeleeAttackAlternate
      DisableControlAction(0, 106, guiEnabled)      -- VehicleMouseControlOverride

      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({ type = "click" })
      end
    else
      mousemovement = 0
    end

    if selfieMode then
      if IsControlJustPressed(0, 177) then
        selfieMode = false

        DestroyMobilePhone()
        CellCamActivate(false, false)
      end

      HideHudComponentThisFrame(7)
      HideHudComponentThisFrame(8)
      HideHudComponentThisFrame(9)
      HideHudComponentThisFrame(6)
      HideHudComponentThisFrame(19)
      HideHudAndRadarThisFrame()
    else
      selfieMode = false
      DestroyMobilePhone()
      CellCamActivate(false, false)
    end

    if creatingMap then
      local plycoords = GetEntityCoords(GetPlayerPed(-1))

      -- local fx, fy, fz = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), distance / 2, 0.0, -0.25))
      -- local fx2, fy2, fz2 = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0 - distance / 2, 0.0, -0.25))

      -- CreateObject(GetHashKey('prop_offroad_tyres02'), vector3(fx, fy, fz), false, false, false)
      -- CreateObject(GetHashKey('prop_offroad_tyres02'), vector3(fx2, fy2, fz2), false, false, false)

      DrawMarker(
        27,
        plycoords.x,
        plycoords.y,
        plycoords.z,
        0,
        0,
        0,
        0,
        0,
        0,
        distance,
        distance,
        0.3001,
        255,
        255,
        255,
        255,
        0,
        0,
        0,
        0
      )

      if #currentMap == 0 then
        exports['str-ui']:showInteraction('[E] to add start point, up/down for size, phone to save or cancel.')
      else
        exports['str-ui']:showInteraction('[E] to add start point, up/down for size, phone to save or cancel.')
      end

      if IsControlPressed(0, 27) then
        distance = distance + 1

        if distance > 60.0 then
          distance = 60.0
        end
      end

      if IsControlPressed(0, 173) then
        distance = distance - 1

        if distance < 4 then
          distance = 3.0
        end
      end

      if IsControlJustReleased(0, 38) then
        if (IsControlPressed(0, 21)) then
          PopLastCheckpoint()
        else
          AddCheckPoint()
        end
        Wait(1000)
      end
    end
    Citizen.Wait(1)
  end
end)

function StartMapCreation()
  currentMap = {}
  distance = 30.0
  creatingMap = true
end

function CancelMap()
  creatingMap = false
end

function ClearBlips()
  for i = 1, #SetBlips do
    RemoveBlip(SetBlips[1])
  end

  SetBlips = {}
end

function AddCheckPoint()
  LoadingCheckpointModels()

  local plycoords = GetEntityCoords(GetPlayerPed(-1))
  local ballsdick = distance / 2
  local fx, fy, fz = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), ballsdick, 0.0, -0.25))
  local fx2, fy2, fz2 = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0 - ballsdick, 0.0, -0.25))

  AddCheckpointMarker(vector3(fx, fy, fz), vector3(fx2, fy2, fz2))

  local start = false

  if #currentMap == 0 then
    start = true
  end

  local checkcounter = #currentMap + 1

  currentMap[checkcounter] = {
    ["flare1x"] = FUCKK(fx),
    ["flare1y"] = FUCKK(fy),
    ["flare1z"] = FUCKK(fz),
    ["flare2x"] = FUCKK(fx2),
    ["flare2y"] = FUCKK(fy2),
    ["flare2z"] = FUCKK(fz2),
    ["x"] = FUCKK(plycoords.x),
    ["y"] = FUCKK(plycoords.y),
    ["z"] = FUCKK(plycoords.z - 1.1),
    ["start"] = start,
    ["dist"] = ballsdick,
  }

  local key = #SetBlips + 1

  SetBlips[key] = AddBlipForCoord(plycoords.x, plycoords.y, plycoords.z)
  SetBlipAsFriendly(SetBlips[key], true)
  SetBlipSprite(SetBlips[key], 1)
  ShowNumberOnBlip(SetBlips[key], key)
  BeginTextCommandSetBlipName("STRING");
  AddTextComponentString(tostring("Checkpoint " .. key))
  EndTextCommandSetBlipName(SetBlips[key])
end

local checkpointMarkers = {}
local isModelsLoaded = false
function LoadingCheckpointModels()
  local models = {}

  models[1] = "prop_offroad_tyres02"
  models[2] = "prop_beachflag_01"

  for i = 1, #models do
    local checkpointModel = GetHashKey(models[1])
    RequestModel(checkpointModel)
    while not HasModelLoaded(checkpointModel) do
      Citizen.Wait(1)
    end
  end

  isModelsLoaded = true
end

function AddCheckpointMarker(pLeftMarker, pRightMarker)
  local model = #checkpointMarkers == 0 and 'prop_beachflag_01' or 'prop_offroad_tyres02'

  local checkpointLeft = CreateObject(GetHashKey(model), pLeftMarker, false, false, false)
  local checkpointRight = CreateObject(GetHashKey(model), pRightMarker, false, false, false)

  checkpointMarkers[#checkpointMarkers + 1] = {
    left = checkpointLeft,
    right = checkpointRight
  }

  PlaceObjectOnGroundProperly(checkpointLeft)
  SetEntityAsMissionEntity(checkpointLeft)
  PlaceObjectOnGroundProperly(checkpointRight)
  SetEntityAsMissionEntity(checkpointRight)
end

function LoadMapBlips(id, reverseTrack, laps)
  local id = tostring(id)

  ClearBlips()
  LoadingCheckpointModels()

  if customMaps[id].checkpoints ~= nil then
    local checkpoints = customMaps[id].checkpoints

    if reverseTrack then
      local newCheckpoints = {}
      local count = 1

      for i = #checkpoints, 1, -1 do
        newCheckpoints[count] = checkpoints[i]
        count = count + 1
      end

      if laps ~= 0 then
        table.insert(newCheckpoints, 1, checkpoints[1])
        newCheckpoints[#newCheckpoints] = nil
      end

      checkpoints = newCheckpoints
    end

    for mId, map in pairs(checkpoints) do
      local key = #SetBlips + 1

      SetBlips[key] = AddBlipForCoord(map["x"], map["y"], map["z"])
      SetBlipAsFriendly(SetBlips[key], true)
      SetBlipAsShortRange(SetBlips[key], true)
      SetBlipSprite(SetBlips[key], 1)
      ShowNumberOnBlip(SetBlips[key], key)
      BeginTextCommandSetBlipName("STRING");
      AddTextComponentString(tostring("Checkpoint " .. key))
      EndTextCommandSetBlipName(SetBlips[key])

      AddCheckpointMarker(
        vector3(map["flare1x"], map["flare1y"], map["flare1z"]),
        vector3(map["flare2x"], map["flare2y"], map["flare2z"])
      )
    end
  end
end

function PopLastCheckpoint()
  if #currentMap > 1 then
    local lastCheckpoint = #currentMap

    SetEntityAsNoLongerNeeded(checkpointMarkers[lastCheckpoint].left)
    DeleteObject(checkpointMarkers[lastCheckpoint].left)
    SetEntityAsNoLongerNeeded(checkpointMarkers[lastCheckpoint].right)
    DeleteObject(checkpointMarkers[lastCheckpoint].right)

    RemoveBlip(SetBlips[lastCheckpoint])

    table.remove(checkpointMarkers)
    table.remove(currentMap)
    table.remove(SetBlips)
  end
end

function ShowText(text)
  TriggerEvent("DoLongHudText", text)
end

function StartEvent(map, laps, counter, reverseTrack, raceName, starttime, mapCreator, mapDistance, mapDescription)
  local map = tostring(map)
  local laps = tonumber(laps)
  local counter = tonumber(counter)
  local mapCreator = tostring(mapCreator)
  local mapDistance = tonumber(mapDistance)
  local mapDescription = tostring(mapDescription)
  local reverseTrack = reverseTrack

  if map == 0 then
    ShowText("Pick a map or use the old racing system")
    return
  end

  local mapCheckpoints = customMaps[map]["checkpoints"]
  local checkPointIndex = 1

  local dist = Vdist(
    mapCheckpoints[checkPointIndex]["x"],
    mapCheckpoints[checkPointIndex]["y"],
    mapCheckpoints[checkPointIndex]["z"],
    plyCoords.x, plyCoords.y, plyCoords.z
  )

  if dist > 40.0 then
    TriggerEvent('phone:addJobNotify', 'You\'re too far away from the starting line.')

    EndRace()

    SetNewWaypoint(
      mapCheckpoints[checkPointIndex]["x"],
      mapCheckpoints[checkPointIndex]["y"],
      mapCheckpoints[checkPointIndex]["z"]
    )
    return
  end

  ShowText("Race Starting on " .. customMaps[map]["track_name"] .. " with " ..
    laps .. " laps in " .. counter .. " seconds!")

  racesStarted = racesStarted + 1

  local cid = exports["isPed"]:isPed("cid")
  local uniqueid = cid .. "-" .. racesStarted

  local s1, s2 = GetStreetNameAtCoord(
    mapCheckpoints[checkPointIndex].x,
    mapCheckpoints[checkPointIndex].y,
    mapCheckpoints[checkPointIndex].z
  )

  local street1 = GetStreetNameFromHashKey(s1)

  zone = tostring(GetNameOfZone(
    mapCheckpoints[checkPointIndex].x,
    mapCheckpoints[checkPointIndex].y,
    mapCheckpoints[checkPointIndex].z)
  )

  local playerStreetsLocation = GetLabelText(zone)

  local dir = getCardinalDirectionFromHeading()
  local street1 = street1 .. ", " .. playerStreetsLocation
  local street2 = GetStreetNameFromHashKey(s2) .. " " .. dir
end

function HudUpdate(pHudState, pHudData)
  pHudState = pHudState or 'finished'
  pHudData = pHudData or '{}'

  SendNUIMessage({
    openSection = "racing:hud:update",
    hudState = pHudState,
    hudData = pHudData
  })
end

function RunRace(identifier)
  local map = currentRaces[identifier].map
  local laps = currentRaces[identifier].laps
  local counter = currentRaces[identifier].counter
  local sprint = false

  if laps == 0 then
    laps = 1
    sprint = true
  end

  local myLap = 0

  local checkpoints = #customMaps[map]["checkpoints"]
  local mycheckpoint = 1
  local ped = GetPlayerPed(-1)

  SetBlipColour(SetBlips[1], 3)
  SetBlipScale(SetBlips[1], 1.6)

  -- TriggerEvent("DoLongHudText", "Race Starts in 3", 14)
  -- PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
  -- Citizen.Wait(1000)
  -- TriggerEvent("DoLongHudText", "Race Starts in 2", 14)
  -- PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
  -- Citizen.Wait(1000)
  -- TriggerEvent("DoLongHudText", "Race Starts in 1", 14)
  -- PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
  -- Citizen.Wait(1000)
  -- PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
  TriggerEvent("DoLongHudText", "GO!", 14)

  -- HudUpdate("start", { isSprint = sprint, maxLaps = laps, maxCheckpoints = checkpoints })

  while myLap < laps + 1 and racing do
    Wait(1)

    local plyCoords = GetEntityCoords(ped)

    if (Vdist(
          customMaps[map]["checkpoints"][mycheckpoint]["x"],
          customMaps[map]["checkpoints"][mycheckpoint]["y"],
          customMaps[map]["checkpoints"][mycheckpoint]["z"],
          plyCoords.x, plyCoords.y, plyCoords.z)
        ) < customMaps[map]["checkpoints"][mycheckpoint]["dist"] then
      SetBlipColour(SetBlips[mycheckpoint], 3)
      SetBlipScale(SetBlips[mycheckpoint], 1.0)

      mycheckpoint = mycheckpoint + 1

      SetBlipColour(SetBlips[mycheckpoint], 2)
      SetBlipScale(SetBlips[mycheckpoint], 1.6)
      SetBlipAsShortRange(SetBlips[mycheckpoint - 1], true)
      SetBlipAsShortRange(SetBlips[mycheckpoint], false)

      if mycheckpoint > checkpoints then
        mycheckpoint = 1
      end

      SetNewWaypoint(
        customMaps[map]["checkpoints"][mycheckpoint]["x"],
        customMaps[map]["checkpoints"][mycheckpoint]["y"]
      )

      if not sprint and mycheckpoint == 1 then
        SetBlipColour(SetBlips[1], 2)
        SetBlipScale(SetBlips[1], 1.6)
      end

      if not sprint and mycheckpoint == 2 then
        myLap = myLap + 1

        -- Uncomment these lines to make the checkpoints re-draw on each lap
        -- ClearBlips()
        -- RemoveCheckpoints()
        -- LoadMapBlips(map)
        SetBlipColour(SetBlips[1], 3)
        SetBlipScale(SetBlips[1], 1.0)
        SetBlipColour(SetBlips[2], 2)
        SetBlipScale(SetBlips[2], 1.6)
      elseif sprint and mycheckpoint == 1 then
        myLap = myLap + 2
      end

      HudUpdate("update", { curLap = myLap, curCheckpoint = (mycheckpoint - 1) })
    end
  end

  HudUpdate("finished", { eventId = identifier })

  PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
  TriggerEvent("DoLongHudText", "You have finished!", 1)

  Wait(10000)

  racing = false

  hudUpdate("clear")
  ClearBlips()
  RemoveCheckpoints()
end

function EndRace()
  ClearBlips()
  RemoveCheckpoints()
end

function RemoveCheckpoints()
  for i = 1, #checkpointMarkers do
    SetEntityAsNoLongerNeeded(checkpointMarkers[i].left)
    DeleteObject(checkpointMarkers[i].left)
    SetEntityAsNoLongerNeeded(checkpointMarkers[i].right)
    DeleteObject(checkpointMarkers[i].right)
    checkpointMarkers[i] = nil
  end
end

function FUCKK(num)
  local new = math.ceil(num * 100)
  new = new / 100
  return new
end

function SaveMap(name, description)
  local distanceMap = 0.0

  for i = 1, #currentMap do
    if i == #currentMap then
      distanceMap = Vdist(
        currentMap[i]["x"],
        currentMap[i]["y"],
        currentMap[i]["z"],
        currentMap[1]["x"],
        currentMap[1]["y"],
        currentMap[1]["z"]
      ) + distanceMap
    else
      distanceMap = Vdist(
        currentMap[i]["x"],
        currentMap[i]["y"],
        currentMap[i]["z"],
        currentMap[i + 1]["x"],
        currentMap[i + 1]["y"],
        currentMap[i + 1]["z"]
      ) + distanceMap
    end
  end

  distanceMap = math.ceil(distanceMap)

  if #currentMap > 1 then
    exports['str-ui']:hideInteraction()
    TriggerEvent('phone:addJobNotify', 'Map successfully created.')
    TriggerServerEvent("vnx-laptop:ServerEvent:Racing:SaveRace", currentMap, name, description, distanceMap)
  else
    TriggerEvent("DoLongHudText", "Failed due to lack of checkpoints", 2)
  end

  currentMap = {}
  creatingMap = false
end

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:ListEvents", function(data, cb)
  local result = RPC.execute("vnx-laptop:ServerEvent:Racing:ListRacesEvents")

  cb(result)
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:StartEvent", function(data, cb)
  cb({})
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:Create", function(data, cb)
  StartMapCreation()

  cb({})
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:CancelCreate", function(data, cb)
  currentMap = {}
  -- distance = 30.0
  creatingMap = false

  EndRace()
  CancelMap()

  cb({})
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:Load", function(data)
  ClearBlips()
  RemoveCheckpoints()

  if data.id ~= nil then
    LoadMapBlips(data.id)
  end
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:Delete", function(data)
  ClearBlips()
  RemoveCheckpoints()

  if data.id ~= 0 then
    -- TriggerServerEvent("vnx-laptop:ServerEvent:Racing:MapDelete", customMaps[tonumber(data.id)]["dbid"])
  end
end)

RegisterNuiCallback("vnx-laptop:NUIEvent:Racing:RemoveBlips", function()
  EndRace()
end)

RegisterNuiCallback("vnx-laptop:NUIEvent:Racing:Cancel", function()
  EndRace()
  CancelMap()
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:Save", function(data, cb)
  EndRace()
  SaveMap(data.name, data.desc)

  cb({})
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Racing:ViewRaceEvent", function(data, cb)
  cb({})
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Racing:Set")
AddEventHandler("vnx-laptop:ClientEvent:Racing:set", function(data)
  if data.event == "map" then
    if data.eventId ~= -1 then
      customMaps[data.eventId] = data.data
    else
      customMaps = data.data

      if data.subEvent == nil or data.subEvent ~= "noNUI" then
        SendNuiMessage({ openSection = 'racing-start', maps = customMaps })
      end
    end
  elseif data.event == "event" then
    if data.eventId ~= -1 then
      currentRaces[data.eventId] = data.data

      if JoinedRaces[data.eventId] and racing and data.subEvent == "close" then
        RunRace(data.eventId)
      end

      --   SendNUIMessage({
      --     openSection = "racing:event:update",
      --     eventId = data.eventId,
      --     raceData = currentRaces[data.eventId]
      --   })
      -- else

      currentRaces = data.data

      -- SendNUIMessage({ openSection = "racing:event:update", raceData = currentRaces })
    end
  end
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Racing:FinishedRaces")
AddEventHandler("vnx-laptop:ClientEvent:Racing:FinishedRaces", function(id)
  if JoinedRaces[id] ~= nil then
    JoinedRaces[id] = nil

    ClearBlips()
    RemoveCheckpoints()
  end
end)
