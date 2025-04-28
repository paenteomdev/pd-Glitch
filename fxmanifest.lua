fx_version 'cerulean'
game 'gta5'

name 'PD-GLITCH'
author 'PaenteomDev'
description 'Fix player glitch if stuck underground or in an object'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
    'shared.lua',
    'locales/*.lua'
}

client_script 'client.lua'
server_script 'server.lua'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/admin.html',
    'html/admin.css',
    'html/admin.js'
}

lua54 'yes'
