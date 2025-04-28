local QBCore = exports['qb-core']:GetCoreObject()

-- Variables
local cooldownTimer = 0
local reportCooldownTimer = 0
local uiOpen = false
local resourceName = GetCurrentResourceName()
local adminStatus = nil -- Used for admin status check

-- Define translation functions
function _(str, ...)  -- Translate string (properly declared as vararg)
    if not Locale then Locale = {} end
    if not Locale[Config.Locale] then
        Debug('[ERROR] Locale [' .. Config.Locale .. '] does not exist')
        return str
    end

    if not Locale[Config.Locale][str] then
        Debug('[ERROR] Translation [' .. Config.Locale .. '][' .. str .. '] does not exist')
        return str
    end

    local args = {...}
    if #args > 0 then
        -- Try to format with arguments
        local success, result = pcall(function(s, ...)  -- Properly declared as vararg
            return string.format(s, ...)
        end, Locale[Config.Locale][str], ...)

        if success then
            return result
        else
            Debug('[ERROR] Failed to format translation [' .. Config.Locale .. '][' .. str .. ']: ' .. tostring(result))
            return Locale[Config.Locale][str]
        end
    else
        -- No formatting needed
        return Locale[Config.Locale][str]
    end
end

-- Define _U function for compatibility
if not _U then
    _U = function(str, ...)  -- Properly declared as vararg
        return _(str, ...)
    end
end

-- Load locale files directly
Locale = {}

-- Define fallback translations in case the locale files fail to load
Locale['en'] = {
    ['ui_title'] = 'Unstuck Menu',
    ['ui_description'] = 'Use this to teleport out if you are stuck',
    ['ui_button'] = 'Teleport Out',
    ['player_info'] = 'Player Information',
    ['player_id'] = 'Player ID:',
    ['player_name'] = 'Player Name:',
    ['current_location'] = 'Current Location:',
    ['stuck_status'] = 'Stuck Status:',
    ['ground_distance'] = 'Ground Distance:',
    ['last_teleport'] = 'Last Teleport:',
    ['stuck'] = 'Stuck',
    ['not_stuck_status'] = 'Not Stuck',
    ['report_button'] = 'Report Issue',
    ['report_sent'] = 'Report Sent!',
    ['close_button'] = 'Close',
    ['never'] = 'Never',
    ['just_now'] = 'just now',
    ['seconds_ago'] = '%s seconds ago',
    ['minutes_ago'] = '%s minutes ago',
    ['hours_ago'] = '%s hours ago',
    ['days_ago'] = '%s days ago',
    ['months_ago'] = '%s months ago',
    ['years_ago'] = '%s years ago',
    ['unknown'] = 'Unknown',
    ['meters'] = 'meters',
    ['use_this_message'] = 'Use this to teleport out if you are stuck',

    -- Notifications
    ['command_help'] = 'Use this command if you are stuck underground or in an object',
    ['ui_menu_help'] = 'Open the unstuck menu',
    ['success'] = 'You have been teleported to the nearest walkable surface!',
    ['no_surface'] = 'No walkable surface found nearby!',
    ['not_stuck'] = 'You are not stuck underground!',
    ['cooldown'] = 'You must wait %s seconds before using this command again!',
    ['blacklisted_area'] = 'You cannot use this command in this area!',
    ['report_cooldown'] = 'You must wait %s seconds before reporting again!',
    ['report_success'] = 'Your report has been sent to the admins!',

    -- Admin Menu
    ['admin_menu_help'] = 'Open the PD-GLITCH admin menu',
    ['admin_teleported'] = 'You have teleported player %s',
    ['admin_teleported_to'] = 'You have teleported to player %s',
    ['admin_no_permission'] = 'You do not have permission to use this command',
    ['admin_player_not_found'] = 'Player not found',
    ['admin_teleported_by'] = 'An admin has teleported you out'
}

