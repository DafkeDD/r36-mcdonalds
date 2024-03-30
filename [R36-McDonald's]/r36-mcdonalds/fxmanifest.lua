fx_version 'adamant'
game 'gta5'
 
author 'Amr Adel#5166'
description 'McDonalds System'

shared_scripts {
	'shared/config.lua'
}
client_scripts {
    'client/client.lua',
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
}

server_scripts {
    'shared/config.lua',
    'server/server.lua',
    '@oxmysql/lib/MySQL.lua',
}

lua54 'yes'