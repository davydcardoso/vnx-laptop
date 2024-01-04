local BoostingPlate = {}

RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:SetPlateInList")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:SetPlateInList", function(plate, boolean)
  if plate ~= nil then
    if boolean then
      print("[BOOSTING] " .. plate .. "is in the list")
      BoostingPlate[plate] = boolean
    else
      if BoostingPlate[plate] ~= nil then
        print('[BOOSTING] ' .. plate .. ' is not more in the list')
        BoostingPlate[plate] = nil
      else
        print('[BOOSTING] ' .. plate .. ' is not in the list so we do nothing')
      end
    end
  end
end)

RPC.register("vnx-laptop:ServerEvent:Boosting:GetPlateState", function(source, data)
  local plate = data.plate
  if BoostingPlate[plate] ~= nil then
    return true
  else
    return false
  end
end)

-------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------BOOSTING BLIPS FUNCTIONS---------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

BoostingBlipsSystem = {
  ActivePlayers = {},
}

function BoostingBlipsSystem:BoostingThread()
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5000)
      local ped = nil

      for k, v in pairs(self.ActivePlayers) do
        ped = GetPlayerPed(k)
        local veh = GetVehiclePedIsIn(ped)
        self.ActivePlayers[k].corrds = GetEntityCoords(veh)
      end

      TriggerClientEvent("vnx-laptop:ClientEvent:Boosting:UpdateBlips", -1, self.ActivePlayers)
    end
  end)
end

function BoostingBlipsSystem:AddSrc(src)
  self.ActivePlayers[src] = {}
end

function BoostingBlipsSystem:RemoveSrc(src)
  self.ActivePlayers[src] = nil

  TriggerClientEvent("vnx-laptop:ClientEvent:Boosting:RemoveBlip", -1, src)
end

BoostingBlipsSystem:BoostingThread()

RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:AddBlipsSystem")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:AddBlipsSystem", function()
  BoostingBlipsSystem:AddSrc(source)
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:RemoveBlipsSystem")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:RemoveBlipsSystem", function()
  BoostingBlipsSystem:RemoveSrc(source)
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:Coop")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:Coop", function(src)
  local player = source

  if src ~= nil then
    TriggerClientEvent("vnx-laptop:ClientEvent:Boosting:HelpHack")
    TriggerEvent("vnx-laptop:ServerEvent:Boosting:AddBoostingLevelHelp")
  end
end)


RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:AddBoostingLevelHelp")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:AddBoostingLevelHelp", function()
  local src = source
  local user = exports['str-base']:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  local boostingUser = GetBoostingUserData(stateId)
  local levelTo = boostingUser.level + Config.XpGainHackerman

  SetLevelBoosting(stateId, levelTo)
  -- TriggerClientEvent("boosting:setlevel", src, levelTo, gnes.gne) -- Server para atualizar o nivel do boosting no front end (não utilizar AINDA)
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:RemoveGNE")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:RemoveGNE", function(toRemove)
  local src = source
  local user = exports['str-base']:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  local playerGNE = GetPlayerGNE(stateId)
  local newGNEValue = tonumber(playerGNE.cryptoamount) - tonumber(toRemove)

  RemovePlayerGNE(stateId, newGNEValue)
  -- TriggerClientEvent("boosting:setlevel", src, gnes.level, newgnes)
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:CompleteVinContract")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:CompleteVinContract", function(id, plate)
  local src = source
  local user = exports['str-base']:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  local boosting = GetContractByID(id)
  local playerBoostingData = GetBoostingUserData(stateId)

  Citizen.Wait(1000)

  AddVehicleToGarage(stateId, boosting.vehicle, plate)
  SetLevelBoosting(stateId, playerBoostingData.level + Config.XpGain)
  -- TriggerClientEvent("boosting:setlevel", src, gnes.level, newgnes)
  RemoveContractByID(id)
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:PayGNE")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:PayGNE", function()
  local src = source
  local user = exports["str-base"]:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  local playerBoostingData = GetBoostingUserData(stateId)

  SetLevelBoosting(stateId, playerBoostingData.level + Config.XpGain)

  exports.oxmysql:execute('SELECT level FROM boosting_users WHERE identifier = ?', { cid }, function(result)
    if tonumber(result[1].level) >= 0 and tonumber(result[1].level) <= 100 then
      AddPlayerGNE(stateId, 10)
    elseif tonumber(result[1].level) >= 100 and tonumber(result[1].level) <= 200 then
      AddPlayerGNE(stateId, 25)
    elseif tonumber(result[1].level) >= 200 and tonumber(result[1].level) <= 300 then
      AddPlayerGNE(stateId, 170)
    elseif tonumber(result[1].level) >= 300 and tonumber(result[1].level) <= 400 then
      AddPlayerGNE(stateId, 300)
    elseif tonumber(result[1].level) >= 400 and tonumber(result[1].level) <= 500 then
      AddPlayerGNE(stateId, 500)
    end
  end)