Locale['ar'] = {
    ['ui_title'] = 'قائمة الخروج من العلق',
    ['ui_description'] = 'استخدم هذا للخروج إذا كنت عالقًا',
    ['ui_button'] = 'الخروج من العلق',
    ['player_info'] = 'معلومات اللاعب',
    ['player_id'] = 'معرف اللاعب:',
    ['player_name'] = 'اسم اللاعب:',
    ['current_location'] = 'الموقع الحالي:',
    ['stuck_status'] = 'حالة العلق:',
    ['ground_distance'] = 'المسافة عن الأرض:',
    ['last_teleport'] = 'آخر نقل:',
    ['stuck'] = 'عالق',
    ['not_stuck_status'] = 'غير عالق',
    ['report_button'] = 'الإبلاغ عن مشكلة',
    ['report_sent'] = 'تم إرسال البلاغ!',
    ['close_button'] = 'إغلاق',
    ['never'] = 'أبدًا',
    ['just_now'] = 'الآن',
    ['seconds_ago'] = 'منذ %s ثانية',
    ['minutes_ago'] = 'منذ %s دقيقة',
    ['hours_ago'] = 'منذ %s ساعة',
    ['days_ago'] = 'منذ %s يوم',
    ['months_ago'] = 'منذ %s شهر',
    ['years_ago'] = 'منذ %s سنة',
    ['unknown'] = 'غير معروف',
    ['meters'] = 'متر',
    ['use_this_message'] = 'استخدم هذا للخروج إذا كنت عالقًا',

    -- Notifications
    ['command_help'] = 'استخدم هذا الأمر إذا كنت عالقًا تحت الأرض أو في كائن',
    ['ui_menu_help'] = 'افتح قائمة الخروج من العلق',
    ['success'] = 'تم نقلك إلى أقرب سطح قابل للمشي عليه!',
    ['no_surface'] = 'لم يتم العثور على سطح قابل للمشي عليه بالقرب منك!',
    ['not_stuck'] = 'أنت لست عالقاً تحت الأرض!',
    ['cooldown'] = 'يجب عليك الانتظار %s ثانية قبل استخدام هذا الأمر مرة أخرى!',
    ['blacklisted_area'] = 'لا يمكنك استخدام هذا الأمر في هذه المنطقة!',
    ['report_cooldown'] = 'يجب عليك الانتظار %s ثانية قبل الإبلاغ مرة أخرى!',
    ['report_success'] = 'تم إرسال بلاغك إلى المشرفين!',

    -- Admin Menu
    ['admin_menu_help'] = 'افتح قائمة المشرف لنظام الخروج من العلق',
    ['admin_teleported'] = 'لقد قمت بنقل اللاعب %s',
    ['admin_teleported_to'] = 'لقد انتقلت إلى اللاعب %s',
    ['admin_no_permission'] = 'ليس لديك صلاحية لاستخدام هذا الأمر',
    ['admin_player_not_found'] = 'لم يتم العثور على اللاعب',
    ['admin_teleported_by'] = 'قام أحد المشرفين بنقلك للخارج'
}

local localeFiles = {
    ['en'] = 'locales/en.lua',
    ['ar'] = 'locales/ar.lua'
}

-- Load the English locale as a fallback
local englishFile = LoadResourceFile(resourceName, 'locales/en.lua')
if englishFile then
    local func, err = load(englishFile)
    if func then
        func()
        Debug('Loaded English locale')
    else
        Debug('[ERROR] Failed to load English locale: ' .. tostring(err))
    end
else
    Debug('[ERROR] Could not find English locale file')
end

-- Load the configured locale if it's not English
if Config.Locale ~= 'en' then
    local localeFile = LoadResourceFile(resourceName, localeFiles[Config.Locale])
    if localeFile then
        local func, err = load(localeFile)
        if func then
            func()
            Debug('Loaded ' .. Config.Locale .. ' locale')
        else
            Debug('[ERROR] Failed to load ' .. Config.Locale .. ' locale: ' .. tostring(err))
        end
    else
        Debug('[ERROR] Could not find ' .. Config.Locale .. ' locale file')
    end
end

-- Load sounds
if Config.UseSound then
    RequestScriptAudioBank("HUD_FRONTEND_DEFAULT_SOUNDSET", false)
end

-- Function to check if player is in a blacklisted area
function IsInBlacklistedArea(coords)
    for _, area in ipairs(Config.BlacklistedAreas) do
        local distance = #(vector3(coords.x, coords.y, coords.z) - vector3(area.x, area.y, area.z))
        if distance <= area.radius then
            return true, area.name
        end
    end
    return false, nil
end

-- Debug function
function Debug(msg)
    if Config.Debug then
        print('[PD-GLITCH] [DEBUG] ' .. msg)
    end
end

