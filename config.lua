Config = {}

-- General Settings
Config.Locale = 'en' -- Language (en, ar)
Config.Cooldown = 60 -- Cooldown in seconds between uses of the unstuck command
Config.ReportCooldown = 300 -- Cooldown in seconds between reports (5 minutes)
Config.Debug = false -- Enable debug mode (set to true for troubleshooting)

-- Command Settings
Config.CommandName = "glitch" -- Command name for the unstuck function

-- Menu Access Settings
Config.MenuUseCommand = true -- If true, use command to open menu. If false, use keybind only.
Config.MenuCommandName = "pdglitch" -- Command name to open the menu if MenuUseCommand is true
Config.MenuUseKeybind = true -- If true, use keybind to open menu. If false, use command only.
Config.MenuDefaultKey = "F5" -- Default key for opening the menu (empty string for no default)
Config.MenuAccessPermission = "all" -- Who can access the menu: "all" (everyone), "admin" (admins only), or "whitelist" (whitelisted jobs)
Config.MenuWhitelistedJobs = {"police", "ambulance"} -- Jobs that can access the menu if MenuAccessPermission is "whitelist"
Config.MenuCooldown = 10 -- Cooldown in seconds between opening the menu

-- Blacklisted Areas (coordinates where the command won't work)
Config.BlacklistedAreas = {
    -- Example: {x = 123.45, y = 678.90, z = 12.34, radius = 50.0, name = "Casino"},
}

-- Admin Settings
Config.NotifyAdmins = true -- Notify admins when a player uses the command
Config.AdminGroups = {"admin", "god", "superadmin"} -- QBCore groups that receive notifications
Config.AdminMenuCommand = "pdadmin" -- Command to open the admin menu
Config.AdminMenuKey = "F1" -- Keybind to open the admin menu (empty for none)
Config.AdminMenuUseCommand = true -- If true, use command to open admin menu. If false, use keybind only.
Config.AdminMenuUseKeybind = true -- If true, use keybind to open admin menu. If false, use command only.
Config.AdminCanBypassCooldown = true -- If true, admins can bypass the unstuck cooldown
Config.AdminCanBypassBlacklist = true -- If true, admins can use unstuck in blacklisted areas

-- Discord Webhook Settings
Config.DiscordWebhook = "YOUR_DISCORD_WEBHOOK_URL_HERE" -- Replace with your Discord webhook URL
Config.WebhookName = "PD-GLITCH Log"
Config.WebhookFooter = "PD-GLITCH System"

-- UI Settings
Config.UseUIMenu = true -- Use UI menu instead of just command
Config.UIPosition = "right" -- Position of the UI (left, right, center)

-- Animation Settings
Config.UseAnimation = true -- Play animation during teleport
Config.AnimationDict = "random@drunk_driver_1" -- Animation dictionary for waking up
Config.AnimationName = "drunk_fall_over" -- Animation name for waking up (reversed)
Config.AnimationDuration = 3000 -- Animation duration in ms
Config.AnimationFlags = 8 -- Animation flags (8 = play in reverse - makes it look like waking up)

-- Pre-teleport Animation Settings
Config.UsePreAnimation = true -- Play animation before teleport
Config.UseRagdoll = true -- Use ragdoll effect instead of animation for pre-teleport
Config.RagdollDuration = 2000 -- Ragdoll duration in ms

-- Fallback Animation Settings (if ragdoll doesn't work)
Config.PreAnimationDict = "dead" -- Animation dictionary for pre-teleport fallback
Config.PreAnimationName = "dead_a" -- Animation name for pre-teleport fallback
Config.PreAnimationDuration = 2000 -- Pre-animation duration in ms
Config.PreAnimationFlags = 1 -- Animation flags (1 = loop)

-- Sound Settings
Config.UseSound = true -- Play sound effects
Config.SuccessSound = "success" -- Sound to play on successful teleport
Config.FailSound = "error" -- Sound to play on failed teleport

-- Detection Settings
Config.MaxSearchHeight = 100.0 -- Maximum height to search for ground (higher = more thorough but slower)
Config.SearchSteps = 50 -- Number of steps to search (higher = more precise but slower)
Config.SearchStepSize = 2.0 -- Size of each step in the search

-- Statistics Settings
Config.TrackStats = true -- Track usage statistics