end)

--BLIPS SYSTEM INFINITY
local isInContract = false

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------ADITIONAL FUNCTIONS FOR BOOSTING----------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vnx-laptop:Boosting:ServerEvent:CheckAllBoostingInformation")
AddEventHandler("vnx-laptop:Boosting:ServerEvent:CheckAllBoostingInformation", function(pPlayerIsPuppet)
  local src = source

  local user = exports['str-base']:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  local BoostingQueueStatus = GetBoostingStatus()

  local PlayersInQueue = exports.oxmysql:executeSync("SELECT COUNT(bq.identifier) FROM `boost_queue` bq")
  local ActiveContracts = exports.oxmysql:executeSync("SELECT COUNT(b.id) FROM `boosting` b")

  local BoostingContracts = exports.oxmysql:executeSync("SELECT * FROM `boosting` WHERE identifier = @stateId", {
    ['@stateId'] = stateId,
  })

  local Result = {
    MyContracts = BoostingContracts,
    BoostingStatus = BoostingQueueStatus,
    PlayersInQueue = #PlayersInQueue - 1,
    ActiveContracts = #ActiveContracts - 1,
    PendingContracts = 0,
  }

  print(json.encode(Result))

  TriggerClientEvent("vnx-laptop:ClientEvent:Boosting:CheckAllInformation", src, Result)

  if BoostingQueueStatus == "DISABLED" then
    return
  end

  InitBoostingUser(stateId)
  ConsultMyBoostingContracts(src, stateId)
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:EnabledOrDisabled")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:EnabledOrDisabled", function()
  local src = source
  local user = exports['str-base']:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  print("vnx-laptop:ServerEvent:Boosting:EnabledOrDisabled")

  local resultQuery = exports.oxmysql:executeSync("SELECT * FROM `boosting_queue`")

  if #resultQuery > 0 then
    if resultQuery[1].QueueStatus == "DISABLED" then
      exports.oxmysql:executeSync(
        "UPDATE `boosting_queue` SET QueueStatus = @queueStatus WHERE QueueStatus = @oldQueueStatus", {
          ["@queueStatus"] = "ENABLED",
          ["@oldQueueStatus"] = "DISABLED"
        }
      )

      TriggerClientEvent("vnx-laptop:ClientEvent:Boosting:EnabledOrDisabled", src, "ENABLED")
      return;
    end
    exports.oxmysql:executeSync(
      "UPDATE `boosting_queue` SET QueueStatus = @queueStatus WHERE QueueStatus = @oldQueueStatus", {
        ["@queueStatus"] = "DISABLED",
        ["@oldQueueStatus"] = "ENABLED"
      }
    )

    DeleteAllBoostingContracts()

    TriggerClientEvent("vnx-laptop:ClientEvent:Boosting:EnabledOrDisabled", src, "DISABLED")
    return;
  end
  exports.oxmysql:executeSync(
    "INSERT INTO `boosting_queue` (QueueStatus, PuppetStateId) VALUES (@queueStatus, @stateId)", {
      ["@queueStatus"] = "DISABLED",
      ["@stateId"] = stateId
    }
  )

  DeleteAllBoostingContracts()

  TriggerClientEvent("vnx-laptop:ClientEvent:Boosting:EnabledOrDisabled", src, "DISABLED")
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:JoinInQueue")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:JoinInQueue", function()
  local src = source

  local user = exports['str-base']:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  local existsUserInQueue = exports.oxmysql:executeSync("SELECT * FROM `boost_queue` WHERE identifier = @stateId", {
    ["@stateId"] = stateId
  })

  if #existsUserInQueue > 0 then
    if existsUserInQueue[1].pSrc == src then
      return
    end

    exports.oxmysql:executeSync("UPDATE `boost_queue` SET pSrc = @playerSource WHERE identifier = @stateId", {
      ["@playerSource"] = src,
      ["@stateId"] = stateId
    })
    return
  end

  exports.oxmysql:executeSync("INSERT INTO `boost_queue` (identifier, pSrc) VALUES (@stateId, @playerSource)", {
    ["@stateId"] = stateId,
    ["@playerSource"] = src
  })
end)

RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:ExitQueue")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:ExitQueue", function()
  local src = source

  local user = exports['str-base']:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  exports.oxmysql:executeSync("DELETE FROM `boost_queue` WHERE identifier = @stateId", {
    ["@stateId"] = stateId,
  })
end)

RegisterNetEvent("vnx-laptop:Boosting:BlockOrUnBlockPlayerFromBoostingServerEvent", function(stateId)
  local src = source

  if stateId == nil then
    TriggerClientEvent(
      "DoLongHudText",
      src,
      "State ID not informed!!!",
      2
    );
  end

  local resultQuery = exports.oxmysql:executeSync("SELECT * FROM `boosting_users` WHERE identifier = @stateId", {
    ["@stateId"] = stateId
  })

  if resultQuery[1] == nil then
    exports.oxmysql:executeSync(
      'INSERT INTO `boosting_users` (`identifier`, `level`, `gne`, `blocked`) VALUES (@identifier, @level, @gne, @blockedStatus)',
      {
        ['@identifier'] = stateId,
        ['@level'] = 0,
        ['@gne'] = 0,
        ['@cooldown'] = 0,
        ["@blockedStatus"] = "S"
      }
    )

    TriggerClientEvent(
      "DoLongHudText",
      src,
      "Player has been blocked successful",
      0
    );
    return
  end

  if resultQuery[1].blocked == "S" then
    exports.oxmysql:executeSync(
      "UDPATE FROM `boosting_users` SET blocked = @blockedStatus WHERE identifier = @identifier", {
        ["@blockedStatus"] = "N",
        ["@identifier"]    = stateId
      }
    )

    TriggerClientEvent(
      "DoLongHudText",
      src,
      "Player has been unlocked successful",
      0
    );
    return
  end

  exports.oxmysql:executeSync(
    "UDPATE FROM `boosting_users` SET blocked = @blockedStatus WHERE identifier = @identifier", {
      ["@blockedStatus"] = "S",
      ["@identifier"]    = stateId
    }
  )

  TriggerClientEvent(
    "DoLongHudText",
    src,
    "Player has been blocked successful",
    0
  );
end)

RegisterNetEvent("vnx-laptop:Boosting:UpdateBoostingInfo")
AddEventHandler("vnx-laptop:Boosting:UpdateBoostingInfo", function()
  local src = source
  local user = exports['str-base']:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  local resultQuery = exports.oxmysql:executeSync("SELECT * FROM `boosting` WHERE identifier = @stateId", {
    ["@stateId"] = tostring(stateId)
  })

  if #resultQuery > 0 then
    for index = 1, #resultQuery, 1 do
      local newExpiresTime = tonumber(resultQuery[index].expires) - 60

      if newExpiresTime <= 0 then
        exports.oxmysql:executeSync("DELETE FROM `boosting` WHERE identifier = @stateId AND type = @levelBoosting", {
          ["@stateId"] = tostring(stateId),
          ["@levelBoosting"] = resultQuery[index].type,
        })

        return
      end

      exports.oxmysql:executeSync(
        "UPDATE `boosting` SET expires = @expires WHERE identifier = @stateId AND type = @levelBoosting", {
          ["@expires"] = tostring(newExpiresTime),
          ["@stateId"] = tostring(stateId),
          ["@levelBoosting"] = resultQuery[index].type,
        }
      )
    end

    return
  end
end)



RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:CreateContract")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:CreateContract", function(clockTime)
  local src = source

  local user = exports['str-base']:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  local BoostingQueueState = GetBoostingStatus()

  if BoostingQueueState == "DISABLED" then
    return
  end

  InitBoostingUser(stateId)

  local userInBoostingQueue = exports.oxmysql:executeSync("SELECT * FROM `boost_queue` WHERE identifier = @stateId", {
    ["@stateId"] = stateId
  })

  if #userInBoostingQueue <= 0 then
    return;
  end

  local contracts = FilterContract(GetBoostingUserData(stateId).level) -- Gera contrato com base no level de boosting_users

  local ContractsCoords = Config.BoostinSpawnLocations[math.random(1, Config.NumberBoostingLocations)]

  local SendContractInformation = {
    identifier = stateId,
    vehicle = contracts.vehicle,
    type = contracts.type,
    owner = contracts.owner,
    expires = contracts.expires,
    units = contracts.units,
    ExtraVin = contracts.ExtraVin,
    coords = ContractsCoords.coords,
  }

  local alreadyExistsBoostingWithThisLevel = exports.oxmysql:executeSync(
    "SELECT * FROM boosting WHERE identifier = @stateId AND type = @boostingLevel", {
      ["@stateId"] = stateId,
      ["@boostingLevel"] = contracts.type
    })

  if (alreadyExistsBoostingWithThisLevel[1] ~= nil) then
    return;
  end

  if contracts.type == "S" or contracts.type == "S+" then
    local alreadyExistBoostingLevelSOrSPlus = exports.oxmysql:executeSync(
      "SELECT * FROM `boosting` WHERE type = @boostinLevel OR type = @boostingLevelTwo", {
        ["@boostinLevel"] = "S",
        ["@boostingLevelTwo"] = "S+"
      }
    )

    if #alreadyExistBoostingLevelSOrSPlus > 0 then
      return
    end
  end

  AddContractToDatabase(SendContractInformation)
  ConsultMyBoostingContracts(stateId)

  local resultQueryEmail = exports.oxmysql:executeSync(
    "INSERT INTO character_emails (`cid`, `from`, `subject`, `message`, `time`) VALUES (@cid, @from, @subject, @message, @time)",
    {
      ["cid"] = stateId,
      ["from"] = "Puppet Master",
      ["subject"] = "Boosting",
      ["message"] = 'You recieved a ' .. contracts.type .. ' Class Boosting Contract. Vehicle: ' .. contracts.vehicle,
      ["time"] = 1
    })

  if resultQueryEmail then
    TriggerClientEvent("emailNotify", src,
      'You recieved a ' .. contracts.type .. ' Class Boosting Contract. Vehicle: ' .. contracts.vehicle)
  end
end)

function ConsultMyBoostingContracts(pSource, pStateId)
  local resultQueryBoosting = exports.oxmysql:executeSync("SELECT * FROM `boosting` WHERE identifier = @stateId", {
    ['@stateId'] = pStateId,
  })

  if #resultQueryBoosting > 0 then
    TriggerClientEvent("vnx-laptop:ClientEvent:Boosting:AddContractToList", pSource, resultQueryBoosting)
  end
end

function AddContractToDatabase(contract)
  exports.oxmysql:executeSync(
    'INSERT INTO `boosting` (`identifier`, `vehicle`, `type`, `owner`, `expires`, `units`, `ExtraVin`, `coords`) VALUES (@identifier, @vehicle, @type, @owner, @expires, @units, @ExtraVin, @coords)',
    {
      ['@identifier'] = contract.identifier,
      ['@vehicle'] = contract.vehicle,
      ['@type'] = contract.type,
      ['@owner'] = contract.owner,
      ['@expires'] = contract.expires,
      ['@ExtraVin'] = contract.ExtraVin,
      ['@units'] = contract.units,
      ['@coords'] = json.encode({ x = contract.coords[1], y = contract.coords[2], z = contract.coords[3] }),
    }
  )