-- Function to attempt unstuck
function AttemptUnstuck()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local wasMoved = false
    local isAdmin = false

    -- Check if player is admin for bypass features
    if Config.AdminCanBypassCooldown or Config.AdminCanBypassBlacklist then
        TriggerServerEvent("pd-Glitch:checkAdminStatus")

        -- Wait for server response
        local adminCheckTimeout = 0
        while adminCheckTimeout < 50 do -- Wait up to 500ms for response
            if adminStatus ~= nil then
                isAdmin = adminStatus
                adminStatus = nil -- Reset for next check
                break
            end
            adminCheckTimeout = adminCheckTimeout + 1
            Wait(10)
        end
    end

    -- Check cooldown (skip if admin can bypass)
    if cooldownTimer > 0 and not (isAdmin and Config.AdminCanBypassCooldown) then
        local msg = 'You must wait ' .. cooldownTimer .. ' seconds before using this command again!'
        if Config.Locale == 'ar' then
            msg = 'يجب عليك الانتظار ' .. cooldownTimer .. ' ثانية قبل استخدام هذا الأمر مرة أخرى!'
        end
        QBCore.Functions.Notify(msg, "error")
        return false
    end

    -- Check if in blacklisted area (skip if admin can bypass)
    local isBlacklisted, areaName = IsInBlacklistedArea(playerCoords)
    if isBlacklisted and not (isAdmin and Config.AdminCanBypassBlacklist) then
        local msg = 'You cannot use this command in this area!'
        if Config.Locale == 'ar' then
            msg = 'لا يمكنك استخدام هذا الأمر في هذه المنطقة!'
        end
        QBCore.Functions.Notify(msg, "error")
        TriggerServerEvent("pd-Glitch:sendLogToDiscord", playerPed, playerCoords, wasMoved, "blacklisted_area", areaName)
        return false
    end

    -- Play pre-teleport animation or ragdoll if enabled
    if Config.UsePreAnimation then
        PlayPreTeleportAnimation()
    end

    -- Check if player is stuck
    local _, groundZ = GetGroundZFor_3dCoord(playerCoords.x, playerCoords.y, playerCoords.z, false)
    Debug("Ground Z: " .. tostring(groundZ))

    if groundZ == 0 then
        -- Search for valid ground
        for i = 1, Config.SearchSteps do
            Wait(10)
            _, groundZ = GetGroundZFor_3dCoord(playerCoords.x, playerCoords.y, playerCoords.z + (i * Config.SearchStepSize), false)
            Debug("Checking height " .. tostring(playerCoords.z + (i * Config.SearchStepSize)) .. ", found Z: " .. tostring(groundZ))

            if groundZ ~= 0 then
                -- Found valid ground, teleport player
                SetEntityCoords(playerPed, playerCoords.x, playerCoords.y, groundZ + 1.0, false, false, false, false)

                -- Play waking up animation after teleport
                if Config.UseAnimation then
                    PlayPostTeleportAnimation()
                end

                -- Play success sound
                if Config.UseSound then
                    PlaySoundFrontend(-1, Config.SuccessSound, "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                end

                local msg = 'You have been teleported to the nearest walkable surface!'
                if Config.Locale == 'ar' then
                    msg = 'تم نقلك إلى أقرب سطح قابل للمشي عليه!'
                end
                QBCore.Functions.Notify(msg, "success")
                wasMoved = true

                -- Set cooldown
                cooldownTimer = Config.Cooldown
                TriggerServerEvent("pd-Glitch:sendLogToDiscord", playerPed, playerCoords, wasMoved, "success")
                return true
            end
        end

        -- No valid ground found
        if Config.UseSound then
            PlaySoundFrontend(-1, Config.FailSound, "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        end

        local msg = 'No walkable surface found nearby!'
        if Config.Locale == 'ar' then
            msg = 'لم يتم العثور على سطح قابل للمشي عليه بالقرب منك!'
        end
        QBCore.Functions.Notify(msg, "error")
        TriggerServerEvent("pd-Glitch:sendLogToDiscord", playerPed, playerCoords, false, "no_surface")
    else
        -- Player is not stuck
        if Config.UseSound then
            PlaySoundFrontend(-1, Config.FailSound, "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        end

        local msg = 'You are not stuck underground!'
        if Config.Locale == 'ar' then
            msg = 'أنت لست عالقاً تحت الأرض!'
        end
        QBCore.Functions.Notify(msg, "error")
        TriggerServerEvent("pd-Glitch:sendLogToDiscord", playerPed, playerCoords, wasMoved, "not_stuck")
    end

    return false
end

-- Get help text for command/keybind
local function GetHelpText()
    return _('command_help')
end

-- Register main unstuck command
RegisterCommand(Config.CommandName, function()
    AttemptUnstuck()
end, false)

Debug('Registered unstuck command: /' .. Config.CommandName)

-- Register event for admin to force unstuck a player
RegisterNetEvent('pd-Glitch:forceUnstuck')
AddEventHandler('pd-Glitch:forceUnstuck', function()
    AttemptUnstuck()
end)

-- UI Menu
if Config.UseUIMenu then
    -- Get player stuck information
    local function GetPlayerStuckInfo()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local _, groundZ = GetGroundZFor_3dCoord(playerCoords.x, playerCoords.y, playerCoords.z, false)

        -- Calculate distance to ground
        local groundDistance = nil
        if groundZ ~= 0 then
            groundDistance = playerCoords.z - groundZ
        end

        -- Determine if player is stuck
        local isStuck = (groundZ == 0)

        -- Get player ID and name
        local playerId = GetPlayerServerId(PlayerId())
        local playerName = GetPlayerName(PlayerId())

        return {
            coords = playerCoords,
            groundZ = groundZ,
            groundDistance = groundDistance,
            isStuck = isStuck,
            playerId = playerId,
            playerName = playerName
        }
    end

    -- Create UI menu
    local function OpenUnstuckMenu()
        uiOpen = true
        SetNuiFocus(true, true)

        -- Get translations based on locale
        local translations = {
            title = _('ui_title'),
            description = _('ui_description'),
            button = _('ui_button'),
            playerInfo = _('player_info'),
            playerId = _('player_id'),
            playerName = _('player_name'),
            currentLocation = _('current_location'),
            stuckStatus = _('stuck_status'),
            groundDistance = _('ground_distance'),
            lastTeleport = _('last_teleport'),
            stuck = _('stuck'),
            notStuck = _('not_stuck_status'),
            reportButton = _('report_button'),
            reportSent = _('report_sent'),
            closeButton = _('close_button'),
            never = _('never'),
            justNow = _('just_now'),
            secondsAgo = _('seconds_ago'),
            minutesAgo = _('minutes_ago'),
            hoursAgo = _('hours_ago'),
            daysAgo = _('days_ago'),
            monthsAgo = _('months_ago'),
            yearsAgo = _('years_ago'),
            unknown = _('unknown'),
            meters = _('meters'),
            useThisMessage = _('use_this_message')
        }

        Debug('Opening UI menu')

        -- Get player stuck information
        local stuckInfo = GetPlayerStuckInfo()

        -- Send data to UI
        SendNUIMessage({
            action = "open",
            title = translations.title,
            description = translations.description,
            button = translations.button,
            position = Config.UIPosition,
            coords = stuckInfo.coords,
            groundZ = stuckInfo.groundZ,
            groundDistance = stuckInfo.groundDistance,
            isStuck = stuckInfo.isStuck,
            playerId = stuckInfo.playerId,
            playerName = stuckInfo.playerName,
            lastTeleport = nil, -- Will be set by the UI if available
            translations = translations, -- Send all translations to the UI
            locale = Config.Locale -- Send the current locale
        })

        -- Debug info
        Debug('UI should be visible now')
        Debug('UI Position: ' .. Config.UIPosition)
        Debug('Player stuck status: ' .. tostring(stuckInfo.isStuck))
    end

    -- Register UI menu access based on config
    local menuHelpText = _('ui_menu_help')

    -- Function to check if player has access to the menu
    local function HasMenuAccess()
        -- If menu is set to "all", everyone has access
        if Config.MenuAccessPermission == "all" then
            return true
        end

        -- If menu is set to "admin", only admins have access
        if Config.MenuAccessPermission == "admin" then
            local isAdmin = false
            TriggerServerEvent("pd-Glitch:checkAdminStatus")

            -- Wait for server response
            local adminCheckTimeout = 0
            while adminCheckTimeout < 50 do -- Wait up to 500ms for response
                if adminStatus ~= nil then
                    isAdmin = adminStatus
                    adminStatus = nil -- Reset for next check
                    break
                end
                adminCheckTimeout = adminCheckTimeout + 1
                Wait(10)
            end

            return isAdmin
        end

        -- If menu is set to "whitelist", check if player's job is whitelisted
        if Config.MenuAccessPermission == "whitelist" then
            local playerJob = QBCore.Functions.GetPlayerData().job.name
            for _, job in ipairs(Config.MenuWhitelistedJobs) do
                if playerJob == job then
                    return true
                end
            end
            return false
        end

        -- Default to false if none of the above conditions are met
        return false
    end

    -- Menu cooldown timer
    local menuCooldownTimer = 0

    -- Function to handle menu opening with cooldown and permission checks
    local function HandleMenuOpen()
        -- Check if menu is on cooldown
        if menuCooldownTimer > 0 then
            QBCore.Functions.Notify("Menu on cooldown. Please wait " .. menuCooldownTimer .. " seconds.", "error")
            return
        end

        -- Check if player has access to the menu
        if not HasMenuAccess() then
            QBCore.Functions.Notify("You don't have permission to use this menu.", "error")
            return
        end

        -- Open the menu
        OpenUnstuckMenu()

        -- Set cooldown
        menuCooldownTimer = Config.MenuCooldown
    end

    -- Cooldown timer for menu
    CreateThread(function()
        while true do
            Wait(1000)
            if menuCooldownTimer > 0 then
                menuCooldownTimer = menuCooldownTimer - 1
            end
        end
    end)

    -- Register command for menu if enabled
    if Config.MenuUseCommand then
        RegisterCommand(Config.MenuCommandName, function()
            HandleMenuOpen()
        end, false)

        Debug('Registered UI menu command: /' .. Config.MenuCommandName)
    end

    -- Register keybind for menu if enabled
    if Config.MenuUseKeybind then
        RegisterKeyMapping(Config.MenuCommandName, menuHelpText, 'keyboard', Config.MenuDefaultKey)
        Debug('Registered UI menu keybind with default key: ' .. (Config.MenuDefaultKey ~= "" and Config.MenuDefaultKey or "None"))
    end

    -- Register NUI callbacks
    RegisterNUICallback('unstuck', function(data, cb)
        Debug('Unstuck button clicked')
        SetNuiFocus(false, false)
        uiOpen = false

        -- Hide UI first
        SendNUIMessage({
            action = "close"
        })

        -- Then attempt unstuck
        AttemptUnstuck()

        cb('ok')
    end)

    RegisterNUICallback('report', function(data, cb)
        Debug('Report button clicked')

        -- Check if report is on cooldown
        if reportCooldownTimer > 0 then
            -- Send cooldown message to UI
            SendNUIMessage({
                action = "reportCooldown",
                cooldown = reportCooldownTimer
            })

            -- Notify player
            local msg = string.format(_('report_cooldown'), reportCooldownTimer)
            QBCore.Functions.Notify(msg, "error")

            cb('cooldown')
            return
        end

        -- Get player information
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local playerId = GetPlayerServerId(PlayerId())
        local playerName = GetPlayerName(PlayerId())

        -- Send report to server for admin notification
        TriggerServerEvent("pd-Glitch:reportIssue", playerId, playerName, playerCoords)

        -- Set cooldown
        reportCooldownTimer = Config.ReportCooldown

        -- Notify player
        QBCore.Functions.Notify(_('report_success'), "success")

        cb('ok')
    end)

    RegisterNUICallback('close', function(data, cb)
        Debug('Close button clicked')
        SetNuiFocus(false, false)
        uiOpen = false
        cb('ok')
    end)

    -- Update player info while menu is open
    CreateThread(function()
        while true do
            Wait(1000) -- Update every second

            if uiOpen then
                -- Get updated player information
                local stuckInfo = GetPlayerStuckInfo()

                -- Send update to UI
                SendNUIMessage({
                    action = "update",
                    coords = stuckInfo.coords,
                    groundZ = stuckInfo.groundZ,
                    groundDistance = stuckInfo.groundDistance,
                    isStuck = stuckInfo.isStuck,
                    playerId = stuckInfo.playerId,
                    playerName = stuckInfo.playerName
                })
            else
                Wait(1000) -- Wait longer if menu is closed
            end
        end
    end)
end

-- Cooldown timers
CreateThread(function()
    while true do
        Wait(1000)
        -- Handle unstuck cooldown
        if cooldownTimer > 0 then
            cooldownTimer = cooldownTimer - 1
        end

        -- Handle report cooldown
        if reportCooldownTimer > 0 then
            reportCooldownTimer = reportCooldownTimer - 1

            -- Update UI if menu is open
            if uiOpen then
                SendNUIMessage({
                    action = "updateReportCooldown",
                    cooldown = reportCooldownTimer
                })
            end
        end
    end
end)

-- Preload animation dictionaries
CreateThread(function()
    Debug('Preloading animation dictionaries')

    -- Preload pre-teleport animation dictionary
    if Config.UsePreAnimation then
        if not HasAnimDictLoaded(Config.PreAnimationDict) then
            RequestAnimDict(Config.PreAnimationDict)
            Debug('Requested pre-animation dictionary: ' .. Config.PreAnimationDict)
        end
    end

    -- Preload post-teleport animation dictionary
    if Config.UseAnimation then
        if not HasAnimDictLoaded(Config.AnimationDict) then
            RequestAnimDict(Config.AnimationDict)
            Debug('Requested post-animation dictionary: ' .. Config.AnimationDict)
        end
    end
end)

-- Admin Menu
local adminMenuOpen = false

-- Open admin menu
RegisterNetEvent('pd-Glitch:openAdminMenu')
AddEventHandler('pd-Glitch:openAdminMenu', function(players, reports)
    Debug('Received openAdminMenu event with ' .. #players .. ' players and ' .. #reports .. ' reports')

    if adminMenuOpen then
        Debug('Admin menu already open, ignoring')
        return
    end

    -- Make sure regular menu is closed
    if uiOpen then
        SendNUIMessage({
            action = "close"
        })
        uiOpen = false
        -- Wait a moment to ensure the regular menu is fully closed
        Citizen.Wait(100)
    end

    adminMenuOpen = true
    SetNuiFocus(true, true)

    Debug('Opening admin menu and setting NUI focus')

    -- Send a separate admin menu message
    SendNUIMessage({
        action = "openAdminOnly",
        reports = reports,
        isAdminMenu = true
    })
end)

-- Update admin menu
RegisterNetEvent('pd-Glitch:updateAdminMenu')
AddEventHandler('pd-Glitch:updateAdminMenu', function(players, reports)
    SendNUIMessage({
        action = "updateAdminMenu",
        players = players,
        reports = reports
    })
end)

-- Update reports
RegisterNetEvent('pd-Glitch:updateReports')
AddEventHandler('pd-Glitch:updateReports', function(reports)
    SendNUIMessage({
        action = "updateReports",
        reports = reports
    })
end)

-- Admin teleport to player
RegisterNetEvent('pd-Glitch:adminTeleportTo')
AddEventHandler('pd-Glitch:adminTeleportTo', function(playerId)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(tonumber(playerId)))
    if not DoesEntityExist(targetPed) then
        QBCore.Functions.Notify(_('admin_player_not_found'), "error")
        return
    end

    local targetCoords = GetEntityCoords(targetPed)
    local playerPed = PlayerPedId()

    -- Teleport to player
    SetEntityCoords(playerPed, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, false)
end)

-- Function to play pre-teleport animation or ragdoll
function PlayPreTeleportAnimation()
    local playerPed = PlayerPedId()

    -- Use ragdoll effect if enabled
    if Config.UseRagdoll then
        Debug('Using ragdoll effect for pre-teleport')

        -- Set player as ragdoll
        SetPedToRagdoll(playerPed, Config.RagdollDuration, Config.RagdollDuration, 0, true, true, false)

        -- Wait for ragdoll duration
        Wait(Config.RagdollDuration)

        -- Make sure player is no longer ragdolled
        SetPedCanRagdoll(playerPed, true)
    else
        -- Use animation instead of ragdoll
        Debug('Loading pre-animation dictionary: ' .. Config.PreAnimationDict)

        -- Try to play the configured animation
        local animPlayed = false

        -- Request animation dictionary
        if not HasAnimDictLoaded(Config.PreAnimationDict) then
            RequestAnimDict(Config.PreAnimationDict)
            local timeout = 0
            while not HasAnimDictLoaded(Config.PreAnimationDict) and timeout < 500 do
                timeout = timeout + 1
                Wait(10)
            end
        end

        -- Check if animation dictionary loaded successfully
        if HasAnimDictLoaded(Config.PreAnimationDict) then
            Debug('Playing pre-animation: ' .. Config.PreAnimationName)

            -- Clear any existing animations
            ClearPedTasks(playerPed)

            -- Play the animation
            TaskPlayAnim(playerPed, Config.PreAnimationDict, Config.PreAnimationName, 8.0, 1.0, Config.PreAnimationDuration, Config.PreAnimationFlags, 0.0, false, false, false)
            animPlayed = true

            -- Wait for animation to complete
            Wait(Config.PreAnimationDuration)

            -- Clear animation
            ClearPedTasks(playerPed)
        else
            Debug('Failed to load pre-animation dictionary')
        end

        -- If the configured animation failed, try a fallback animation
        if not animPlayed then
            Debug('Trying fallback pre-animation')

            -- Fallback animation - simple animation that should always work
            local fallbackDict = "amb@world_human_stand_mobile@male@text@base"
            local fallbackAnim = "base"

            if not HasAnimDictLoaded(fallbackDict) then
                RequestAnimDict(fallbackDict)
                local timeout = 0
                while not HasAnimDictLoaded(fallbackDict) and timeout < 500 do
                    timeout = timeout + 1
                    Wait(10)
                end
            end

            if HasAnimDictLoaded(fallbackDict) then
                Debug('Playing fallback pre-animation')
                ClearPedTasks(playerPed)
                TaskPlayAnim(playerPed, fallbackDict, fallbackAnim, 8.0, 1.0, 2000, 1, 0.0, false, false, false)
                Wait(2000) -- Wait for fallback animation
                ClearPedTasks(playerPed)
            else
                Debug('Failed to load fallback pre-animation')
            end
        end
    end
end

-- Function to play post-teleport animation
function PlayPostTeleportAnimation()
    local playerPed = PlayerPedId()

    Debug('Loading waking up animation dictionary: ' .. Config.AnimationDict)

    -- Try to play the configured animation
    local animPlayed = false

    -- Request animation dictionary
    if not HasAnimDictLoaded(Config.AnimationDict) then
        RequestAnimDict(Config.AnimationDict)
        local timeout = 0
        while not HasAnimDictLoaded(Config.AnimationDict) and timeout < 500 do
            timeout = timeout + 1
            Wait(10)
        end
    end

    -- Check if animation dictionary loaded successfully
    if HasAnimDictLoaded(Config.AnimationDict) then
        Debug('Playing waking up animation: ' .. Config.AnimationName)

        -- Clear any existing animations
        ClearPedTasks(playerPed)

        -- Play the animation in reverse (makes it look like getting up)
        TaskPlayAnim(playerPed, Config.AnimationDict, Config.AnimationName, 8.0, 1.0, Config.AnimationDuration, Config.AnimationFlags, 0.0, false, false, false)
        animPlayed = true

        -- Don't wait for animation to complete, let it play out naturally
    else
        Debug('Failed to load waking up animation dictionary')
    end

    -- If the configured animation failed, try a fallback animation
    if not animPlayed then
        Debug('Trying fallback waking up animation')

        -- Fallback animation - getting up animation that should work
        local fallbackDict = "get_up@directional@movement@from_knees@standard"
        local fallbackAnim = "getup_front_0"

        if not HasAnimDictLoaded(fallbackDict) then
            RequestAnimDict(fallbackDict)
            local timeout = 0
            while not HasAnimDictLoaded(fallbackDict) and timeout < 500 do
                timeout = timeout + 1
                Wait(10)
            end
        end

        if HasAnimDictLoaded(fallbackDict) then
            Debug('Playing fallback waking up animation')
            ClearPedTasks(playerPed)
            TaskPlayAnim(playerPed, fallbackDict, fallbackAnim, 8.0, 1.0, 2000, 0, 0.0, false, false, false)
        else
            -- Second fallback - even simpler animation
            local fallbackDict2 = "mp_sleep"
            local fallbackAnim2 = "sleep_getup_rubeyes"

            if not HasAnimDictLoaded(fallbackDict2) then
                RequestAnimDict(fallbackDict2)
                local timeout = 0
                while not HasAnimDictLoaded(fallbackDict2) and timeout < 500 do
                    timeout = timeout + 1
                    Wait(10)
                end
            end

            if HasAnimDictLoaded(fallbackDict2) then
                Debug('Playing second fallback waking up animation')
                ClearPedTasks(playerPed)
                TaskPlayAnim(playerPed, fallbackDict2, fallbackAnim2, 8.0, 1.0, 2000, 0, 0.0, false, false, false)
            else
                Debug('Failed to load all waking up animations')
            end
        end
    end
end

-- Function to find safe coordinates
function FindSafeCoords(playerCoords)
    local foundSafeCoords = false
    local safeCoords = vector3(0, 0, 0)

    -- Check if player is stuck
    local _, groundZ = GetGroundZFor_3dCoord(playerCoords.x, playerCoords.y, playerCoords.z, false)
    Debug("Ground Z: " .. tostring(groundZ))

    if groundZ == 0 then
        -- Search for valid ground
        for i = 1, Config.SearchSteps do
            Wait(10)
            _, groundZ = GetGroundZFor_3dCoord(playerCoords.x, playerCoords.y, playerCoords.z + (i * Config.SearchStepSize), false)
            Debug("Checking height " .. tostring(playerCoords.z + (i * Config.SearchStepSize)) .. ", found Z: " .. tostring(groundZ))

            if groundZ ~= 0 then
                -- Found valid ground
                foundSafeCoords = true
                safeCoords = vector3(playerCoords.x, playerCoords.y, groundZ + 1.0)
                break
            end
        end
    else
        -- Player is not stuck, but we'll provide the current ground coordinates anyway
        foundSafeCoords = true
        safeCoords = vector3(playerCoords.x, playerCoords.y, groundZ + 1.0)
    end

    return foundSafeCoords, safeCoords
end

-- Force unstuck a player (triggered by admin)
RegisterNetEvent('pd-Glitch:forceUnstuck')
AddEventHandler('pd-Glitch:forceUnstuck', function()
    -- Skip cooldown check since this is admin-initiated
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- Notify player
    QBCore.Functions.Notify(_('admin_teleported_by'), "info")

    -- Play pre-teleport animation if enabled
    if Config.UsePreAnimation then
        PlayPreTeleportAnimation()
    end

    -- Find safe coordinates
    local foundSafeCoords, safeCoords = FindSafeCoords(playerCoords)

    -- Teleport player
    if foundSafeCoords then
        -- Teleport to safe coordinates
        SetEntityCoords(playerPed, safeCoords.x, safeCoords.y, safeCoords.z, false, false, false, false)

        -- Play post-teleport animation if enabled
        if Config.UseAnimation then
            PlayPostTeleportAnimation()
        end
    else
        -- No safe coordinates found
        QBCore.Functions.Notify(_('no_surface'), "error")
    end
end)

-- Register NUI callbacks for admin menu
RegisterNUICallback('adminTeleportPlayer', function(data, cb)
    TriggerServerEvent("pd-Glitch:adminTeleportPlayer", data.playerId)
    cb('ok')
end)

RegisterNUICallback('adminTeleportToPlayer', function(data, cb)
    TriggerServerEvent("pd-Glitch:adminTeleportToPlayer", data.playerId)
    cb('ok')
end)

RegisterNUICallback('adminRefreshPlayers', function(data, cb)
    TriggerServerEvent("pd-Glitch:adminRefreshPlayers")
    cb('ok')
end)

RegisterNUICallback('adminTeleportPlayerById', function(data, cb)
    TriggerServerEvent("pd-Glitch:adminTeleportPlayerById", data.playerId)
    cb('ok')
end)

RegisterNUICallback('adminResolveReport', function(data, cb)
    TriggerServerEvent("pd-Glitch:adminResolveReport", data.reportId, data.status)
    cb('ok')
end)

RegisterNUICallback('adminClose', function(data, cb)
    Debug('Admin menu close requested')
    SetNuiFocus(false, false)
    adminMenuOpen = false
    cb('ok')
end)

-- Register admin menu keybind if configured
if Config.AdminMenuKey ~= "" and Config.AdminMenuUseKeybind then
    RegisterKeyMapping(Config.AdminMenuCommand, _('admin_menu_help'), 'keyboard', Config.AdminMenuKey)
    Debug('Registered admin menu keybind with key: ' .. Config.AdminMenuKey)
end

-- Admin status check response
RegisterNetEvent('pd-Glitch:adminStatusResult')
AddEventHandler('pd-Glitch:adminStatusResult', function(isAdmin)
    adminStatus = isAdmin
end)
