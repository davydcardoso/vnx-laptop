local QueueTimeMin = 1
local QueueTimeMax = 1
local IsInQueue = false
local AlredyContract = false
local BoostingStatus = nil
local myContracts = nil
local CurrentContract = {}

local pVeh = nil

-- RegisterComm

BoostingClientBlips = {
  ActivePlayers = {},
  distant = {},
}

function BoostingClientBlips:UpdateBlips(playerID, x, y, z)
  local player = nil

  player = GetPlayerFromServerId(playerID)

  if IsPoliceAllowed() then
    if BoostingClientBlips.ActivePlayers[playerID] == nil then
      BoostingClientBlips.ActivePlayers[playerID] = AddBlipForCoord(x, y, z)
      SetBlipScale(BoostingClientBlips.ActivePlayers[playerID], 1.2)
      SetBlipSprite(BoostingClientBlips.ActivePlayers[playerID], 225)
      SetBlipColour(BoostingClientBlips.ActivePlayers[playerID], 1)
      BeginTextCommandSetBlipName('STRING')
      AddTextComponentString('[Boosting] - Stolen Vehicle')

      EndTextCommandSetBlipName(BoostingClientBlips.ActivePlayers[playerID])
    elseif BoostingClientBlips.ActivePlayers[playerID] and x ~= 0.0 then
      SetBlipCoords(BoostingClientBlips.ActivePlayers[playerID], x, y, z)
    end
  end
end

function BoostingClientBlips:remove(playerID)
  if BoostingClientBlips.ActivePlayers[playerID] then
    RemoveBlip(BoostingClientBlips.ActivePlayers[playerID])
    BoostingClientBlips.ActivePlayers[playerID] = nil
  end
end

function BoostingClientBlips:Update(info)
  for k, v in pairs(info) do
    BoostingClientBlips.UpdateBlips(k, k, v.coords.x, v.coords.y, v.coords.z)
  end
end

RegisterNetEvent("vnx-laptop:ClientEvent:Boosting:RemoveBlip")
AddEventHandler("vnx-laptop:ClientEvent:Boosting:RemoveBlip", function(playerID)
  BoostingClientBlips:remove(playerID)
end)

local tabletObject, isInTablet, VehicleStoled = nil, false, nil
local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
local anim = "machinic_loop_mechandplayer"
local flags = 49
local Circle
local placa
local DropZoneBlip
local itemBlip
local IdToRemove
local IsInQueue = false
local isVin = false
local CanChangePlate = false
local AlredyVinScratch = false
local IsAllOk = false
local isPoliceBlip = false
local AlredyContract = false
local gne = 0
local login = false
local pendingDelivery = false
local cooldown = false
local ACTIVE_EMERGENCY_PERSONNEL = {}
local hacks = {
  number1 = false,
  number2 = false,
  number3 = false,
  number4 = false,
  number5 = false,
  number6 = false,
  number7 = false,
  number8 = false,
  number9 = false,
  number10 = false,
}

Contracts = {}

-------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------FUNCTIONS--------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
function HackingStage(number)
  if number == 1 then
    hacks.number1 = true
  elseif number == 2 then
    hacks.number1 = true
    hacks.number2 = true
  elseif number == 3 then
    hacks.number1 = true
    hacks.number2 = true
    hacks.number3 = true
  elseif number == 4 then
    hacks.number1 = true
    hacks.number2 = true
    hacks.number3 = true
    hacks.number4 = true
  elseif number == 5 then
    hacks.number1 = true
    hacks.number2 = true
    hacks.number3 = true
    hacks.number4 = true
    hacks.number5 = true
  elseif number == 6 then
    hacks.number1 = true
    hacks.number2 = true
    hacks.number3 = true
    hacks.number4 = true
    hacks.number5 = true
    hacks.number6 = true
  elseif number == 7 then
    hacks.number1 = true
    hacks.number2 = true
    hacks.number3 = true
    hacks.number4 = true
    hacks.number5 = true
    hacks.number6 = true
    hacks.number7 = true
  elseif number == 8 then
    hacks.number1 = true
    hacks.number2 = true
    hacks.number3 = true
    hacks.number4 = true
    hacks.number5 = true
    hacks.number6 = true
    hacks.number7 = true
    hacks.number8 = true
  elseif number == 9 then
    hacks.number1 = true
    hacks.number2 = true
    hacks.number3 = true
    hacks.number4 = true
    hacks.number5 = true
    hacks.number6 = true
    hacks.number7 = true
    hacks.number8 = true
    hacks.number9 = true
  elseif number == 10 then
    hacks.number1 = true
    hacks.number2 = true
    hacks.number3 = true
    hacks.number4 = true
    hacks.number5 = true
    hacks.number6 = true
    hacks.number7 = true
    hacks.number8 = true
    hacks.number9 = true
    hacks.number10 = true
  end
