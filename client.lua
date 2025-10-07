local ESX = exports['es_extended']:getSharedObject()

local VehiclePriceCache = {}
local ModelNameByHash = {}

CreateThread(function()
  Wait(500)
  ESX.TriggerServerCallback('qt_garage:loadvehicles2', function(data)
    for _, v in pairs(data or {}) do
      VehiclePriceCache[v.hash] = v.price or 0
      if v.model then
        local m = tostring(v.model):lower():gsub('[^%w]','')
        ModelNameByHash[v.hash] = m
      end
    end
  end)
end)

local function BuildModelImageName(hash)
  local fromDb = ModelNameByHash[hash]
  if fromDb and fromDb ~= '' then
    return fromDb
  end

  local key = GetDisplayNameFromVehicleModel(hash) or ''
  local label = GetLabelText(key)
  local src = (label and label ~= 'NULL') and label or key
  src = src:gsub('^VEHICLE_', '')
  src = src:gsub('[^%w]', ''):lower()
  return src
end

CreateThread(function()
  for _, v in pairs(Config.GarageCoords) do
    local model = joaat(v.npcHash or 'csb_prolsec')
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    local ped = CreatePed(4, model, v.npc.x, v.npc.y, v.npc.z - 1.0, v.npcHeading or 0.0, false, true)
    SetEntityHeading(ped, v.npcHeading or 0.0)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
  end

  for _, coords in pairs(Config.GarageCoords) do
    local blip = AddBlipForCoord(coords.npc)
    SetBlipSprite(blip, 357)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 62)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(coords.garageName or 'Garage')
    EndTextCommandSetBlipName(blip)
  end
end)

local lastGarageIndex
local impoundPresenceCache = {}

CreateThread(function()
  while true do
    local sleep = 1000
    local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)

    for idx, v in ipairs(Config.GarageCoords) do
      local dStore = #(pCoords - v.parking)
      if dStore <= 20.0 then
        sleep = 0
         DrawMarker(27, v.parking.x, v.parking.y, v.parking.z + 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 120, 10, 20, 155, false, false, false, 1, false, false, false)
      end
      if dStore <= 2.0 and IsPedInAnyVehicle(ped, false) then
        ESX.ShowHelpNotification(Config.HelpNotify)
        if IsControlJustReleased(0, 38) then
          local veh = GetVehiclePedIsIn(ped, false)
          local plate = ESX.Math.Trim(GetVehicleNumberPlateText(veh))
          ESX.TriggerServerCallback('qt_garage:vehicleOwned', function(owned)
            if owned then
              TriggerServerEvent('qt_garage:saveProps', plate, ESX.Game.GetVehicleProperties(veh))
              TaskLeaveVehicle(ped, veh, 0)
              Wait(800)
              ESX.Game.DeleteVehicle(veh)
              TriggerServerEvent('qt_garage:stored', plate, 1)
              ESX.ShowNotification("Véhicule rangé dans le garage")
            else
              ESX.ShowNotification(Config.Notifications.notowner.message)
            end
          end, plate)
        end
      end

      local dNpc = #(pCoords - v.npc)
      if dNpc <= 2.0 then
        sleep = 0
        ESX.ShowHelpNotification(Config.HelpNotify)
        if IsControlJustReleased(0, 38) then
          lastGarageIndex = idx

          local function pushVehicleCard(car)
            local props = car.vehicle or {}
            local hash  = props.model or 0

            local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
            if label == 'NULL' or label == '' or (label and label:find('^VEHICLE_')) then
              label = GetDisplayNameFromVehicleModel(hash)
            end

            local body  = (props.bodyHealth or 1000.0) / 10.0
            local eng   = (props.engineHealth or 1000.0) / 10.0
            local fuel  = props.fuelLevel or 0.0

            local modelImageName = BuildModelImageName(hash)
            
            local storedValue = "0"
            if car.stored == true or car.stored == 1 or car.stored == "1" then
                storedValue = "1"
            end

            SendNUIMessage({
              action = 'open',
              stored = storedValue,
              body = body,
              carhash = hash,
              plate = car.plate,
              modelImageName = modelImageName,
              damage = eng,
              name = label,
              fuellevel = fuel,
              garaj = 1,
              impound = false
            })
          end

          ESX.TriggerServerCallback('qt_garage:loadvehicles', function(data)
            if not data or #data == 0 then
              ESX.ShowNotification(Config.Notifications.notvehicle.message)
              return
            end
            SendNUIMessage({ action = 'reset' })
            for _, car in ipairs(data) do
              pushVehicleCard(car)
            end
            SetNuiFocus(true, true)
          end)
        end
      end
    end

    Wait(sleep)
  end
end)

RegisterNUICallback('closepage', function(_, cb)
  SetNuiFocus(false, false)
  cb(true)
end)

RegisterNUICallback('spawnvehicle', function(data, cb)
  local plate = data.plate
  if not plate then return cb(false) end

  ESX.TriggerServerCallback('qt_garage:vehicleOwner', function(cars)
    if not cars or not cars[1] then return cb(false) end
    local props = json.decode(cars[1].vehicle or '{}') or {}
    local x, y, z = table.unpack(Config.GarageCoords[lastGarageIndex].parkout)
    ESX.Game.SpawnVehicle(props.model, vector3(x, y, z + 1.0), Config.GarageCoords[lastGarageIndex].vehicleHeading or 0.0, function(veh)
      ESX.Game.SetVehicleProperties(veh, props)
      SetVehRadioStation(veh, "OFF")
      TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
      TriggerServerEvent('qt_garage:stored', plate, 0)
      ESX.ShowNotification("Véhicule sorti du garage")
    end)
    cb(true)
  end, plate)
end)