end

function GetBoostingStatus()
  local resultQuery = exports.oxmysql:executeSync("SELECT * FROM `boosting_queue`")

  if #resultQuery > 0 then
    return resultQuery[1].QueueStatus
  end

  return "DISABLED"
end

function InitBoostingUser(stateId)
  local query = exports.oxmysql:executeSync('SELECT * FROM `boosting_users` WHERE `identifier` = @identifier', {
    ["@identifier"] = stateId
  })

  if #query <= 0 then
    exports.oxmysql:executeSync(
      'INSERT INTO `boosting_users` (`identifier`, `level`, `gne`, `blocked`) VALUES (@identifier, @level, @gne, @blocked)',
      {
        ['@identifier'] = stateId,
        ['@level'] = 0,
        ['@gne'] = 0,
        ['@cooldown'] = 0,
        ["@blocked"] = "N"
      }
    )
  end
end

function DeleteAllBoostingContracts()
  exports.oxmysql:executeSync("DELETE FROM `boosting`")
end

function FilterContract(number)
  local boomer = tonumber(number)
  randomChance = math.random(1, 100)
  if boomer >= 0 and boomer <= 100 then
    return Config.BoostingContracts["D"][math.random(1, Config.NumberOfContracts.D)]
  elseif boomer >= 100 and boomer <= 200 then
    if randomChance >= 1 and randomChance <= 74 then
      return Config.BoostingContracts["C"][math.random(1, Config.NumberOfContracts.C)]
    elseif randomChance >= 75 and randomChance <= 100 then
      return Config.BoostingContracts["D"][math.random(1, Config.NumberOfContracts.D)]
    end
  elseif boomer >= 200 and boomer <= 300 then
    if randomChance >= 1 and randomChance <= 33 then
      return Config.BoostingContracts["B"][math.random(1, Config.NumberOfContracts.B)]
    elseif randomChance >= 34 and randomChance <= 66 then
      return Config.BoostingContracts["C"][math.random(1, Config.NumberOfContracts.C)]
    elseif randomChance >= 67 and randomChance <= 100 then
      return Config.BoostingContracts["D"][math.random(1, Config.NumberOfContracts.D)]
    end
  elseif boomer >= 200 and boomer <= 400 then
    if randomChance >= 1 and randomChance <= 25 then
      return Config.BoostingContracts["A"][math.random(1, Config.NumberOfContracts.A)]
    elseif randomChance >= 26 and randomChance <= 65 then
      return Config.BoostingContracts["B"][math.random(1, Config.NumberOfContracts.B)]
    elseif randomChance >= 66 and randomChance <= 100 then
      return Config.BoostingContracts["C"][math.random(1, Config.NumberOfContracts.C)]
    end
  elseif boomer >= 200 and boomer <= 500 then
    if randomChance >= 1 and randomChance <= 15 then
      return Config.BoostingContracts["S"][math.random(1, Config.NumberOfContracts.S)]
    elseif randomChance >= 16 and randomChance <= 35 then
      return Config.BoostingContracts["A"][math.random(1, Config.NumberOfContracts.A)]
    elseif randomChance >= 36 and randomChance <= 69 then
      return Config.BoostingContracts["B"][math.random(1, Config.NumberOfContracts.B)]
    elseif randomChance >= 70 and randomChance <= 100 then
      return Config.BoostingContracts["C"][math.random(1, Config.NumberOfContracts.C)]
    end
  else
    if randomChance >= 1 and randomChance <= 10 then
      return Config.BoostingContracts["S+"][math.random(1, Config.NumberOfContracts.SPLUS)]
    elseif randomChance >= 11 and randomChance <= 25 then
      return Config.BoostingContracts["S"][math.random(1, Config.NumberOfContracts.S)]
    elseif randomChance >= 26 and randomChance <= 69 then
      return Config.BoostingContracts["A"][math.random(1, Config.NumberOfContracts.A)]
    elseif randomChance >= 70 and randomChance <= 100 then
      return Config.BoostingContracts["B"][math.random(1, Config.NumberOfContracts.B)]
    end
  end
