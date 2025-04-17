-- display.lua   
-- by @wim66
-- April 17 2025   

-- Import the required Cairo libraries
require 'cairo'
-- Try to require the 'cairo_xlib' module safely
local status, cairo_xlib = pcall(require, 'cairo_xlib')

if not status then
    -- If the module is not found, fall back to a dummy table
    -- This dummy table redirects all unknown keys to the global namespace (_G)
    -- This allows usage of global Cairo functions like cairo_xlib_surface_create
    cairo_xlib = setmetatable({}, {
        __index = function(_, k)
            return _G[k]
        end
    })
end

-- Data fetch settings
local FETCH_INTERVAL = 300 -- Seconds between running get_forecast.sh
local last_fetch_time = 0
local FORCE_FETCH = false
-- Dynamic path
local SCRIPT_DIR = debug.getinfo(1, 'S').source:match[[^@?(.*[\/])[^\/]-$]] or "./resources/"
local FETCH_SCRIPT = SCRIPT_DIR .. "get_weather.sh"

-- Function to read and parse weather data
local function read_weather_data()
    local weather_data = {}
    local weather_file = "./resources/cache/weather_data.txt"
    local file = io.open(weather_file, "r")

    if not file then
        print("Could not open weather data file: " .. weather_file)
        return weather_data
    end

    for line in file:lines() do
        local key, value = line:match("([^=]+)=([^=]+)")
        if key and value then
            weather_data[key] = value
        end
    end

    file:close()
    return weather_data
end

-- Function to load and draw an image with Cairo, supporting "centre_x"
local function draw_image(cr, img_path, x, y, width, height)
    local image = cairo_image_surface_create_from_png(img_path)
    local img_w = cairo_image_surface_get_width(image)
    local img_h = cairo_image_surface_get_height(image)

    -- Check if "x" is meant as "centre_x", and center the image if needed
    local x_pos = x
    if x == "centre_x" then
        x_pos = conky_window.width / 2 - (width / 2)
    end

    cairo_save(cr)
    cairo_translate(cr, x_pos, y)
    cairo_scale(cr, width / img_w, height / img_h)
    cairo_set_source_surface(cr, image, 0, 0)
    cairo_paint(cr)
    cairo_restore(cr)

    cairo_surface_destroy(image)
end

-- Function to draw text with Cairo, supporting "centre_x"
local function draw_text(cr, text, x, y, font, size, color)
    cairo_select_font_face(cr, font, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size(cr, size)
    local extents = cairo_text_extents_t:create()
    cairo_text_extents(cr, text, extents)

    -- Check if "x" is meant as "centre_x", and center the text if needed
    if x == "centre_x" then
        x = conky_window.width / 2 - (extents.width / 2)
    end

    cairo_set_source_rgba(cr, color[1], color[2], color[3], color[4])
    cairo_move_to(cr, x, y)
    cairo_show_text(cr, text)
    cairo_stroke(cr)
end

-- Function to display the weather data
function conky_draw_weather()
    if conky_window == nil then
        return
    end

    -- Run initial fetch at startup
    if last_fetch_time == 0 then
        local cmd = FETCH_SCRIPT
        if FORCE_FETCH then
            cmd = cmd .. " --force"
        end
        io.popen(cmd .. " 2>&1"):close()
    end

    -- Check if it's time to fetch new data
    local current_time = os.time()
    if current_time - last_fetch_time >= FETCH_INTERVAL then
        local cmd = FETCH_SCRIPT
        if FORCE_FETCH then
            cmd = cmd .. " --force"
        end
        local handle = io.popen(cmd .. " 2>&1")
        local output = handle:read("*all")
        handle:close()
        last_fetch_time = current_time
    end

    local weather_data = read_weather_data()

    local city = weather_data.CITY or "N/A"
    local weather_icon_path = "./resources/cache/weathericon.png"
    local weather_desc = weather_data.WEATHER_DESC or "N/A"
    local temp = weather_data.TEMP or "N/A"
    local humidity = weather_data.HUMIDITY or "N/A"
    local wind_speed = weather_data.WIND_SPEED or "N/A"

    -- Create a Cairo surface and context
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local cr = cairo_create(cs)

    -- Draw the image with Cairo, depending on ICON_SET
    if weather_data.ICON_SET == "Light-vclouds" then
        draw_image(cr, weather_icon_path, 80, -15, 150, 150)
    else
        draw_image(cr, weather_icon_path, "centre_x", 15, 90, 90)
    end

    -- Draw the texts with Cairo
    draw_text(cr, city, "centre_x", 230, "ChopinScript", 56, {1, 0.4, 0, 1})
    draw_text(cr, weather_desc, "centre_x", 150, "Dejavu Serif", 22, {249, 168, 0, 1})
    draw_text(cr, temp, "centre_x", 130, "Dejavu Serif", 22, {249, 168, 0, 1})

    -- Destroy the Cairo context and surface
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end

function conky_draw_weather_text()
    return ""
end