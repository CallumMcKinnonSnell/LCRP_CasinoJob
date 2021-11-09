fx_version 'adamant'

game 'gta5'


client_scripts {
  "@NativeUI/NativeUI.lua",
  '@es_extended/locale.lua',
  'en.lua',
  'config.lua',
  'client.lua',
}

server_scripts {
  '@es_extended/locale.lua',
  'config.lua',
  'server.lua'
}

dependencies {
	'es_extended',
	'esx_billing',
}

this_is_a_map 'no'


client_script '@WaveShield/xDxDxDxDxD.lua'