fx_version "cerulean"

description "Standard laptop for fivem server, developed using vue js"
author "Davyd Cardoso"
version '1.0.0'

lua54 'yes'

games {
  "gta5",
  "rdr3"
}

ui_page 'web/build/index.html'

client_script "@str-errorlog/client/cl_errorlog.lua"

shared_scripts {
  "@str-lib/client/cl_rpc.lua",
  "config/boosting_config.lua",
  "client/boosting/cl_utils.lua",
  "shared/**/*"
}

client_scripts {
  "client/boosting/cl_utils.lua",
  "server/boosting/boosting_config.lua",
  "client/**/*"
}

server_scripts {
  "@str-lib/server/sv_rpc.lua",
  "@str-lib/server/sv_sql.lua",
  '@oxmysql/lib/MySQL.lua',
  "server/**/*",
}

escrow_ignore {
  'config/*.lua'
}

files {
  'web/build/index.html',
  'web/build/**/*',
}