end

RegisterNetEvent("vnx-laptop:ClientEvent:Boosting:UpdateBlips")
AddEventHandler("vnx-laptop:ClientEvent:Boosting:UpdateBlips", function(info)
  if GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())) == placa then
    BoostingClientBlips:Update(info)
  end
end)

function GetVehicleInDirection(coordFrom, coordTo)
  local offset = 0
  local rayHandle
  local vehicle

  for i = 0, 100 do
    rayHandle = CastRayPointToPoint(
      coordFrom.x,
      coordFrom.y,
      coordFrom.z,
      coordTo.x,
      coordTo.y,
      coordTo.z + offset,
      10,
      PlayerPedId(),
      0
    )
    a, b, c, d, vehicle = GetRaycastResult(rayHandle)

    offset = offset - 1

    if vehicle ~= 0 then
      break
    end
  end

  local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))

  if distance > 25 then
    vehicle = nil
  end

  return vehicle ~= nil and vehicle or 0
end

function HackingIsCompleted()
  return hacks.number1 == false
      and hacks.number2 == false
      and hacks.number3 == false
      and hacks.number4 == false
      and hacks.number5 == false
      and hacks.number6 == false
      and hacks.number7 == false
      and hacks.number8 == false
      and hacks.number9 == false
      and hacks.number10 == false

  -- if hacks.number1 == false and hacks.number2 == false and hacks.number3 == false and hacks.number4 == false and hacks.number5 == false and hacks.number6 == false and hacks.number7 == false and hacks.number8 == false and hacks.number9 == false and hacks.number10 == false then
  --   return true
  -- else
  --   return false
  -- end
end

function FinishPolice()
  if isVin then
    -- sendAppEvent('BoostingNotification',
    --   {
    --     notify = {
    --       msg = "Go to the marked place and scratch the vin.",
    --       time = "3/4",
    --       app = 'Boosting',
    --       img = 'https://imgur.com/FEPqpLc.png'
    --     }
    --   }
    -- )

    TriggerEvent('DoLongHudText', 'Go to the marked place and scratch the vin', 1)

    isPoliceBlip = false

    RemoveCopBlip()
    TriggerServerEvent("vnx-laptop:ServerEvent:Boosting:SendRemovePoliceBlip")
  else
    isPoliceBlip = false
    RemoveCopBlip()
    TriggerServerEvent("boosting:SendRemovePoliceBlip", VehicleStoled)
  end
end

