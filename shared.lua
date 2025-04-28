local QBCore = exports['qb-core']:GetCoreObject()

-- Initialize locale
if not Locale then Locale = {} end

function _(str, ...)  -- Translate string (properly declared as vararg)
    -- Check if locale exists
    if not Locale[Config.Locale] then
        Debug('[ERROR] Locale [' .. Config.Locale .. '] does not exist')
        return str
    end

    -- Check if translation key exists
    if not Locale[Config.Locale][str] then
        Debug('[ERROR] Translation [' .. Config.Locale .. '][' .. str .. '] does not exist')
        return str
    end

    -- Handle formatting
    local args = {...}
    if #args > 0 then
        -- Try to format with arguments
        local success, result = pcall(function(s, ...)  -- Properly declared as vararg
            return string.format(s, ...)
        end, Locale[Config.Locale][str], ...)

        if success then
            return result
        else
            Debug('[ERROR] Failed to format translation [' .. Config.Locale .. '][' .. str .. ']: ' .. result)
            return Locale[Config.Locale][str]
        end
    else
        -- No formatting needed
        return Locale[Config.Locale][str]
    end
end

-- Debug function
function Debug(msg)
    if Config.Debug then
        print('[PD-GLITCH] [DEBUG] ' .. msg)
    end
end

-- Check if player is in a blacklisted area
function IsInBlacklistedArea(coords)
    for _, area in ipairs(Config.BlacklistedAreas) do
        local distance = #(vector3(coords.x, coords.y, coords.z) - vector3(area.x, area.y, area.z))
        if distance <= area.radius then
            return true, area.name
        end
    end
    return false, nil
end

-- Format coordinates for display
function FormatCoords(coords)
    return string.format('X: %.2f, Y: %.2f, Z: %.2f', coords.x, coords.y, coords.z)
end
