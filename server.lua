local QBCore = exports['qb-core']:GetCoreObject()

-- Debug function
function Debug(msg)
    if Config.Debug then
        print('[PD-GLITCH] [DEBUG] ' .. msg)
    end
end

-- Format coordinates for display
function FormatCoords(coords)
    return string.format('X: %.2f, Y: %.2f, Z: %.2f', coords.x, coords.y, coords.z)
end

-- Version information
local currentVersion = "1.0.0"
local resourceName = GetCurrentResourceName()
local githubUser = "paenteomdev"
local repositoryName = "pd-glitch"

-- Statistics tracking
local stats = {
    totalUses = 0,
    successfulTeleports = 0,
    failedTeleports = 0,
    usageByPlayer = {}
}

-- Store player reports
local PlayerReports = {}

-- Function to check for updates
function CheckForUpdates()
    local updateURL = "https://api.github.com/repos/" .. githubUser .. "/" .. repositoryName .. "/releases/latest"

    PerformHttpRequest(updateURL, function(statusCode, responseText, headers)
        if statusCode == 200 then
            local response = json.decode(responseText)

            if response.tag_name and response.tag_name ~= currentVersion then
                print("^7╔═══════════════════════════════════════════════════════════════════════╗^7")
                print("^7║                                                                       ║^7")
                print("^7║  ^3 ____                 _                     ____             ^7      ║^7")
                print("^7║  ^3|  _ \\ __ _  ___ _ __ | |_ ___  ___  _ __ _|  _ \\  _____   __^7      ║^7")
                print("^7║  ^3| |_) / _` |/ _ \\ '_ \\| __/ _ \\/ _ \\| '_ (_) | | |/ _ \\ \\ / /^7      ║^7")
                print("^7║  ^3|  __/ (_| |  __/ | | | ||  __/ (_) | | | || |_| |  __/\\ V / ^7      ║^7")
                print("^7║  ^3|_|   \\__,_|\\___|_| |_|\\__\\___|\\___/|_| |_||____/ \\___| \\_/  ^7      ║^7")
                print("^7║                                                                       ║^7")
                print("^7╠═══════════════════════════════════════════════════════════════════════╣^7")
                print("^7║                                                                       ║^7")
                print("^7║  ^3PD-GLITCH Update Available!^7                                         ║^7")
                print("^7║  ^2Current version: ^5" .. currentVersion .. "^7                                           ║^7")
                print("^7║  ^2Latest version: ^5" .. response.tag_name .. "^7                                           ║^7")
                print("^7║  ^2Download at: ^5https://github.com/" .. githubUser .. "/" .. repositoryName .. "/releases^7   ║^7")
                print("^7║                                                                       ║^7")
                print("^7╚═══════════════════════════════════════════════════════════════════════╝^7")
            else
                print("^7╔═══════════════════════════════════════════════════════════════════════╗^7")
                print("^7║                                                                       ║^7")
                print("^7║  ^3 ____                 _                     ____             ^7      ║^7")
                print("^7║  ^3|  _ \\ __ _  ___ _ __ | |_ ___  ___  _ __ _|  _ \\  _____   __^7      ║^7")
                print("^7║  ^3| |_) / _` |/ _ \\ '_ \\| __/ _ \\/ _ \\| '_ (_) | | |/ _ \\ \\ / /^7      ║^7")
                print("^7║  ^3|  __/ (_| |  __/ | | | ||  __/ (_) | | | || |_| |  __/\\ V / ^7      ║^7")
                print("^7║  ^3|_|   \\__,_|\\___|_| |_|\\__\\___|\\___/|_| |_||____/ \\___| \\_/  ^7      ║^7")
                print("^7║                                                                       ║^7")
                print("^7╠═══════════════════════════════════════════════════════════════════════╣^7")
                print("^7║                                                                       ║^7")
                print("^7║  ^2PD-GLITCH is up to date!^7                                            ║^7")
                print("^7║  ^2Current version: ^5" .. currentVersion .. "^7                                           ║^7")
                print("^7║  ^2GitHub: ^5https://github.com/" .. githubUser .. "/" .. repositoryName .. "^7                   ║^7")
                print("^7║                                                                       ║^7")
                print("^7╚═══════════════════════════════════════════════════════════════════════╝^7")
            end
        else
            print("^7╔═══════════════════════════════════════════════════════════════════════╗^7")
            print("^7║                                                                       ║^7")
            print("^7║  ^3 ____                 _                     ____             ^7      ║^7")
            print("^7║  ^3|  _ \\ __ _  ___ _ __ | |_ ___  ___  _ __ _|  _ \\  _____   __^7      ║^7")
            print("^7║  ^3| |_) / _` |/ _ \\ '_ \\| __/ _ \\/ _ \\| '_ (_) | | |/ _ \\ \\ / /^7      ║^7")
            print("^7║  ^3|  __/ (_| |  __/ | | | ||  __/ (_) | | | || |_| |  __/\\ V / ^7      ║^7")
            print("^7║  ^3|_|   \\__,_|\\___|_| |_|\\__\\___|\\___/|_| |_||____/ \\___| \\_/  ^7      ║^7")
            print("^7║                                                                       ║^7")
            print("^7╠═══════════════════════════════════════════════════════════════════════╣^7")
            print("^7║                                                                       ║^7")
            print("^7║  ^3PD-GLITCH^7                                                            ║^7")
            print("^7║  ^2Current version: ^5" .. currentVersion .. "^7                                           ║^7")
            print("^7║  ^2Failed to check for updates. Status code: ^5" .. statusCode .. "^7                    ║^7")
            print("^7║  ^2GitHub: ^5https://github.com/" .. githubUser .. "/" .. repositoryName .. "^7                   ║^7")
            print("^7║                                                                       ║^7")
            print("^7╚═══════════════════════════════════════════════════════════════════════╝^7")
        end
    end, "GET", "", {["Content-Type"] = "application/json"})
