-- loadall.lua
-- by @wim66
-- April 17 2025

-- Set the path to the scripts foder
package.path = "./resources/?.lua"
-- ###################################

require 'display'
require 'background'
require 'clock'

function conky_main()
     conky_draw_background()
     conky_draw_weather()
     conky_draw_text()

end