end

-------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------OTHERS FUNCTIONS------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("vnx-laptop:ServerEvent:Boosting:IsInContract")
AddEventHandler("vnx-laptop:ServerEvent:Boosting:IsInContract", function(Bool)
  isInContract = Bool
end)


-------------------------------------------------------------------------------------------------------------------------------
--------------------------------------FUNCTIONS FOR UPDATE BOOSTINGS DATABASES-------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

function GetBoostingUserData(stateId)
  local query = exports.oxmysql:executeSync('SELECT * FROM `boosting_users` WHERE `identifier` = @identifier', {
    ["@identifier"] = stateId
  })

  return query[1]
end

function SetLevelBoosting(identifier, newValue)
  local query = exports.oxmysql:executeSync('UPDATE `boosting_users` SET level = @level WHERE identifier = @identifier',
    {
      ['@identifier'] = identifier,
      ['level'] = newvalue
    })
end

RPC.register("vnx-laptop:ServerEvent:Boosting:CoolDown", function(pSource)
  local src = source
  local user = exports['str-base']:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  local boostingTime = Await(SQL.execute('SELECT * FROM `boosting_users` WHERE `identifier` = @identifier',
    { ['@identifier'] = stateId }
  ))

  local result = boostingTime[1].cooldown

  if (os.time() - result) < Config.VinCoolDown * 60 and result ~= 0 then
    local seconds = Config.VinCoolDown * 60 - (os.time() - result)

    return { CoolDown = false, minutes = math.floor(seconds / 60) }
  else
    Await(SQL.execute('UPDATE boosting_users SET cooldown = @cooldown WHERE identifier = @identifier', {
      ['@identifier'] = stateId,
      ['@cooldown'] = os.time()
    }))

    return { CoolDown = true, minutes = 0 }
  end
end)

RPC.register("vnx-laptop:ServerEvent:Boosting:GetPlayerGNE", function(pSource)
  local src = source
  local user = exports['str-base']:getModule("Player"):GetUser(src)
  local stateId = user:getCurrentCharacter().id

  local resultQuery = Await(SQL.execute(
    "SELECT * FROM `user_crypto`  WHERE cryptocid = @stateId AND cryptoid = 2", {
      ["@stateId"] = stateId
    }
  ))

  return resultQuery[1]
end)

function GetPlayerGNE(stateId)
  local resultQuery = exports.oxmysql:executeSync(
    "SELECT * FROM `user_crypto` uc WHERE cryptocid = @stateId AND cryptoid = 2", {
      ["@stateId"] = stateId
    }
  )

  return resultQuery[1]
end

function AddPlayerGNE(pStateId, pGNEValue)
  exports.oxmysql:executeSync(
    "UPDATE `user_crypto` SET cryptoamount = @GNEValue WHERE cryptocid = @stateId AND cryptoid = 2", {
      ["@GNEValue"] = pGNEValue,
      ["@stateId"] = pStateId
    }
  )
end

function RemovePlayerGNE(pStateId, pGNEValue)
  exports.oxmysql:executeSync(
    "UPDATE `user_crypto` SET cryptoamount = @GNEValue WHERE cryptocid = @stateId AND cryptoid = 2", {
      ["@GNEValue"] = pGNEValue,
      ["@stateId"] = pStateId
    }
  )
end

function GetContractByID(id)
  local resultQuery = exports.oxmysql:executeSync("SELECT * FRFOM `boosting` WHERE `id` = @id", {
    ['@id'] = id
  })

  return resultQuery[1]
end

function RemoveContractByID(id)
  exports.oxmysql:executeSync("DELETE FROM `boosting` WHERE WHERE `id` = @id", {
    ['@id'] = id
  })
end

function AddVehicleToGarage(stateId, vehicle, plate)
  exports.oxmysql:execute(
    'INSERT INTO characters_cars (cid, model, vehicle_state, name, current_garage, vin, license_plate) VALUES (?, ?, ?, ?, ?, ?, ?)',
    {
      stateId,
      vehicle,
      'Out',
      vehicle,
      'C',
      '1',
      plate,
    }
  )
end
