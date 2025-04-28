# PD-GLITCH

A comprehensive unstuck system for FiveM QB Core servers with advanced features, beautiful UI, and admin tools.

<div dir="rtl" lang="ar">
# نظام بي دي جليتش

سكربت متكامل لسيرفرات فايف ام يساعد اللاعبين الذين يعلقون تحت الأرض أو داخل الكائنات مع واجهة مستخدم جميلة وأدوات للمشرفين.
</div>

## Features

- **Modern UI**: Beautiful gold and black themed UI with animations
- **Multi-language Support**: English and Arabic languages included with RTL support
- **Multiple Access Methods**: Use commands or keybinds to access the menu
- **Admin Panel**: Dedicated admin panel to help stuck players
- **Reporting System**: Players can report issues to admins
- **Permission System**: Control who can access the menu (all, admin, or whitelisted jobs)
- **Animations**: Ragdoll and waking up animations for immersion
- **Detailed Logging**: Discord webhook integration for logs
- **Highly Configurable**: Extensive config options
- **Anti-Stuck Solution**: Provides players with a self-service way to escape being stuck
- **Cooldown System**: Prevents spam/abuse of the command
- **Blacklisted Areas**: Prevent the command from working in certain areas
- **Admin Bypass**: Admins can bypass cooldowns and blacklisted areas
- **Usage Statistics**: Track and display usage statistics for admins

<div dir="rtl" lang="ar">
## المميزات

- **واجهة مستخدم عصرية**: واجهة جميلة بألوان ذهبية وسوداء مع حركات متحركة
- **دعم متعدد اللغات**: اللغتين الإنجليزية والعربية مع دعم الكتابة من اليمين إلى اليسار
- **طرق وصول متعددة**: استخدام الأوامر أو مفاتيح الاختصار للوصول إلى القائمة
- **لوحة المشرف**: لوحة مخصصة للمشرفين لمساعدة اللاعبين العالقين
- **نظام الإبلاغ**: يمكن للاعبين الإبلاغ عن المشكلات للمشرفين
- **نظام الصلاحيات**: التحكم في من يمكنه الوصول إلى القائمة (الجميع، المشرفين، أو وظائف محددة)
- **الرسوم المتحركة**: حركات الارتجاج والاستيقاظ للانغماس
- **تسجيل مفصل**: تكامل ويب هوك ديسكورد للسجلات
- **قابلية للتخصيص**: خيارات تكوين واسعة
- **حل مشكلة العلق**: يوفر للاعبين طريقة ذاتية للهروب من العلق
- **نظام فترة الانتظار**: يمنع إساءة استخدام الأمر
- **مناطق محظورة**: منع عمل الأمر في مناطق معينة
- **تجاوز المشرف**: يمكن للمشرفين تجاوز فترات الانتظار والمناطق المحظورة
- **إحصائيات الاستخدام**: تتبع وعرض إحصائيات الاستخدام للمشرفين
</div>

## Installation

1. Download the resource
2. Place it in your server's resources directory
3. Add `ensure pd-glitch` to your server.cfg
4. Configure the settings in `config.lua` to your liking
5. Restart your server

<div dir="rtl" lang="ar">
## التثبيت

1. قم بتنزيل السكربت
2. ضعه في مجلد الموارد الخاص بالسيرفر
3. أضف `ensure pd-glitch` إلى ملف server.cfg
4. قم بتكوين الإعدادات في `config.lua` حسب رغبتك
5. أعد تشغيل السيرفر
</div>

## Configuration

The `config.lua` file contains all configurable options:

<div dir="rtl" lang="ar">
## الإعدادات

يحتوي ملف `config.lua` على جميع الخيارات القابلة للتكوين:
</div>

```lua
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
Config.AdminMenuKey = "F11" -- Keybind to open the admin menu (empty for none)
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
```

## Commands

### Player Commands
- `/glitch` - Attempts to unstuck the player immediately
- `/pdglitch` - Opens the unstuck menu (if enabled)

### Admin Commands
- `/pdadmin` - Opens the admin panel to help stuck players
- `/unstuckplayer [id]` - Remotely unstuck another player
- `/testwebhook` - Test the Discord webhook (console only)

### Keybinds
- `F5` (default) - Opens the unstuck menu (configurable)
- `F11` (default) - Opens the admin panel (configurable)

<div dir="rtl" lang="ar">
## الأوامر

### أوامر اللاعبين
- `/glitch` - محاولة إخراج اللاعب من العلق فوراً
- `/pdglitch` - فتح قائمة الخروج من العلق (إذا كانت مفعلة)

### أوامر المشرفين
- `/pdadmin` - فتح لوحة المشرف لمساعدة اللاعبين العالقين
- `/unstuckplayer [id]` - إخراج لاعب آخر من العلق عن بعد
- `/testwebhook` - اختبار ويب هوك ديسكورد (وحدة التحكم فقط)

### مفاتيح الاختصار
- `F5` (افتراضي) - فتح قائمة الخروج من العلق (قابل للتخصيص)
- `F11` (افتراضي) - فتح لوحة المشرف (قابل للتخصيص)
</div>

## Keybinding

Players can set a keybind for the `/glitch` command in their FiveM settings.

<div dir="rtl" lang="ar">
## ربط المفاتيح

يمكن للاعبين تعيين مفتاح للأمر `/glitch` في إعدادات FiveM الخاصة بهم.
</div>

## Localization

The resource supports multiple languages. Currently included:
- English (en)
- Arabic (ar)

To add a new language, create a new file in the `locales` folder.

<div dir="rtl" lang="ar">
## الترجمة

يدعم السكربت لغات متعددة. المتضمنة حاليًا:
- الإنجليزية (en)
- العربية (ar)

لإضافة لغة جديدة، قم بإنشاء ملف جديد في مجلد `locales`.
</div>

## Credits

- Created by [paenteomdev](https://github.com/paenteomdev)
- Version 1.0.0
- UI Design inspired by modern web interfaces
- Special thanks to the FiveM community for inspiration and support

<div dir="rtl" lang="ar">
## الاعتمادات

- تم إنشاؤه بواسطة [paenteomdev](https://github.com/paenteomdev)
- الإصدار 1.0.0
- تصميم واجهة المستخدم مستوحى من واجهات الويب الحديثة
- شكر خاص لمجتمع FiveM للإلهام والدعم
</div>

## License

This resource is licensed under the MIT License. See the LICENSE file for details.

<div dir="rtl" lang="ar">
## الترخيص

هذا السكربت مرخص بموجب ترخيص MIT. انظر ملف LICENSE للحصول على التفاصيل.
</div>