function DoHackingStagesCOP()
  if hacks.number1 == true then
    hacks.number1 = false
    TriggerEvent('DoLongHudText', 'You finish hack number: 1', 1)
    if HackingIsCompleted() then
      FinishPolice()
    end
  elseif hacks.number2 == true then
    hacks.number2 = false
    TriggerEvent('DoLongHudText', 'You finish hack number: 2', 1)
    if HackingIsCompleted() then
      FinishPolice()
    end
  elseif hacks.number3 == true then
    hacks.number3 = false
    TriggerEvent('DoLongHudText', 'You finish hack number: 3', 1)
    if HackingIsCompleted() then
      FinishPolice()
    end
  elseif hacks.number4 == true then
    hacks.number4 = false
    TriggerEvent('DoLongHudText', 'You finish hack number: 4', 1)
    if HackingIsCompleted() then
      FinishPolice()
    end
  elseif hacks.number5 == true then
    hacks.number5 = false
    TriggerEvent('DoLongHudText', 'You finish hack number: 5', 1)
    if HackingIsCompleted() then
      FinishPolice()
    end
  elseif hacks.number6 == true then
    hacks.number6 = false
    TriggerEvent('DoLongHudText', 'You finish hack number: 5', 1)
    if HackingIsCompleted() then
      FinishPolice()
    end
  elseif hacks.number7 == true then
    hacks.number7 = false
    TriggerEvent('DoLongHudText', 'You finish hack number: 7', 1)
    if HackingIsCompleted() then
      FinishPolice()
    end
  elseif hacks.number8 == true then
    hacks.number8 = false
    TriggerEvent('DoLongHudText', 'You finish hack number: 8', 1)
    if HackingIsCompleted() then
      FinishPolice()
    end
  elseif hacks.number9 == true then
    hacks.number9 = false
    TriggerEvent('DoLongHudText', 'You finish hack number: 9', 1)
    if HackingIsCompleted() then
      FinishPolice()
    end
  elseif hacks.number10 == true then
    hacks.number10 = false
    TriggerEvent('DoLongHudText', 'You finish hack number: 10', 1)
    if HackingIsCompleted() then
      FinishPolice()
    end
  end
  return true
end

function DoHackingStages()
  if hacks.number1 == true then
    if CustomMinigameHack() then
      hacks.number1 = false
      TriggerEvent('DoLongHudText', 'Hack Success!', 1)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return true
    else
      TriggerEvent('DoLongHudText', 'Hack Failed!', 2)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return false
    end
  elseif hacks.number2 == true then
    if CustomMinigameHack() then
      hacks.number2 = false
      TriggerEvent('DoLongHudText', 'Hack Success!', 1)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return true
    else
      TriggerEvent('DoLongHudText', 'Hack Failed!', 2)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return false
    end
  elseif hacks.number3 == true then
    if CustomMinigameHack() then
      hacks.number3 = false
      TriggerEvent('DoLongHudText', 'Hack Success!', 1)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return true
    else
      TriggerEvent('DoLongHudText', 'Hack Failed!', 2)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return false
    end
  elseif hacks.number4 == true then
    if CustomMinigameHack() then
      hacks.number4 = false
      TriggerEvent('DoLongHudText', 'Hack Success!', 1)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return true
    else
      TriggerEvent('DoLongHudText', 'Hack Failed!', 2)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return false
    end
  elseif hacks.number5 == true then
    if CustomMinigameHack() then
      hacks.number5 = false
      TriggerEvent('DoLongHudText', 'Hack Success!', 1)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return true
    else
      TriggerEvent('DoLongHudText', 'Hack Failed!', 2)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return false
    end
  elseif hacks.number6 == true then
    if CustomMinigameHack() then
      hacks.number6 = false
      TriggerEvent('DoLongHudText', 'Hack Success!', 1)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return true
    else
      TriggerEvent('DoLongHudText', 'Hack Failed!', 2)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return false
    end
  elseif hacks.number7 == true then
    if CustomMinigameHack() then
      hacks.number7 = false
      TriggerEvent('DoLongHudText', 'Hack Success!', 1)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return true
    else
      TriggerEvent('DoLongHudText', 'Hack Failed!', 2)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return false
    end
  elseif hacks.number8 == true then
    if CustomMinigameHack() then
      hacks.number8 = false
      TriggerEvent('DoLongHudText', 'Hack Success!', 1)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return true
    else
      TriggerEvent('DoLongHudText', 'Hack Failed!', 2)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return false
    end
  elseif hacks.number9 == true then
    if CustomMinigameHack() then
      hacks.number9 = false
      TriggerEvent('DoLongHudText', 'Hack Success!', 1)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return true
    else
      TriggerEvent('DoLongHudText', 'Hack Failed!', 2)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return false
    end
  elseif hacks.number10 == true then
    if CustomMinigameHack() then
      hacks.number10 = false
      TriggerEvent('DoLongHudText', 'Hack Success!', 1)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return true
    else
      TriggerEvent('DoLongHudText', 'Hack Failed!', 2)
      TriggerEvent('vnx-laptop:ClientEvent:Boosting:AddCooldownHack')
      return false
    end
  end
  return true
end

