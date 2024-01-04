-- signedin = false
-- signedinjob = nil
-- --jobNotifcationId = 0

-- -- jobs
-- local nearFish = false
-- local nearFishingStand = false
-- local inDeliveryTruck = false
-- local inGarbageTruck = false
-- local inWaterPowerTruck = false
-- local inPostOpTruck = false
-- local isNearStore = false
-- local isNearTruckerForeman = false
-- local isNearGarbageForeman = false
-- local isNearPostOpForeman = false
-- local isNearWaterAndPowerForeman = false

-- --[[ RegisterNUICallback("setJobNotifcationId", function(data, cb)
--     jobNotifcationId = data.id
-- end) ]]

-- RegisterNetEvent("vnx-laptop:ClientEvent:SignIntoJob")
-- AddEventHandler("vnx-laptop:ClientEvent:SignIntoJob", function(job)
--   if signedin then
--     exports['str-phone']:SendAlert('error', 'You already signed in', 3000)
--     return
--   end
--   signedin = true
--   signedinjob = job

--   local jobname = RPC.execute("vnx-laptop:ServerEvent:GetSignInName", job)
--   local string = "Checked in as a " .. jobname

--   TriggerEvent("str-phone:SendNotify", string, "jobcenter", "Job Center")
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:GetPaycheck")
-- AddEventHandler("vnx-laptop:ClientEvent:GetPaycheck", function(job)
--   if not signedin then
--     exports['str-phone']:SendAlert('error', 'You are not signed in', 3000)
--     return
--   end
--   if signedinjob == nil then
--     exports['str-phone']:SendAlert('error', 'You are not signed in', 3000)
--     return
--   end
--   if tostring(signedinjob) ~= tostring(job) then
--     exports['str-phone']:SendAlert('error', 'You are not signed into this job', 3000)
--     return
--   end
--   RPC.execute("vnx-laptop:ServerEvent:CollectPaycheck", signedinjob)
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:OfferJob")
-- AddEventHandler("vnx-laptop:ClientEvent:OfferJob", function(groupId, job, text)
--   Wait(math.random(30000, 60000))

--   if not signedin then return end
--   if signedinjob == nil then return end

--   local group, ingroup, src, name = RPC.execute("getGroupingData", signedinjob)

--   if not ingroup then return end

--   if group.inActivity then return end

--   -- add a fucking check if they still got the job
--   local result = DoPhoneConfirmation(nil, "Job Offer", text, "people-carry", "#90c9f9")
--   if result then
--     RPC.execute("vnx-laptop:ServerEvent:StartActivity", job, groupId)
--   else
--   end
-- end)

-- RegisterNUICallback('vnx-laptop:ClientEvent:GasOfferAccepted', function()
--   TriggerEvent('str-fuel:OfferAccepted')
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:ShowJoinRequest")
-- AddEventHandler("vnx-laptop:ClientEvent:ShowJoinRequest", function(requester, job, groupId, name)
--   local result = DoPhoneConfirmation(nil, "Request To Join", name, "people-carry", "#90c9f9")
--   if result == true then
--     RPC.execute("vnx-laptop:ServerEvent:JoinGroup", job, groupId, requester)
--   else
--     RPC.execute("vnx-laptop:ServerEvent:ResetCooldown", requester)
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:OfferCompleted")
-- AddEventHandler("vnx-laptop:ClientEvent:OfferCompleted", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       --Wait(400)
--       TriggerEvent("str-phone:SendNotify", "The offer was completed successfully.", "jobcenter", "Job Offer")
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:GiveMaterial")
-- AddEventHandler("vnx-laptop:ClientEvent:GiveMaterial", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       TriggerEvent('player:receiveItem', 'recyclablematerial', math.random(75, 150)) -- 75 Mats = $600 | 150 Mats = $1200
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:OfferNotCompleted")
-- AddEventHandler("vnx-laptop:ClientEvent:OfferNotCompleted", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       Wait(400)
--       TriggerEvent("str-phone:SendNotify", "The offer was not completed.", "jobcenter", "Job Offer")
--     end
--   end
-- end)

-- RegisterNetEvent("str-phone:JobNotify")
-- AddEventHandler("str-phone:JobNotify", function(title, text, bool, groupId)
--   local serverid = GetPlayerServerId(PlayerId())
--   SendReactMessage('setNotify', {
--     app = "phone",
--     data = {
--       action = "job-notification",
--       title = title,
--       text = text,
--       icon = { name = "people-carry", color = "white" },
--       bgColor = "#90c9f9",
--       cancelButton = bool,
--       jobGroupId = groupId
--     },
--     serverid = serverid
--   })
-- end)

-- RegisterNetEvent("str-phone:ClearJobNotify")
-- AddEventHandler("str-phone:ClearJobNotify", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       SendReactMessage('closeNotify', {
--         id = groupId, -- or use groupId to identify noti instead? 5head
--       })
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:UpdateJobActivity")
-- AddEventHandler("vnx-laptop:ClientEvent:UpdateJobActivity", function(groupId, members, tasks)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       SendReactMessage('updateNotify', {
--         id = groupId, -- just use the groupId to update instead fuck face KEKW
--         title = tasks.header,
--         body = tasks.task
--       })
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:TalkToTruckerForeMan")
-- AddEventHandler("vnx-laptop:ClientEvent:TalkToTruckerForeMan", function(groupId, groupData, members, task)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       if tonumber(v.src) ~= tonumber(groupData.leader) then
--         TriggerEvent("str-phone:JobNotify", task.header, task.task, false, groupId)
--       else
--         TriggerEvent("str-phone:JobNotify", task.header, task.task, true, groupId)
--       end
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:TalkToWaterAndPowerForeMan")
-- AddEventHandler("vnx-laptop:ClientEvent:TalkToWaterAndPowerForeMan", function(groupId, groupData, members, task)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       if tonumber(v.src) ~= tonumber(groupData.leader) then
--         TriggerEvent("str-phone:JobNotify", task.header, task.task, false, groupId)
--       else
--         TriggerEvent("str-phone:JobNotify", task.header, task.task, true, groupId)
--       end
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:TalkToPostOpForeMan")
-- AddEventHandler("vnx-laptop:ClientEvent:TalkToPostOpForeMan", function(groupId, groupData, members, task)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       if tonumber(v.src) ~= tonumber(groupData.leader) then
--         TriggerEvent("str-phone:JobNotify", task.header, task.task, false, groupId)
--       else
--         TriggerEvent("str-phone:JobNotify", task.header, task.task, true, groupId)
--       end
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:TruckerIsInCar")
-- AddEventHandler("vnx-laptop:ClientEvent:TruckerIsInCar", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       inDeliveryTruck = true
--       isInDeliveryTruck()
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:WaterAndPowerIsInCar")
-- AddEventHandler("vnx-laptop:ClientEvent:WaterAndPowerIsInCar", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       inWaterPowerTruck = true
--       isInWaterPowerTruck()
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:PostOpIsInCar")
-- AddEventHandler("vnx-laptop:ClientEvent:PostOpIsInCar", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       inPostOpTruck = true
--       isInPostOpTruck()
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:PostOpIsInCar")
-- AddEventHandler("vnx-laptop:ClientEvent:PostOpIsInCar", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       inPostOpTruck = true
--       isInPostOpTruck()
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:PostOpAddGPS")
-- AddEventHandler("vnx-laptop:ClientEvent:PostOpAddGPS", function(groupId, members, x, y, z)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       TriggerEvent('postOpIsAtLocation')
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:TruckerAddGPS")
-- AddEventHandler("vnx-laptop:ClientEvent:TruckerAddGPS", function(groupId, members, x, y, z)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       StartGpsMultiRoute(9, true, false)
--       AddPointToGpsMultiRoute(x, y, z)
--       SetGpsMultiRouteRender(true)
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:TruckerClearGPS")
-- AddEventHandler("vnx-laptop:ClientEvent:TruckerClearGPS", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       SetWaypointOff()
--       ClearGpsMultiRoute()
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:TruckerIsAtStore")
-- AddEventHandler("vnx-laptop:ClientEvent:TruckerIsAtStore", function(groupId, members, x, y, z)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       isNearStore = true
--       nearStore(x, y, z)
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:TruckerIsAtForeman")
-- AddEventHandler("vnx-laptop:ClientEvent:TruckerIsAtForeman", function(groupId, members, x, y, z)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       isNearTruckerForeman = true
--       nearTruckerForeman(x, y, z)
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:TruckerDelCar")
-- AddEventHandler("vnx-laptop:ClientEvent:TruckerDelCar", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       local playerPed = PlayerPedId()
--       local veh = GetVehiclePedIsIn(playerPed)
--       DeleteEntity(veh)
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:TindFishingSpot")
-- AddEventHandler("vnx-laptop:ClientEvent:TindFishingSpot", function(groupId, groupData, members, task)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       TriggerEvent("str-fishing:jobEvent", true)
--       nearFish = true
--       nearFishing()
--       if tonumber(v.src) ~= tonumber(groupData.leader) then
--         TriggerEvent("str-phone:JobNotify", task.header, task.task, false, groupId)
--       else
--         TriggerEvent("str-phone:JobNotify", task.header, task.task, true, groupId)
--       end
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:LetThemKnowSpotIsGood")
-- AddEventHandler("vnx-laptop:ClientEvent:LetThemKnowSpotIsGood", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       TriggerEvent("str-fishing:jobEvent", nil)
--       nearFishingStand = true
--       nearFishStand()
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:TalkToGarbageForeMan")
-- AddEventHandler("vnx-laptop:ClientEvent:TalkToGarbageForeMan", function(groupId, groupData, members, task)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       if tonumber(v.src) ~= tonumber(groupData.leader) then
--         TriggerEvent("str-phone:JobNotify", task.header, task.task, false, groupId)
--       else
--         TriggerEvent("str-phone:JobNotify", task.header, task.task, true, groupId)
--       end
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:GarbageIsInCar")
-- AddEventHandler("vnx-laptop:ClientEvent:GarbageIsInCar", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       inGarbageTruck = true
--       isInGarbageTruck()
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:GarbageDelCar")
-- AddEventHandler("vnx-laptop:ClientEvent:GarbageDelCar", function(groupId, members)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       local playerPed = PlayerPedId()
--       local veh = GetVehiclePedIsIn(playerPed, false)
--       DeleteEntity(veh)
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:GarbageIsAtForeman") -- add post op and water & power
-- AddEventHandler("vnx-laptop:ClientEvent:GarbageIsAtForeman", function(groupId, members, x, y, z)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       isNearGarbageForeman = true
--       nearGarbageForeman(x, y, z)
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:PostOpIsAtForeman") -- add post op and water & power
-- AddEventHandler("vnx-laptop:ClientEvent:PostOpIsAtForeman", function(groupId, members, x, y, z)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       isNearPostOpForeman = true
--       nearPostOpForeman(x, y, z)
--     end
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:WaterAndPowerIsAtForeman") -- add post op and water & power
-- AddEventHandler("vnx-laptop:ClientEvent:WaterAndPowerIsAtForeman", function(groupId, members, x, y, z)
--   local clientId = PlayerId()
--   local src = GetPlayerServerId(clientId)
--   for k, v in pairs(members) do
--     if tonumber(v.src) == tonumber(src) then
--       isNearWaterAndPowerForeman = true
--       nearWaterAndPowerForeman(x, y, z)
--     end
--   end
-- end)

-- AddEventHandler("str-jobs:247delivery:dropGoods", function()
--   RPC.execute("vnx-laptop:ServerEvent:CompleteTask", "trucker", 4)
-- end)

-- RegisterNUICallback("vnx-laptop:ClientEvent:SetJobsGps", function(data, cb)
--   local x, y = RPC.execute("vnx-laptop:ServerEvent:GetJobCoords", data.id)
--   local x = tonumber(x)
--   local y = tonumber(y)

--   SetNewWaypoint(x, y)

--   exports['str-phone']:SendAlert('inform', 'Updated GPS', 3000)
-- end)

-- RegisterNUICallback("vnx-laptop:ClientEvent:GetJobsData", function(_, cb)
--   if not signedin then
--     local vpnCheck = exports['str-inventory']:hasEnoughOfItem('vpnxj', 1)
--     local simezCheck = {}

--     if vpnCheck then
--       simezCheck = false
--       TriggerServerEvent("vnx-laptop:Vpn:state", simezCheck)
--     else
--       simezCheck = true
--       TriggerServerEvent("vnx-laptop:Vpn:state", simezCheck)
--     end
--     local data = RPC.execute("vnx-laptop:ServerEvent:GetJobsData")
--     cb({ jobs = data, signedin = false })
--   else
--     local idle, busy, ingroup, groupdata, src, jobname = RPC.execute("vnx-laptop:ServerEvent:GetGroupData", signedinjob)
--     cb({
--       jobs = {},
--       groups = { idle = idle, busy = busy },
--       signedin = true,
--       ingroup = ingroup,
--       groupdata = groupdata,
--       src =
--           src,
--       jobname = jobname
--     })
--   end
-- end)

-- RegisterNUICallback("vnx-laptop:ClientEvent:CheckOut", function(data, cb)
--   signedin = false
--   signedinjob = nil
--   cooldown = false
--   TriggerEvent("updateGroups")
-- end)

-- RegisterNUICallback("vnx-laptop:ClientEvent:CreateGroup", function(data, cb)
--   if signedin == nil then return end
--   RPC.execute("vnx-laptop:ServerEvent:CreateGroup", signedinjob)
-- end)

-- local cooldown = false

-- RegisterNUICallback("vnx-laptop:ClientEvent:JoinGroup", function(data, cb)
--   if not cooldown then
--     cooldown = true
--     RPC.execute("vnx-laptop:ServerEvent:RequestJoinGroup", signedinjob, data.id)
--   else
--     TriggerEvent("str-phone:SendNotify", "You already have an active request.", "jobcenter", "Job Center")
--   end
-- end)

-- RegisterNetEvent("vnx-laptop:ClientEvent:ResetCooldown")
-- AddEventHandler("vnx-laptop:ClientEvent:ResetCooldown", function()
--   cooldown = false
-- end)

-- RegisterNUICallback("vnx-laptop:ClientEvent:LeaveGroup", function(data, cb)
--   RPC.execute("vnx-laptop:ServerEvent:LeaveGroup", signedinjob, data.id)
-- end)

-- RegisterNUICallback("vnx-laptop:ClientEvent:DisbandGroup", function(data, cb)
--   local id = data.id
--   -- should upd
--   RPC.execute("vnx-laptop:ServerEvent:DisbandGroup", signedinjob, id)
-- end)

-- RegisterNUICallback("vnx-laptop:ClientEvent:ReadyGroup", function(data, cb)
--   local id = data.id
--   -- should upd, send back isReady state
--   RPC.execute("vnx-laptop:ServerEvent:ReadyGroup", signedinjob, id)
-- end)

-- RegisterNUICallback("vnx-laptop:ClientEvent:KickGroup", function(data, cb)
--   local id = data.id
--   local src = data.src
--   RPC.execute("vnx-laptop:ServerEvent:KickGroup", signedinjob, id, src)
-- end)

-- RegisterNUICallback("vnx-laptop:ClientEvent:CancelActivity", function(data, cb)
--   local id = data.id
--   RPC.execute("vnx-laptop:ServerEvent:CancelActivity", signedinjob, id)
-- end)

-- RegisterNetEvent('vnx-laptop:ClientEvent:UpdateGroups')
-- AddEventHandler('vnx-laptop:ClientEvent:UpdateGroups', function()
--   SendReactMessage('updateGroups', {})
-- end)

-- -- make this poly bigger
-- Citizen.CreateThread(function()
--   exports["str-polyzone"]:AddBoxZone("trucker_foreman", vector3(919.9, -1256.54, 25.53), 1.0, 1.8, {
--     heading = 30,
--     minZ = 22.13,
--     maxZ = 26.73
--   })
--   exports["str-polyzone"]:AddBoxZone("garbage_foreman", vector3(-353.94, -1545.68, 27.72), 3.0, 2.0, {
--     heading = 0,
--     minZ = 24.92,
--     maxZ = 28.92
--   })
--   exports["str-polyzone"]:AddBoxZone("waterandpower_foreman", vector3(442.99, -1969.18, 24.4), 1.4, 2.0, {
--     heading = 315,
--     minZ = 22.0,
--     maxZ = 26.0
--   })
--   exports["str-polyzone"]:AddBoxZone("postop_foreman", vector3(-417.43, -2792.96, 6.0), 3.2, 1.4, {
--     heading = 320,
--     minZ = 3.2,
--     maxZ = 7.2
--   })
-- end)

-- local listening = false
-- local function listenForKeypress(type, data, job)
--   listening = true
--   Citizen.CreateThread(function()
--     while listening do
--       if IsControlJustReleased(0, 38) then
--         listening = false
--         exports["str-ui"]:hideInteraction()
--         if job == "trucker" then
--           -- spawn car
--           --local license_plate = "247" .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9))
--           --local vehicle = RPC.execute("str:garage:vehicleSpawn", 2053223216, { x = 912.4641723632813, y = -1258.9508056640626, z = 25.57445907592773, h = 43.63048553466797 }, license_plate)

--           local model = 2053223216

--           RequestModel(model)
--           while not HasModelLoaded(model) do
--             Citizen.Wait(0)
--           end
--           SetModelAsNoLongerNeeded(model)

--           local rentalVehiclenp = CreateVehicle(model,
--             vector4(912.4641723632813, -1258.9508056640626, 25.57445907592773, 43.63048553466797), true, false)

--           Citizen.Wait(100)

--           SetEntityAsMissionEntity(rentalVehiclenp, true, true)
--           SetModelAsNoLongerNeeded(model)
--           SetVehicleOnGroundProperly(rentalVehiclenp)

--           -- TaskWarpPedIntoVehicle(PlayerPedId(), rentalVehiclenp, -1)
--           local plate = SetVehicleNumberPlateText(rentalVehiclenp, "247" .. tostring(math.random(1000, 9999)))
--           TriggerEvent("vehicle:keys:addNew", rentalVehiclenp, plate)
--           print(plate)

--           -- set talk to foreman task to completed
--           RPC.execute("completeTask", "trucker", 1)

--           --TriggerEvent("vehicle:keys:addNew", license_plate)
--           print("Give keys DONE")
--         elseif job == "recycle" then
--           -- spawn car
--           --local license_plate = "GRB" .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9))
--           --local vehicle = RPC.execute("str:garage:vehicleSpawn", -1255698084, { x = -332.53625488281, y = -1565.9274902344, z = 25.231986999512, h = 235.33598327637 }, license_plate)

--           local model = -1255698084

--           RequestModel(model)
--           while not HasModelLoaded(model) do
--             Citizen.Wait(0)
--           end
--           SetModelAsNoLongerNeeded(model)

--           local rentalVehiclenp = CreateVehicle(model,
--             vector4(-332.53625488281, -1565.9274902344, 25.231986999512, 235.33598327637), true, false)

--           Citizen.Wait(100)

--           SetEntityAsMissionEntity(rentalVehiclenp, true, true)
--           SetModelAsNoLongerNeeded(model)
--           SetVehicleOnGroundProperly(rentalVehiclenp)

--           -- TaskWarpPedIntoVehicle(PlayerPedId(), rentalVehiclenp, -1)
--           local plate = SetVehicleNumberPlateText(rentalVehiclenp, "GRB" .. tostring(math.random(1000, 9999)))
--           TriggerEvent("vehicle:keys:addNew", rentalVehiclenp, plate)
--           print(plate)

--           -- set talk to foreman task to completed
--           RPC.execute("completeTask", "recycle", 1)

--           TriggerEvent("vehicle:keys:addNew", license_plate)
--         elseif job == "waterandpower" then
--           local hash = GetHashKey("BOXVILLE")
--           --local license_plate = "PWR" .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9))
--           --local vehicle = RPC.execute("str:garage:vehicleSpawn", hash, { x = 446.18966, y = -1963.951, z = 22.943767, h = 219.07287 }, license_plate)

--           local model = GetHashKey("BOXVILLE")

--           RequestModel(model)
--           while not HasModelLoaded(model) do
--             Citizen.Wait(0)
--           end
--           SetModelAsNoLongerNeeded(model)

--           local rentalVehiclenp = CreateVehicle(model, vector4(446.18966, -1963.951, 22.943767, 219.07287), true, false)

--           Citizen.Wait(100)

--           SetEntityAsMissionEntity(rentalVehiclenp, true, true)
--           SetModelAsNoLongerNeeded(model)
--           SetVehicleOnGroundProperly(rentalVehiclenp)

--           -- TaskWarpPedIntoVehicle(PlayerPedId(), rentalVehiclenp, -1)
--           local plate = SetVehicleNumberPlateText(rentalVehiclenp, "PWR" .. tostring(math.random(1000, 9999)))
--           TriggerEvent("vehicle:keys:addNew", rentalVehiclenp, plate)
--           print(plate)

--           -- set talk to foreman task to completed
--           RPC.execute("completeTask", "waterandpower", 1)

--           TriggerEvent("vehicle:keys:addNew", license_plate)
--         elseif job == "postop" then
--           local hash = GetHashKey("BOXVILLE4")
--           -- local license_plate = "PST" .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9))
--           -- local vehicle = RPC.execute("str:garage:vehicleSpawn", hash, { x = -403.8789, y = -2787.399, z = 5.902821, h = 316.56219 }, license_plate)


--           local model = GetHashKey("BOXVILLE4")

--           RequestModel(model)
--           while not HasModelLoaded(model) do
--             Citizen.Wait(0)
--           end
--           SetModelAsNoLongerNeeded(model)

--           local rentalVehiclenp = CreateVehicle(model, vector4(-403.8789, -2787.399, 5.902821, 316.56219), true, false)

--           Citizen.Wait(100)

--           SetEntityAsMissionEntity(rentalVehiclenp, true, true)
--           SetModelAsNoLongerNeeded(model)
--           SetVehicleOnGroundProperly(rentalVehiclenp)

--           -- TaskWarpPedIntoVehicle(PlayerPedId(), rentalVehiclenp, -1)
--           local plate = SetVehicleNumberPlateText(rentalVehiclenp, "PST" .. tostring(math.random(1000, 9999)))
--           TriggerEvent("vehicle:keys:addNew", rentalVehiclenp, plate)
--           print(plate)


--           -- set talk to foreman task to completed
--           RPC.execute("completeTask", "postop", 1)

--           TriggerEvent("vehicle:keys:addNew", license_plate)
--         end
--       end
--       Wait(0)
--     end
--   end)
-- end

-- function enterPoly(name, data, job)
--   listenForKeypress(name, data, job)
--   exports["str-ui"]:showInteraction("[E] Ask the foreman for a vehicle")
-- end

-- function leavePoly(name, data, job)
--   listening = false
--   exports["str-ui"]:hideInteraction()
-- end

-- AddEventHandler("str-polyzone:enter", function(zone, data)
--   if zone == "trucker_foreman" then
--     --local signedinjob = "trucker"
--     if signedinjob == "trucker" then
--       local group, ingroup, src, name = RPC.execute("vnx-laptop:ServerEvent:GetGroupingData", signedinjob)
--       if ingroup then
--         if group.ready then
--           if group.inActivity then
--             if not group["tasks"][1]["completed"] then
--               enterPoly(zone, data, "trucker")
--             end
--           end
--         end
--       end
--     end
--   elseif zone == "garbage_foreman" then
--     --local signedinjob = "recycle"
--     if signedinjob == "recycle" then
--       local group, ingroup, src, name = RPC.execute("getGroupingData", signedinjob)
--       if ingroup then
--         if group.ready then
--           if group.inActivity then
--             if not group["tasks"][1]["completed"] then
--               enterPoly(zone, data, "recycle")
--             end
--           end
--         end
--       end
--     end
--   elseif zone == "waterandpower_foreman" then
--     --local signedinjob = "waterandpower"
--     if signedinjob == "waterandpower" then
--       local group, ingroup, src, name = RPC.execute("getGroupingData", signedinjob)
--       if ingroup then
--         if group.ready then
--           if group.inActivity then
--             if not group["tasks"][1]["completed"] then
--               enterPoly(zone, data, "waterandpower")
--             end
--           end
--         end
--       end
--     end
--   elseif zone == "postop_foreman" then
--     --local signedinjob = "postop"
--     if signedinjob == "postop" then
--       local group, ingroup, src, name = RPC.execute("getGroupingData", signedinjob)
--       if ingroup then
--         if group.ready then
--           if group.inActivity then
--             if not group["tasks"][1]["completed"] then
--               enterPoly(zone, data, "postop")
--             end
--           end
--         end
--       end
--     end
--   end
-- end)

-- AddEventHandler("str-polyzone:exit", function(zone)
--   leavePoly()
-- end)

-- -- functions
-- function isInDeliveryTruck()
--   local playerPed = PlayerPedId()
--   Citizen.CreateThread(function()
--     while inDeliveryTruck do
--       Citizen.Wait(1000)
--       if IsPedInAnyVehicle(playerPed, false) then
--         RPC.execute("completeTask", signedinjob, 2)
--         inDeliveryTruck = false
--       end
--     end
--   end)
-- end

-- function isInWaterPowerTruck()
--   local playerPed = PlayerPedId()
--   Citizen.CreateThread(function()
--     while inWaterPowerTruck do
--       Citizen.Wait(1000)
--       if IsPedInAnyVehicle(playerPed, false) then
--         RPC.execute("completeTask", signedinjob, 2)
--         inWaterPowerTruck = false
--       end
--     end
--   end)
-- end

-- function isInPostOpTruck()
--   local playerPed = PlayerPedId()
--   Citizen.CreateThread(function()
--     while inPostOpTruck do
--       Citizen.Wait(1000)
--       if IsPedInAnyVehicle(playerPed, false) then
--         RPC.execute("completeTask", signedinjob, 2)
--         inPostOpTruck = false
--       end
--     end
--   end)
-- end

-- function nearStore(x, y, z)
--   local playerPed = PlayerPedId()
--   Citizen.CreateThread(function()
--     while isNearStore do
--       Citizen.Wait(1000)
--       local playerCoords = GetEntityCoords(playerPed)
--       local location = vector3(x, y, z)
--       local dist = #(playerCoords - location)
--       if dist <= 10.0 then
--         RPC.execute("completeTask", signedinjob, 3)
--         isNearStore = false
--       end
--     end
--   end)
-- end

-- function nearTruckerForeman(x, y, z)
--   local playerPed = PlayerPedId()
--   Citizen.CreateThread(function()
--     while isNearTruckerForeman do
--       Citizen.Wait(1000)
--       local playerCoords = GetEntityCoords(playerPed)
--       local location = vector3(x, y, z)
--       local dist = #(playerCoords - location)
--       if dist <= 10.0 then
--         RPC.execute("completeTask", signedinjob, 5)
--         isNearTruckerForeman = false
--       end
--     end
--   end)
-- end

-- function nearFishing()
--   local playerPed = PlayerPedId()
--   Citizen.CreateThread(function()
--     while nearFish do
--       Citizen.Wait(1000)
--       local x, y, z = RPC.execute("fishing:jobs:getActiveLocation")
--       local playerCoords = GetEntityCoords(playerPed)
--       local location = vector3(x, y, z)
--       local dist = #(playerCoords - location)
--       if dist <= 50.0 then
--         RPC.execute("completeTask", signedinjob, 1)
--         nearFish = false
--       end
--     end
--   end)
-- end

-- function nearFishStand()
--   local playerPed = PlayerPedId()
--   Citizen.CreateThread(function()
--     while nearFishingStand do
--       Citizen.Wait(1000)
--       local playerCoords = GetEntityCoords(playerPed)
--       local location = vector3(-335.83563232422, 6106.2534179688, 31.449844360352)
--       local dist = #(playerCoords - location)
--       if dist <= 10.0 then
--         RPC.execute("completeTask", signedinjob, 3)
--         nearFishingStand = false
--       end
--     end
--   end)
-- end

-- -- this check is buggin bro (fix it)
-- function isInGarbageTruck()
--   local playerPed = PlayerPedId()
--   Citizen.CreateThread(function()
--     while inGarbageTruck do
--       Citizen.Wait(1000)
--       if IsPedInAnyVehicle(playerPed, false) then
--         RPC.execute("completeTask", signedinjob, 2)
--         inGarbageTruck = false
--       end
--     end
--   end)
-- end

-- -- garbage
-- local pickedUpTrash = {}
-- local dumpsters = {
--   218085040,
--   666561306,
--   -58485588,
--   -206690185,
--   1511880420,
--   682791951,
--   998415499,
--   1748268526,
-- }

-- local hasTrash = false
-- local trashObject = nil
-- local garbagebag = nil

-- RegisterNetEvent('str-jobs:sanitationWorker:pickupTrash')
-- AddEventHandler('str-jobs:sanitationWorker:pickupTrash', function(pArgs, pEntity, pContext)
--   if signedinjob ~= "recycle" then return end
--   local found = false
--   for k, v in pairs(dumpsters) do
--     if (tonumber(v) == tonumber(pContext.model)) then
--       found = true
--     end
--   end

--   if not found then
--     if pickedUpTrash[pEntity] then
--       exports['str-phone']:SendAlert('error', 'Empty...', 3000)
--       return
--     end
--     pickedUpTrash[pEntity] = true
--     hasTrash = true
--     trashObject = pEntity

--     if not HasAnimDictLoaded("anim@heists@narcotics@trash") then
--       RequestAnimDict("anim@heists@narcotics@trash")
--       while not HasAnimDictLoaded do
--         Wait(0)
--       end
--     end

--     ClearPedTasks(PlayerPedId())
--     garbagebag = CreateObject(GetHashKey("hei_prop_heist_binbag"), 0, 0, 0, true, true, true)
--     AttachEntityToEntity(garbagebag, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.12, 0.0, 0.00, 25.0,
--       270.0, 180.0, true, true, false, true, 1, true)
--     TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0, -1, 49, 0, false, false, false)
--   else
--     if pickedUpTrash[pEntity] and tonumber(pickedUpTrash[pEntity]) > 2 then
--       exports['str-phone']:SendAlert('error', 'Empty...', 3000)
--       return
--     end
--     if pickedUpTrash[pEntity] == nil then pickedUpTrash[pEntity] = 0 end
--     pickedUpTrash[pEntity] = pickedUpTrash[pEntity] + 1
--     hasTrash = true
--     trashObject = pEntity

--     if not HasAnimDictLoaded("anim@heists@narcotics@trash") then
--       RequestAnimDict("anim@heists@narcotics@trash")
--       while not HasAnimDictLoaded do
--         Wait(0)
--       end
--     end

--     ClearPedTasks(PlayerPedId())
--     garbagebag = CreateObject(GetHashKey("hei_prop_heist_binbag"), 0, 0, 0, true, true, true)
--     AttachEntityToEntity(garbagebag, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.12, 0.0, 0.00, 25.0,
--       270.0, 180.0, true, true, false, true, 1, true)
--     TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0, -1, 49, 0, false, false, false)
--   end
-- end)

-- RegisterNetEvent('str-jobs:sanitationWorker:vehicleTrash')
-- AddEventHandler('str-jobs:sanitationWorker:vehicleTrash', function(pArgs, pEntity, pContext)
--   if signedinjob ~= "recycle" then return end
--   if not hasTrash then return end
--   if trashObject == nil then return end
--   if garbagebag == nil then return end

--   if not HasAnimDictLoaded("anim@heists@narcotics@trash") then
--     RequestAnimDict("anim@heists@narcotics@trash")
--     while not HasAnimDictLoaded do
--       Wait(0)
--     end
--   end

--   ClearPedTasksImmediately(GetPlayerPed(-1))
--   TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0, -1, 2, 0, false, false, false)
--   Wait(800)
--   local garbagebagdelete = DeleteEntity(garbagebag)
--   Wait(100)
--   ClearPedTasksImmediately(GetPlayerPed(-1))

--   local jobCount = RPC.execute("vnx-laptop:ServerEvent:GetCurrentObjectCount", signedinjob)
--   local count = jobCount
--   local playerCoords = GetEntityCoords(trashObject, false)
--   local zone = GetLabelText(GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z))
--   print('zone')
--   print(zone)
--   count = count + 1
--   RPC.execute("vnx-laptop:ServerEvent:UpdateObjectiveData", signedinjob, 0, count, zone)
--   hasTrash = false
--   trashObject = nil
--   garbagebag = nil
-- end)

-- function nearGarbageForeman(x, y, z)
--   local playerPed = PlayerPedId()
--   Citizen.CreateThread(function()
--     while isNearGarbageForeman do
--       Citizen.Wait(1000)
--       local playerCoords = GetEntityCoords(playerPed)
--       local location = vector3(x, y, z)
--       local dist = #(playerCoords - location)
--       if dist <= 10.0 then
--         RPC.execute("completeTask", signedinjob, 5)
--         isNearGarbageForeman = false
--       end
--     end
--   end)
-- end

-- function nearPostOpForeman(x, y, z)
--   local playerPed = PlayerPedId()
--   Citizen.CreateThread(function()
--     while isNearPostOpForeman do
--       Citizen.Wait(1000)
--       local playerCoords = GetEntityCoords(playerPed)
--       local location = vector3(x, y, z)
--       local dist = #(playerCoords - location)
--       if dist <= 10.0 then
--         RPC.execute("completeTask", signedinjob, 5)
--         isNearPostOpForeman = false
--       end
--     end
--   end)
-- end

-- function nearWaterAndPowerForeman(x, y, z)
--   local playerPed = PlayerPedId()
--   Citizen.CreateThread(function()
--     while isNearWaterAndPowerForeman do
--       Citizen.Wait(1000)
--       local playerCoords = GetEntityCoords(playerPed)
--       local location = vector3(x, y, z)
--       local dist = #(playerCoords - location)
--       if dist <= 10.0 then
--         RPC.execute("completeTask", signedinjob, 5)
--         isNearWaterAndPowerForeman = false
--       end
--     end
--   end)
-- end
