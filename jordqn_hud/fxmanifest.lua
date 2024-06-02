fx_version 'cerulean'

games { "gta5" }

ui_page 'web/index.html'

files {
    'zips.json',
    'zones.json',
    'web/*.html',
    'web/*.js',
    'web/*.css',
    'web/*.png'
}

client_script{
    "config.lua",
    "cl_*.lua"
}