function NumberOfContractsByLevel(level)
  if level == "D" then
    TriggerEvent('DoLongHudText', 'You will have to hack the vehicle ' .. Config.NumberOfHacks.D .. 'x', 1)
    return Config.NumberOfHacks.D
  elseif level == "C" then
    TriggerEvent('DoLongHudText', 'You will have to hack the vehicle ' .. Config.NumberOfHacks.C .. 'x', 1)
    return Config.NumberOfHacks.C
  elseif level == "B" then
    TriggerEvent('DoLongHudText', 'You will have to hack the vehicle ' .. Config.NumberOfHacks.B .. 'x', 1)
    return Config.NumberOfHacks.B
  elseif level == "A" then
    TriggerEvent('DoLongHudText', 'You will have to hack the vehicle ' .. Config.NumberOfHacks.A .. 'x', 1)
    return Config.NumberOfHacks.A
  elseif level == "S" then
    TriggerEvent('DoLongHudText', 'You will have to hack the vehicle ' .. Config.NumberOfHacks.S .. 'x', 1)
    return Config.NumberOfHacks.S
  elseif level == "S+" then
    TriggerEvent('DoLongHudText', 'You will have to hack the vehicle ' .. Config.NumberOfHacks.SPLUS .. 'x', 1)
    return Config.NumberOfHacks.SPLUS
  end
end

function RandomChange(percent)
  local re = percent >= math.random(1, 100)
  return re
end

function CreateBlip(v)
  Circle = Citizen.InvokeNative(
    0x46818D79B1F7499A,
    v.x + math.random(0.0, 150.0),
    v.y + math.random(0.0, 80.0),
    v.z + math.random(0.0, 5.0),
    300.0
  ) -- you can use a higher number for a bigger zone

  SetBlipHighDetail(Circle, true)
  SetBlipColour(Circle, 18)
  SetBlipAlpha(Circle, 128)
end

function DeleteCircle()
  if DoesBlipExist(Circle) then
    RemoveBlip(Circle)
  end
end

function DeleteBlip()
  if DoesBlipExist(Circle) then
    RemoveBlip(Circle)
  end
end

function AddBlip(coords, sprite, colour, text)
  local blip = AddBlipForCoord(coords)

  SetBlipSprite(blip, sprite)
  SetBlipColour(blip, colour)
  SetBlipScale(blip, 1.0)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(text)
  EndTextCommandSetBlipName(blip)

  return blip
end

function RemoveCopBlip()
  -- TriggerEvent("vnx-laptop:ClientEvent:Boosting:SendRemovePoliceBlip")
end

function LoadAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Citizen.Wait(5)
  end
end

function CreateVeh(model, coord, id)
  pVeh = tostring(model)
  local Hash = tostring(model)

  if not IsModelInCdimage(Hash) then
    return
  end

  RequestModel(Hash)

  while not HasModelLoaded(Hash) do
    Citizen.Wait(10)
  end

  veh = CreateVehicle(Hash, coord.x, coord.y, coord.z, 0.0, true, false)

  SetModelAsNoLongerNeeded(Hash)
  SetVehicleEngineOn(veh, false, false)
  SetVehicleDoorsLocked(veh, 2)

  return veh, GetVehicleNumberPlateText(veh)
end

function MakeDropZoneThreadVin(IsInWay)
  local setCoords = Config.VinDropZones[math.random(1, Config.NumberVinDropZones)].coords

  DropZoneBlip = AddBlip(setCoords, 225, 2, "Vin Scratch")

  Citizen.CreateThread(function()
    while IsInWay do
      Citizen.Wait(1000)

      local plped = PlayerPedId()
      local coordA = GetEntityCoords(plped)
      local veh = GetVehiclePedIsIn(plped)

      if (veh ~= 0) then
        if (GetVehicleNumberPlateText(veh) == placa) then
          if HackingIsCompleted() and not recentlyScratched then
            local aDist = GetDistanceBetweenCoords(setCoords, coordA)

            if aDist < 10.0 then
              CanScratchVehicle = true
            else
              CanScratchVehicle = false
            end
          end
        end
      end
    end
  end)
end