end

-- Function to notify admins
local function NotifyAdmins(message)
    if not Config.NotifyAdmins then return end

    local players = QBCore.Functions.GetPlayers()
    for _, playerId in ipairs(players) do
        local Player = QBCore.Functions.GetPlayer(tonumber(playerId))
        if Player then
            for _, group in ipairs(Config.AdminGroups) do
                if QBCore.Functions.HasPermission(playerId, group) then
                    TriggerClientEvent('QBCore:Notify', playerId, message, 'primary')
                    break
                end
            end
        end
    end
end

-- Function to send log to Discord
local function SendDiscordLog(playerId, playerCoords, wasMoved, reason, extraInfo)
    local player = GetPlayerIdentifiers(playerId)
    local playerName = GetPlayerName(playerId)

    -- Update statistics
    if Config.TrackStats then
        stats.totalUses = stats.totalUses + 1
        if wasMoved then
            stats.successfulTeleports = stats.successfulTeleports + 1
        else
            stats.failedTeleports = stats.failedTeleports + 1
        end

        if not stats.usageByPlayer[playerId] then
            stats.usageByPlayer[playerId] = {
                name = playerName,
                uses = 0,
                successful = 0,
                failed = 0
            }
        end

        stats.usageByPlayer[playerId].uses = stats.usageByPlayer[playerId].uses + 1
        if wasMoved then
            stats.usageByPlayer[playerId].successful = stats.usageByPlayer[playerId].successful + 1
        else
            stats.usageByPlayer[playerId].failed = stats.usageByPlayer[playerId].failed + 1
        end
    end

    -- Extract player identifiers
    local steamID = "غير معروف"
    local citizenID = "غير معروف"
    local discordID = "غير معروف"
    local license = "غير معروف"
    local ip = GetPlayerEndpoint(playerId) or "غير معروف"

    for _, identifier in pairs(player) do
        if string.match(identifier, "steam:") then
            steamID = identifier
        elseif string.match(identifier, "license:") then
            license = identifier
        elseif string.match(identifier, "discord:") then
            discordID = string.gsub(identifier, "discord:", "")
        end
    end

    -- Get QBCore player data if available
    local Player = QBCore.Functions.GetPlayer(playerId)
    local charInfo = Player and Player.PlayerData.charinfo or {}
    local jobInfo = Player and Player.PlayerData.job or {label = "غير معروف", grade = "غير معروف"}

    -- Determine status message and color based on reason
    local color = 15158332 -- Default red
    local statusMessage = "اللاعب ليس عالقاً تحت الأرض!"

    if reason == "success" then
        color = 3066993 -- Green
        statusMessage = "تم نقل اللاعب بنجاح إلى سطح قابل للمشي عليه."
    elseif reason == "no_surface" then
        statusMessage = "لم يتم العثور على سطح قابل للمشي عليه بالقرب من اللاعب."
    elseif reason == "not_stuck" then
        statusMessage = "اللاعب ليس عالقاً تحت الأرض."
    elseif reason == "blacklisted_area" then
        statusMessage = "اللاعب حاول استخدام الأمر في منطقة محظورة: " .. (extraInfo or "غير معروف")
        color = 16776960 -- Yellow
    elseif reason == "cooldown" then
        statusMessage = "اللاعب حاول استخدام الأمر أثناء فترة الانتظار."
        color = 16776960 -- Yellow
    end

    -- Format message
    local message = string.format("اللاعب %s استخدم أمر /glitch.\nالحالة: %s\n\nالشخصية: %s %s\nالوظيفة: %s (الرتبة: %s)\nعنوان IP: %s\nمعرف مستخدم ديسكورد: <@%s>\nمعرف ستيم: %s\nمعرف المواطن: %s\nمعرف FiveM: %s\nالإحداثيات: X: %.2f, Y: %.2f, Z: %.2f",
        playerName,
        statusMessage,
        charInfo.firstname or "غير معروف",
        charInfo.lastname or "غير معروف",
        jobInfo.label,
        jobInfo.grade,
        ip,
        discordID,
        steamID,
        license,
        playerId,
        playerCoords.x,
        playerCoords.y,
        playerCoords.z
    )

    -- Add timestamp
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")

    -- Notify admins
    if Config.NotifyAdmins then
        local notifyMsg = string.format('Player %s used the glitch command at %s', playerName, FormatCoords(playerCoords))
        if Config.Locale == 'ar' then
            notifyMsg = string.format('اللاعب %s استخدم أمر الخروج من العلق في %s', playerName, FormatCoords(playerCoords))
        end
        NotifyAdmins(notifyMsg)
    end

    -- Debug print
    Debug("Attempting to send log to Discord for player " .. playerName)

    -- Send to Discord webhook
    local jsonData = json.encode({
        username = Config.WebhookName,
        embeds = {
            {
                title = "معلومات خلل اللاعب",
                description = message,
                color = color,
                footer = {
                    text = Config.WebhookFooter
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    })

    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers)
        if err == 204 then
            Debug("Log sent to Discord successfully")
        else
            Debug("Failed to send log to Discord. Error: " .. tostring(err))
            Debug("Response: " .. tostring(text))
        end
    end, 'POST', jsonData, { ['Content-Type'] = 'application/json' })
end

-- Register server event
RegisterServerEvent("pd-Glitch:sendLogToDiscord")
AddEventHandler("pd-Glitch:sendLogToDiscord", function(playerPed, playerCoords, wasMoved, reason, extraInfo)
    local playerId = source
    SendDiscordLog(playerId, playerCoords, wasMoved, reason or (wasMoved and "success" or "not_stuck"), extraInfo)
end)

-- Command to get statistics
QBCore.Commands.Add('glitchstats', 'View glitch command usage statistics', {}, true, function(source, args)
    local playerId = source

    if not Config.TrackStats then
        TriggerClientEvent('QBCore:Notify', playerId, 'Statistics tracking is disabled.', 'error')
        return
    end

    local message = string.format('Total uses: %s\nSuccessful teleports: %s\nFailed teleports: %s',
                    stats.totalUses, stats.successfulTeleports, stats.failedTeleports)

    if Config.Locale == 'ar' then
        message = string.format('إجمالي الاستخدامات: %s\nعمليات النقل الناجحة: %s\nعمليات النقل الفاشلة: %s',
                    stats.totalUses, stats.successfulTeleports, stats.failedTeleports)
    end

    TriggerClientEvent('QBCore:Notify', playerId, message, 'primary', 10000)
end, 'admin')

-- Command to remotely trigger unstuck for a player
QBCore.Commands.Add('unstuckplayer', 'Unstuck a player remotely', {{name = 'id', help = 'Player ID'}}, true, function(source, args)
    local adminId = source
    local playerId = tonumber(args[1])

    if not playerId then
        TriggerClientEvent('QBCore:Notify', adminId, 'Invalid player ID.', 'error')
        return
    end

    local targetPlayer = QBCore.Functions.GetPlayer(playerId)
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', adminId, 'Player not found.', 'error')
        return
    end

    -- Trigger the unstuck function on the target player's client
    TriggerClientEvent('pd-Glitch:forceUnstuck', playerId)
    TriggerClientEvent('QBCore:Notify', adminId, 'Attempting to unstuck player ' .. playerId, 'success')
end, 'admin')

-- Register report issue event
RegisterServerEvent("pd-Glitch:reportIssue")
AddEventHandler("pd-Glitch:reportIssue", function(playerId, playerName, playerCoords)
    local source = source

    -- Format coordinates for display
    local coordsString = string.format('X: %.2f, Y: %.2f, Z: %.2f', playerCoords.x, playerCoords.y, playerCoords.z)

    -- Store the report
    local reportId = #PlayerReports + 1
    local timestamp = os.time()
    local report = {
        id = reportId,
        playerId = playerId,
        playerName = playerName,
        coords = playerCoords,
        coordsString = coordsString,
        timestamp = timestamp,
        timeString = os.date("%Y-%m-%d %H:%M:%S", timestamp),
        status = "pending" -- pending, resolved, invalid
    }

    table.insert(PlayerReports, report)

    Debug('New report added: ID ' .. reportId .. ' from player ' .. playerName .. ' (ID: ' .. playerId .. ')')

    -- Notify admins
    if Config.NotifyAdmins then
        local notifyMsg = string.format('Player %s (ID: %s) reported an issue with the unstuck system at %s',
            playerName, playerId, coordsString)

        if Config.Locale == 'ar' then
            notifyMsg = string.format('اللاعب %s (ID: %s) أبلغ عن مشكلة في نظام الخروج من العلق في %s',
                playerName, playerId, coordsString)
        end

        NotifyAdmins(notifyMsg)
    end

    -- Send to Discord webhook
    local jsonData = json.encode({
        username = Config.WebhookName,
        embeds = {
            {
                title = "Player Reported Unstuck Issue",
                description = string.format("Player %s (ID: %s) reported an issue with the unstuck system.\nLocation: %s\nReport ID: %s",
                    playerName, playerId, coordsString, reportId),
                color = 16776960, -- Yellow
                footer = {
                    text = "PD-GLITCH SYSTEM"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    })

    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers)
        if err == 204 then
            Debug("Report sent to Discord successfully")
        else
            Debug("Failed to send report to Discord. Error: " .. tostring(err))
        end
    end, 'POST', jsonData, { ['Content-Type'] = 'application/json' })
end)

-- Admin menu functions
-- Check if player is admin
function IsPlayerAdmin(source)
    -- Allow console to use admin commands
    if source == 0 then return true end

    -- Get player data
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end

    -- Debug output
    Debug('Checking admin status for player: ' .. GetPlayerName(source) .. ' (ID: ' .. source .. ')')

    -- Check if player has admin permissions
    -- Method 1: Check permission level directly
    if Player.PlayerData.permission then
        Debug('Player permission level: ' .. tostring(Player.PlayerData.permission))
        for _, group in ipairs(Config.AdminGroups) do
            if Player.PlayerData.permission == group then
                Debug('Player is admin (permission match)')
                return true
            end
        end
    end

    -- Method 2: Use QBCore's built-in function
    for _, group in ipairs(Config.AdminGroups) do
        if QBCore.Functions.HasPermission(source, group) then
            Debug('Player is admin (QBCore permission check)')
            return true
        end
    end

    -- Method 3: Check if player is god
    if Player.PlayerData.godmode then
        Debug('Player is admin (godmode)')
        return true
    end

    -- Method 4: Check if player is superadmin
    if IsPlayerAceAllowed(source, "command") then
        Debug('Player is admin (ace permissions)')
        return true
    end

    Debug('Player is not admin')
    return false
end

-- Get all online players
function GetAllPlayers()
    local players = {}
    local QBPlayers = QBCore.Functions.GetQBPlayers()

    Debug('Getting all players, found ' .. (QBPlayers and #QBPlayers or 0) .. ' QBPlayers')

    if not QBPlayers or next(QBPlayers) == nil then
        Debug('No players found or QBPlayers is nil')
        -- Add a dummy player for testing
        table.insert(players, {
            id = 1,
            name = "Test Player (No players found)"
        })
        return players
    end

    for _, player in pairs(QBPlayers) do
        if player and player.PlayerData then
            local playerId = player.PlayerData.source
            local playerName = "Unknown"

            if player.PlayerData.charinfo then
                playerName = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
            end

            local serverName = GetPlayerName(playerId) or "Unknown"

            table.insert(players, {
                id = playerId,
                name = playerName .. " (" .. serverName .. ")"
            })

            Debug('Added player: ' .. playerName .. ' (ID: ' .. playerId .. ')')
        else
            Debug('Skipping invalid player entry')
        end
    end

    if #players == 0 then
        Debug('No valid players found, adding dummy player')
        -- Add a dummy player for testing
        table.insert(players, {
            id = 1,
            name = "Test Player (No valid players found)"
        })
    end

    return players
end

-- Register admin command
RegisterCommand(Config.AdminMenuCommand, function(source, args, rawCommand)
    local src = source

    -- Only process if admin menu command is enabled
    if not Config.AdminMenuUseCommand then
        return
    end

    Debug('Admin command triggered by ' .. GetPlayerName(src) .. ' (ID: ' .. src .. ')')

    -- Check if player is admin
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "You don't have permission to use this command", "error")
        Debug("Player " .. GetPlayerName(src) .. " (ID: " .. src .. ") tried to use admin command but doesn't have permission")
        return
    end

    -- Get all players
    local players = GetAllPlayers()
    Debug('Found ' .. #players .. ' players')

    -- Get all reports
    Debug('Found ' .. #PlayerReports .. ' reports')

    -- Open admin menu
    Debug('Triggering openAdminMenu event for player ' .. GetPlayerName(src))
    TriggerClientEvent('pd-Glitch:openAdminMenu', src, players, PlayerReports)
end, false)

-- Check admin status (used for menu access)
RegisterServerEvent("pd-Glitch:checkAdminStatus")
AddEventHandler("pd-Glitch:checkAdminStatus", function()
    local src = source
    local isAdmin = IsPlayerAdmin(src)
    TriggerClientEvent('pd-Glitch:adminStatusResult', src, isAdmin)
end)

-- Register admin teleport player event
RegisterServerEvent("pd-Glitch:adminTeleportPlayer")
AddEventHandler("pd-Glitch:adminTeleportPlayer", function(playerId)
    local src = source

    -- Check if player is admin
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "You don't have permission to use this command", "error")
        return
    end

    -- Check if player exists
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(playerId))
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, "Player not found", "error")
        return
    end

    -- Trigger unstuck event for player
    TriggerClientEvent('pd-Glitch:forceUnstuck', playerId)

    -- Notify admin
    TriggerClientEvent('QBCore:Notify', src, "Teleported player " .. GetPlayerName(playerId) .. " (ID: " .. playerId .. ")", "success")

    -- Notify player
    TriggerClientEvent('QBCore:Notify', playerId, "An admin has teleported you out", "info")

    -- Log to Discord
    local adminName = GetPlayerName(src)
    local playerName = GetPlayerName(playerId)

    local jsonData = json.encode({
        username = Config.WebhookName,
        embeds = {
            {
                title = "Admin Teleported Player",
                description = string.format("Admin %s (ID: %s) teleported player %s (ID: %s) using the admin menu",
                    adminName, src, playerName, playerId),
                color = 3447003, -- Blue
                footer = {
                    text = "PD-GLITCH ADMIN SYSTEM"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    })

    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', jsonData, { ['Content-Type'] = 'application/json' })
end)

-- Register admin teleport to player event
RegisterServerEvent("pd-Glitch:adminTeleportToPlayer")
AddEventHandler("pd-Glitch:adminTeleportToPlayer", function(playerId)
    local src = source

    -- Check if player is admin
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "You don't have permission to use this command", "error")
        return
    end

    -- Check if player exists
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(playerId))
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, "Player not found", "error")
        return
    end

    -- Trigger teleport to player event
    TriggerClientEvent('pd-Glitch:adminTeleportTo', src, playerId)

    -- Notify admin
    TriggerClientEvent('QBCore:Notify', src, "Teleported to player " .. GetPlayerName(playerId) .. " (ID: " .. playerId .. ")", "success")

    -- Log to Discord
    local adminName = GetPlayerName(src)
    local playerName = GetPlayerName(playerId)

    local jsonData = json.encode({
        username = Config.WebhookName,
        embeds = {
            {
                title = "Admin Teleported To Player",
                description = string.format("Admin %s (ID: %s) teleported to player %s (ID: %s) using the admin menu",
                    adminName, src, playerName, playerId),
                color = 3447003, -- Blue
                footer = {
                    text = "PD-GLITCH ADMIN SYSTEM"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    })

    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', jsonData, { ['Content-Type'] = 'application/json' })
end)

-- Register admin refresh players event
RegisterServerEvent("pd-Glitch:adminRefreshPlayers")
AddEventHandler("pd-Glitch:adminRefreshPlayers", function()
    local src = source

    -- Check if player is admin
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "You don't have permission to use this command", "error")
        return
    end

    -- Get all players
    local players = GetAllPlayers()

    -- Send updated player list
    TriggerClientEvent('pd-Glitch:updateAdminMenu', src, players, PlayerReports)
end)

-- Register admin teleport player by ID event
RegisterServerEvent("pd-Glitch:adminTeleportPlayerById")
AddEventHandler("pd-Glitch:adminTeleportPlayerById", function(playerId)
    local src = source

    -- Check if player is admin
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "You don't have permission to use this command", "error")
        return
    end

    -- Check if player ID is valid
    playerId = tonumber(playerId)
    if not playerId then
        TriggerClientEvent('QBCore:Notify', src, "Invalid player ID", "error")
        return
    end

    -- Check if player exists
    local targetPlayer = QBCore.Functions.GetPlayer(playerId)
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, "Player not found with ID: " .. playerId, "error")
        return
    end

    -- Trigger unstuck event for player
    TriggerClientEvent('pd-Glitch:forceUnstuck', playerId)

    -- Notify admin
    TriggerClientEvent('QBCore:Notify', src, "Teleported player " .. GetPlayerName(playerId) .. " (ID: " .. playerId .. ")", "success")

    -- Notify player
    TriggerClientEvent('QBCore:Notify', playerId, "An admin has teleported you out", "info")

    -- Log to Discord
    local adminName = GetPlayerName(src)
    local playerName = GetPlayerName(playerId)

    local jsonData = json.encode({
        username = Config.WebhookName,
        embeds = {
            {
                title = "Admin Teleported Player by ID",
                description = string.format("Admin %s (ID: %s) teleported player %s (ID: %s) using manual ID input",
                    adminName, src, playerName, playerId),
                color = 3447003, -- Blue
                footer = {
                    text = "PD-GLITCH ADMIN SYSTEM"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    })

    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', jsonData, { ['Content-Type'] = 'application/json' })
end)

-- Register admin resolve report event
RegisterServerEvent("pd-Glitch:adminResolveReport")
AddEventHandler("pd-Glitch:adminResolveReport", function(reportId, status)
    local src = source

    -- Check if player is admin
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "You don't have permission to use this command", "error")
        return
    end

    -- Check if report exists
    reportId = tonumber(reportId)
    if not reportId or not PlayerReports[reportId] then
        TriggerClientEvent('QBCore:Notify', src, "Report not found", "error")
        return
    end

    -- Update report status
    PlayerReports[reportId].status = status
    PlayerReports[reportId].resolvedBy = GetPlayerName(src)
    PlayerReports[reportId].resolvedAt = os.time()

    -- Notify admin
    TriggerClientEvent('QBCore:Notify', src, "Report " .. reportId .. " marked as " .. status, "success")

    -- Log to Discord
    local adminName = GetPlayerName(src)
    local report = PlayerReports[reportId]

    local jsonData = json.encode({
        username = Config.WebhookName,
        embeds = {
            {
                title = "Admin Resolved Report",
                description = string.format("Admin %s (ID: %s) marked report #%s from player %s as %s",
                    adminName, src, reportId, report.playerName, status),
                color = 3066993, -- Green
                footer = {
                    text = "PD-GLITCH ADMIN SYSTEM"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    })

    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', jsonData, { ['Content-Type'] = 'application/json' })

    -- Send updated reports to all admins
    local admins = {}
    for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
        if IsPlayerAdmin(tonumber(playerId)) then
            table.insert(admins, tonumber(playerId))
        end
    end

    for _, adminId in ipairs(admins) do
        TriggerClientEvent('pd-Glitch:updateReports', adminId, PlayerReports)
    end
end)

-- Add a test command to verify webhook functionality
RegisterCommand("testwebhook", function(source, args, rawCommand)
    if source == 0 then -- Only allow from console
        local testMessage = json.encode({
            username = Config.WebhookName,
            content = "This is a test message from PD-Glitch script."
        })

        Debug("Sending test webhook...")

        PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers)
            if err == 204 then
                Debug("Test webhook sent successfully!")
            else
                Debug("Test webhook failed. Error: " .. tostring(err))
                Debug("Response: " .. tostring(text))
            end
        end, 'POST', testMessage, { ['Content-Type'] = 'application/json' })
    end
end, true)

-- Add command to check for updates
RegisterCommand("pdversion", function(source, args, rawCommand)
    if source == 0 or IsPlayerAdmin(source) then -- Only allow from console or admins
        CheckForUpdates()
    else
        TriggerClientEvent('QBCore:Notify', source, "You don't have permission to use this command", "error")
    end
end, false)

-- Register server events
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    -- Check for updates
    Citizen.Wait(2000) -- Wait 2 seconds to ensure everything is loaded
    CheckForUpdates()

    Debug('Resource started')
end)
