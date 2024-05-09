local function debugPrint(message)
    if Config.debug then
        print(message)
    end
end

local function isInArray(array, value)
    for _, v in ipairs(array) do
        debugPrint("Checking array value: " .. tostring(v) .. " against: " .. tostring(value))
        if v == value then
            return true
        end
    end
    return false
end

local function performVehicleLookup(plate, callback)
    local url = Config.cadURL
    local data = json.encode({plate = plate})
    local headers = {
        ["Content-Type"] = "application/json",
        ["token"] = Config.apiKey
    }

    PerformHttpRequest(url, function(err, text, headers)
        if err == 200 then
            local responseData = json.decode(text)
            if responseData then
                debugPrint("HTTP request successful: " .. text)
                callback(true, responseData)
            else
                debugPrint("Failed to decode JSON response.")
                callback(false)
            end
        else
            debugPrint("HTTP error while performing request: " .. err .. "\nResponse body: " .. text)
            callback(false)
        end
    end, 'POST', data, headers)    
end

RegisterNetEvent('wk:onPlateScanned')
AddEventHandler('wk:onPlateScanned', function(cam, plate, index, vehicle)
    local src = source
    debugPrint("Source captured: " .. tostring(src))
    if isInArray(Config.vehicleTypeFilter, tonumber(vehicle.class)) then
        debugPrint("Vehicle class " .. vehicle.class .. " is filtered; skipping...")
        return
    end

    local camCapitalized = (cam == 'front' and 'Front' or 'Rear')

    performVehicleLookup(plate, function(success, data)
        if success and data.success and data.data and #data.data > 0 then
            handleVehicleData(src, cam, plate, data.data[1])
        else
            if Config.noRegistrationAlerts then
                notifyClient(src, camCapitalized, plate, "Not Registered", "error")
            end
        end
    end)
end)

local function performVehicleLock(plate, userId, savePlate, callback)
    local url = Config.cadURL
    local data = json.encode({
        plate = plate,
        user_id = userId,
        save_plate = savePlate
    })
    local headers = {
        ["Content-Type"] = "application/json",
        ["token"] = Config.apiKey
    }

    PerformHttpRequest(url, function(err, text, headers)
        if err == 200 then
            local responseData = json.decode(text)
            if responseData then
                debugPrint("HTTP request successful: " .. text)
                callback(true, responseData)
            else
                debugPrint("Failed to decode JSON response.")
                callback(false)
            end
        else
            debugPrint("HTTP error while locking plate: " .. err .. "\nResponse body: " .. text)
            callback(false)
        end
    end, 'POST', data, headers)
end

function getDiscordIdFromSource(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, id in pairs(identifiers) do
        if string.sub(id, 1, string.len("discord:")) == "discord:" then
            debugPrint("Discord ID found: " .. id)
            return string.sub(id, 9)
        end
    end
    debugPrint("No Discord ID found for user.")
    return nil
end

RegisterNetEvent('wk:onPlateLocked')
AddEventHandler('wk:onPlateLocked', function(cam, plate, index, vehicle)
    local src = source
    debugPrint("Source captured: " .. tostring(src))


    local userId = getDiscordIdFromSource(src) 
    if not userId then
        debugPrint("No Discord ID found for user.")
        return
    end


    local savePlate = true 
    local camCapitalized = (cam == 'front' and 'Front' or 'Rear')
    performVehicleLock(plate, userId, savePlate, function(success, data)
        if success then
            if data.success and data.data and #data.data > 0 then
                handleVehicleData(src, cam, plate, data.data[1])
            else
                if Config.noRegistrationAlerts then
                    
                    notifyClient(src, camCapitalized, plate, "Not Registered", "error")
                end
            end
        else
            if Config.noRegistrationAlerts then
                notifyClient(src, camCapitalized, plate, "Failed to perform lookup", "error")
            end
        end
    end)
end)


function handleVehicleData(src, cam, plate, vehicleData)
    local camCapitalized = (cam == 'front' and 'Front' or 'Rear')
    local status = vehicleData.status_name
    local expires = Config.showExpirationDate and ('Expires: %s'):format(vehicleData.registration_expire) or ''
    local owner = vehicleData.civilian and vehicleData.civilian.full_name or 'Unknown'
    notifyClient(src, camCapitalized, plate, status, "success", expires, owner)
    debugPrint("Notifying client: " .. tostring(src) .. ", " .. status)
end

function notifyClient(src, cam, plate, status, type, expires, owner)
    expires = expires or ''
    owner = owner or 'Unknown'


    local color = 'white'
    local backgroundColor = '#333'
    if type == "error" then
        backgroundColor = '#C53030'
        color = 'white'
    elseif type == "success" then
        backgroundColor = '#2F855A'
        color = 'white'
    elseif type == "warning" then
        backgroundColor = '#DD6B20' 
        color = 'black'
    end

    local message = string.format(
        "<div style='color: %s; background-color: %s; padding: 8px; border-radius: 5px;'>"
        .. "<strong>%s ALPR</strong><br/>"
        .. "Plate: <strong>%s</strong><br/>"
        .. "Status: <strong>%s</strong><br/>"
        .. "%s"
        .. "Owner: <strong>%s</strong>"
        .. "</div>",
        color, backgroundColor, cam, plate:upper(), status, expires and ("Expires: <strong>" .. expires .. "</strong><br/>") or "", owner
    )


    TriggerClientEvent('pNotify:SendNotification', src, {
        text = message,
        type = type,
        queue = 'alpr',
        timeout = type == "success" and 30000 or 5000,
        layout = 'centerLeft'
    })
end