function GenerateStringNumber(format)
  local abyte = string.byte("A")
  local zbyte = string.byte("0")

  local number = ""
  for i = 1, #format do
    local char = string.sub(format, i, i)
    if char == "D" then
      number = number .. string.char(zbyte + math.random(0, 9))
    elseif char == "L" then
      number = number .. string.char(abyte + math.random(0, 25))
    else
      number = number .. char
    end
  end

  return number
end

function FilterLevel(number)
  local boomer = tonumber(number)
  if boomer >= 0 and boomer <= 100 then
    return boomer, 'D', 'C'
  elseif boomer >= 100 and boomer <= 200 then
    return boomer - 100, 'C', 'B'
  elseif boomer >= 200 and boomer <= 300 then
    return boomer - 200, 'B', 'A'
  elseif boomer >= 200 and boomer <= 400 then
    return boomer - 300, 'A', 'S'
  elseif boomer >= 200 and boomer <= 500 then
    return boomer - 400, 'S', 'S+'
  else
    return 100, 'S', 'S+'
  end
end

function GetNearestPlayer(radius)
  local p = nil
  local players = GetNearestSource(radius)
  local min = radius + 10.0
  for k, v in pairs(players) do
    if v < min then
      min = v
      p = k
    end
  end
  return p
end

function GetNearestSource(radius)
  local r = {}

  local ped = PlayerPedId()
  local pid = PlayerId()
  local px, py, pz = table.unpack(GetEntityCoords(ped))

  for k in pairs(GetActivePlayers()) do
    local player = GetPlayerFromServerId(k)

    if player ~= pid and NetworkIsPlayerConnected(player) then
      local oped = GetPlayerPed(player)
      local x, y, z = table.unpack(GetEntityCoords(oped, true))
      local distance = GetDistanceBetweenCoords(x, y, z, px, py, pz, true)
      if distance <= radius then
        r[GetPlayerServerId(player)] = distance
      end
    end
  end

  return r
end

-------------------------------------------------------------------------------------------------------------------------------
------------------------------FUNCTIONS FOR CRATE CONTRACTS AND UPDATE CONTRACTS-----------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

