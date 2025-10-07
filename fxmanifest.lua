fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'qt_garage'
version '2.0.0'

shared_scripts {
  'config.lua',
}

client_scripts {
  'client.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server.lua',
}

ui_page 'html/index.html'

files {
  'html/*.html',
  'html/*.css',
  'html/*.js',
  'html/image/*.png'
}
