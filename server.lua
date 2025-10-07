local ESX = exports['es_extended']:getSharedObject()

local function fetchAll(query, params)
  return MySQL.query.await(query, params or {})
end

local function fetchScalar(query, params)
  return MySQL.scalar.await(query, params or {})
end

local function execute(query, params)
  return MySQL.update.await(query, params or {})
end

local VehiclePrices = {}
local VehicleModelByHash = {}

MySQL.ready(function()
  local rows = fetchAll('SELECT model, price FROM vehicles', {})
  if rows and #rows > 0 then
    for _, r in ipairs(rows) do
      local model = tostring(r.model or '')
      local hash = joaat(model)
      VehiclePrices[hash] = r.price or 0
      VehicleModelByHash[hash] = model
    end
    print(('[qt_garage] Modèles chargés: %d'):format(#rows))
  else
    print('[qt_garage] ATTENTION: table "vehicles" vide ou absente')
  end
end)

AddEventHandler('onResourceStart', function(res)
  if res ~= GetCurrentResourceName() then return end
  Wait(200)
  if Config.UpdateStoredOnStart then
    execute('UPDATE owned_vehicles SET stored = 1', {})
    print('[qt_garage] Mise à jour des véhicules: stored=1')
  end
end)

local function getIdentifier(src)
  local xPlayer = ESX.GetPlayerFromId(src)
  return xPlayer and xPlayer.getIdentifier() or nil
end

ESX.RegisterServerCallback('qt_garage:loadvehicles2', function(src, cb)
  local list = {}
  for hash, price in pairs(VehiclePrices) do
    list[#list+1] = {
      hash = hash,
      price = price,
      model = VehicleModelByHash[hash] or nil
    }
  end
  cb(list)
end)

ESX.RegisterServerCallback('qt_garage:loadvehicles', function(src, cb)
  local identifier = getIdentifier(src)
  if not identifier then return cb({}) end

  local rows = fetchAll('SELECT plate, vehicle, stored FROM owned_vehicles WHERE owner = ?', { identifier })
  local owned = {}
  
  for _, v in ipairs(rows or {}) do
    local vehProps = json.decode(v.vehicle or '{}') or {}
    owned[#owned+1] = {
      vehicle = vehProps,
      stored = v.stored,
      plate = v.plate
    }
  end
  cb(owned)
end)

ESX.RegisterServerCallback('qt_garage:impoundGarage', function(src, cb)
  local identifier = getIdentifier(src)
  if not identifier then return cb({}) end

  local rows = fetchAll('SELECT plate, vehicle, stored FROM owned_vehicles WHERE owner = ?', { identifier })
  local list = {}
  for _, v in ipairs(rows or {}) do
    local vehProps = json.decode(v.vehicle or '{}') or {}
    list[#list+1] = {
      vehicle = vehProps,
      stored = v.stored,
      plate = v.plate
    }
  end
  cb(list)
end)

ESX.RegisterServerCallback('qt_garage:vehicleOwner', function(src, cb, plate)
  local row = fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = ?', { plate })
  cb(row)
end)

ESX.RegisterServerCallback('qt_garage:vehicleOwned', function(src, cb, plate)
  local identifier = getIdentifier(src)
  if not identifier then return cb(false) end
  local count = fetchScalar('SELECT COUNT(1) FROM owned_vehicles WHERE plate = ? AND owner = ?', { plate, identifier })
  cb((count or 0) > 0)
end)

ESX.RegisterServerCallback('qt_garage:changedCars', function(src, cb, plate)
  local trimmed = ESX.Math.Trim(plate or '')
  local vehicles = GetAllVehicles()
  for i = 1, #vehicles do
    if ESX.Math.Trim(GetVehicleNumberPlateText(vehicles[i])) == trimmed then
      return cb(true)
    end
  end
  cb(false)
end)

RegisterNetEvent('qt_garage:saveProps', function(plate, props)
  if type(props) ~= 'table' or type(plate) ~= 'string' then return end
  execute('UPDATE owned_vehicles SET vehicle = ? WHERE plate = ?', { json.encode(props), plate })
end)

RegisterNetEvent('qt_garage:stored', function(plate, state)
  if type(plate) ~= 'string' then return end
  local storedValue = state == 1 and 1 or 0
  execute('UPDATE owned_vehicles SET stored = ? WHERE plate = ?', { storedValue, plate })
end)