RegisterNuiCallback("vnx-laptop:Boosting:OpenBoostingApp:StartEvents", function(data, cb)
  local existsPuppetUsbDevice = exports["str-inventory"]:hasEnoughOfItem("puppet_usbdevice", 1, false)
  TriggerServerEvent("vnx-laptop:Boosting:ServerEvent:CheckAllBoostingInformation", existsPuppetUsbDevice)

  cb({})
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Boosting:CheckAllInformation")
AddEventHandler("vnx-laptop:ClientEvent:Boosting:CheckAllInformation", function(data)
  BoostingStatus = data.BoostingStatus

  SendReactMessage("BoostingSystem:ResultBoostingData", data)
end)

RegisterNUICallback("vnx-laptop:ClientSide:Boosting:JoinQueue", function(data, cb)
  BoostingStatus = data.BoostingStatus

  if BoostingStatus == "DISABLED" then
    TriggerEvent("emailNotify", 'Boosting disabled by Puppets!!')

    cb(false)
    return
  end

  IsInQueue = data.inQueue

  if IsInQueue then
    TriggerEvent("emailNotify", 'You`ve joined the boosting queue!')

    TriggerServerEvent("vnx-laptop:ServerEvent:Boosting:JoinInQueue")
    TriggerServerEvent("vnx-laptop:Boosting:ServerEvent:CheckAllBoostingInformation")

    cb(true)
    return;
  end

  TriggerServerEvent("vnx-laptop:ServerEvent:Boosting:ExitQueue")
  cb(false)
end)

RegisterNUICallback("vnx-laptop:NUIEvent:Boosting:UpdateBoostingQueueStatus", function(data, cb)
  TriggerServerEvent("vnx-laptop:ServerEvent:Boosting:EnabledOrDisabled")

  cb({})
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Boosting:EnabledOrDisabled")
AddEventHandler("vnx-laptop:ClientEvent:Boosting:EnabledOrDisabled", function(pStatus)
  BoostingStatus = pStatus

  SendReactMessage("BoostingSystem:ResultBoostingQueueStatus", { QueueStatus = pStatus })
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Boosting:AddContractToList")
AddEventHandler("vnx-laptop:ClientEvent:Boosting:AddContractToList", function(pContracts)
  SendReactMessage("BoostingSystem:ResultMyBoostingContracts", pContracts)
end)

function getClock()
  local hour = GetClockHours()
  local minute = GetClockMinutes()
  if hour < 9 then
    hour = '0' .. hour
  end
  if minute < 9 then
    minute = '0' .. minute
  end

  return hour .. ":" .. minute
end

-- NORMAL TIME 60000
local min = 10000

Citizen.CreateThread(function()
  while true do
    if IsInQueue then
      Citizen.Wait(math.random(QueueTimeMin * min, QueueTimeMax * min))

      if IsInQueue then
        if not AlredyContract then
          TriggerServerEvent("vnx-laptop:ServerEvent:Boosting:CreateContract", getClock())
        end
      end
    end
    Citizen.Wait(1000)
  end
end)


-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------ADITIONAL FUNCTIONS FOR BOOSTING----------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("vnx-laptop:ClientEvent:Boosting:Hackingdevice")
AddEventHandler("vnx-laptop:ClientEvent:Boosting:Hackingdevice", function()
  local Player = PlayerPedId()
  local pos = GetEntityCoords(Player)
  local entityWorld = GetOffsetFromEntityInWorldCoords(Player, 0.0, 20.0, 0.0)
  local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, Player, 0)
  local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)

  -- playerped = PlayerPedId()
  targetVehicle = GetVehiclePedIsUsing(Player)



  if targetVehicle == 0 then
    if vehicleHandle ~= nil and vehicleHandle ~= 0 and IsEntityAVehicle(vehicleHandle) then
      if (GetVehicleNumberPlateText(vehicleHandle) == placa) then
        RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')

        while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
          Citizen.Wait(0)
        end

        TaskPlayAnim(
          Player,
          'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
          'machinic_loop_mechandplayer',
          8.0,
          -8.0,
          -1,
          1,
          0,
          false,
          false,
          false
        )

        exports['str-hackdevice']:OpenDevice(function(OpenDeviceResult)
          if OpenDeviceResult then
            ClearPedTasksImmediately(Player)

            VehicleUnlock(vehicleHandle)
            TriggerEvent('DoLongHudText', 'Lockpick Success !', 1)

            if GetVehicleNumberPlateText(vehicleHandle) == placa then
              if isVin then
                exports['str-dispatch']:dispatchadd('10-99', 'Tracker Device Tampering', '227')
                -- sendAppEvent('BoostingNotification',
                --   {
                --     notify = {
                --       msg = "You need to disable gps before scratching",
                --       time = "2/4",
                --       app = 'Boosting',
                --       img = 'https://imgur.com/FEPqpLc.png'
                --     }
                --   }
                -- ) -- Criar função pra alerta de Track removido

                exports["str-phone"]:DoPhoneNotification(
                  "home-screen",
                  "Puppet Master",
                  'Disable the tracker then head to the scratch location.'
                )

                MakeDropZoneThreadVin(true)
                DeleteBlip()


                TriggerServerEvent("vnx-laptop:ServerEvent:Boosting:AddBlipsSystem")
                TriggerServerEvent('vnx-laptop:ServerEvent:Boosting:SetPlateInList',
                  GetVehicleNumberPlateText(vehicleHandle)
                )
                isPoliceBlip = true
              end
            end
          else
            ClearPedTasksImmediately(Player)
            TriggerEvent('DoLongHudText', 'Hacking Failed!', 2)
          end
        end, 1, Config.TimeOfHacksByContractType[CurrentContract.type])
      else
        print('USE REG LOCKPICK')
        TriggerEvent("inv:lockPick", false, inventoryName, slot, "lockpick")
      end
    end
  else
    print('IN VEH')
    TriggerEvent("inv:lockPick", false, inventoryName, slot, "lockpick")
  end
end)

RegisterNetEvent("vnx-laptop:ClientEvent:Boosting:AddCooldownHack")
AddEventHandler("vnx-laptop:ClientEvent:Boosting:AddCooldownHack", function()
  exports['str-dispatch']:dispatchadd('10-99', 'Tracker Device Tampering', '227')

  cooldown = true
  TriggerEvent('DoLongHudText', 'You will have to wait 15 Seconds to do another hack.', 1)
  Citizen.Wait(15000)
  cooldown = false
end)

AddEventHandler("vnx-laptop:ClientEvent:Boosting:HelpHack")
AddEventHandler("vnx-laptop:ClientEvent:Boosting:HelpHack", function()
  DoHackingStagesCOP()

  if HackingIsCompleted() then
    if isVin then
      -- sendAppEvent('BoostingNotification',
      --   {
      --     notify = {
      --       msg = "Go to the marked place and scratch the vin",
      --       time = "3/4",
      --       app = 'Boosting',
      --       img = 'https://imgur.com/FEPqpLc.png'
      --     }
      --   }
      -- )  -- Criar função para notificar o player para rapagem de chassis

      TriggerEvent('DoLongHudText', 'Go to the marked place and scratch the vin', 1)
      isPoliceBlip = false

      TriggerServerEvent("vnx-laptop:ServerEvent:Boosting:SetPlateInList",
        TrimValue(GetVehicleNumberPlateText(VehicleStoled)),
        false
      )
      TriggerServerEvent("vnx-laptop:ServerEvent:Boosting:RemoveBlipsSystem")
    else
      isPoliceBlip = false
      TriggerServerEvent('vnx-laptop:ServerEvent:Boosting:SetPlateInList',
        TrimValue(GetVehicleNumberPlateText(VehicleStoled)),
        false
      )
      TriggerServerEvent("vnx-laptop:ServerEvent:Boosting:RemoveBlipsSystem")
    end
  end
end)


-------------------------------------------------------------------------------------------------------------------------------
----------------------------------FUNCTIONS FOR START, CANCEL, AND SEND CONTRACT-----------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("vnx-laptop:NUIEvent:Boosting:StartContract", function(data, cb)
  if not AlredyContract then
    if data.IsVin then
      local requireGNE = tonumber(data.contract.units)
      local aditionalGNE = tonumber(data.contract.ExtraVin)
      local playerGNE = RPC.execute("vnx-laptop:ServerEvent:Boosting:GetPlayerGNE")

      if requireGNE + aditionalGNE <= tonumber(playerGNE.cryptoamount) then
        -- local mexico, minutes = InCoolDown()
        local CoolDown, minutes = RPC.execute("vnx-laptop:ServerEvent:Boosting:CoolDown")

        if CoolDown then
          HackingStage(NumberOfContractsByLevel(data.contract.type))

          AlredyContract = true

          TriggerServerEvent("vnx-laptop:ServerEvent:Boosting:IsInContract")
          -- TriggerServerEvent("vnx-laptop:ServerEvent:Boosting:RemoveGNE", requireGNE + aditionalGNE)
          local vehicleCoords = json.decode(data.contract.coords)

          local vehicle, plate = CreateVeh(data.contract.vehicle, vehicleCoords)

          placa = plate
          isVin = data.IsVin
          VehicleStoled = vehicle
          CurrentContract = data.contract

          exports["str-phone"]:DoPhoneNotification(
            "home-screen",
            "Puppet Master",
            'Your contract has been started Information Plate: ' .. plate,
            1
          )
          -- local vehicleCoords = json.decode(data.contract.coords)

          CreateBlip(vehicleCoords)

          exports["str-phone"]:DoPhoneNotification(
            "home-screen",
            "Puppet Master",
            'You need to find the car and lockpick it in zone marked in map'
          )

          cb({ Contract = true })
        else
          exports["str-phone"]:DoPhoneNotification(
            "home-screen",
            "Puppet Master",
            "You can't start this contract wait " .. minutes .. " minutes"
          )

          cb({ Contract = false })
        end
      else
        exports["str-phone"]:DoPhoneNotification(
          "home-screen",
          "Puppet Master",
          "You cant start this contract, you have " ..
          tostring(requireGNE + aditionalGNE) .. " GNE, and you need " .. playerGNE.cryptoamount .. " GNE."
        )
        cb({ Contract = false })
      end
    else
      cb({ Contract = false })
    end

    cb({ Contract = false })
    return
  end

  TriggerEvent('DoLongHudText', 'There is a contract in progress', 1)

  cb({})
end)
