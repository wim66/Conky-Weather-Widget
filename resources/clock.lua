-- clock.lua                                  
-- by @wim66                                  
-- Updated: 17-Apr-2025                       
-- Clock with day and date, supports gradient 

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


function conky_draw_text()
    -- Text element settings
    text_settings = {
        -- CLOCK
        {
            text = conky_parse("${time %H:%M}"),
            font_name = "zekton",
            font_size = 40,
            h_align = "c",
            v_align = "m",
            bold = false,
            italic = false,
            oblique = false,
            x = 165,
            y = 290,
            angle = 0,
            --colour = {{0., 0xFF0000, 1}, {0.5, 0xFFFFFF, 1}, {1, 0x0000FF, 1}},
            colour = {{0, 0xAAAAAA, 1}},
            orientation = "nn",
            skew_x = 0,
            skew_y = 0,
            --linear_gradient = {260, 65, 260, 90},
        },

        -- DAY
        {
            text = conky_parse("${time %A}"),
            font_name = "zekton",
            font_size = 24,
            h_align = "c",
            v_align = "m",
            bold = false,
            italic = false,
            oblique = false,
            x = 165,
            y = 255,
            angle = 0,
            colour = {{0, 0xAAAAAA, 1}},
            orientation = "nn",
            skew_x = 0,
            skew_y = 0,
            linear_gradient = {260, 90, 260, 110},
        },

--[[        -- DATE
        {
            text = conky_parse("${time %d %B %Y}"),
            font_name = "zekton",
            font_size = 18,
            h_align = "c",
            v_align = "m",
            bold = false,
            italic = false,
            oblique = false,
            x = 165,
            y = 260,
            angle = 0,
            colour = {{0, 0x888888, 1}},
            skew_x = 0,
            skew_y = 0,
            linear_gradient = {260, 130, 260, 150},
        },
]]        
    }

    if conky_window == nil then return end
    if tonumber(conky_parse("$updates")) < 3 then return end

    local cs = cairo_xlib_surface_create(conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)

    for i, v in ipairs(text_settings) do
        cr = cairo_create(cs)
        display_text(v)
        cairo_destroy(cr)
    end

    cairo_surface_destroy(cs)
end

function rgb_to_r_g_b2(tcolour)
    local colour, alpha = tcolour[2], tcolour[3]
    return ((colour / 0x10000) % 0x100) / 255.,
           ((colour / 0x100) % 0x100) / 255.,
           (colour % 0x100) / 255., alpha
end

function display_text(t)
    -- Set color or gradient
    local function set_pattern(te)
        if #t.colour == 1 then
            cairo_set_source_rgba(cr, rgb_to_r_g_b2(t.colour[1]))
        else
            local pts = t.linear_gradient or linear_orientation(t, te)
            local pat = cairo_pattern_create_linear(pts[1], pts[2], pts[3], pts[4])
            for i = 1, #t.colour do
                cairo_pattern_add_color_stop_rgba(pat, t.colour[i][1], rgb_to_r_g_b2(t.colour[i]))
            end
            cairo_set_source(cr, pat)
        end
    end

    -- Defaults
    t.text = t.text or "Conky is good for you!"
    t.x = t.x or conky_window.width / 2
    t.y = t.y or conky_window.height / 2
    t.colour = t.colour or {{1, 0xFFFFFF, 1}}
    t.font_name = t.font_name or "Free Sans"
    t.font_size = t.font_size or 14
    t.angle = t.angle or 0
    t.italic = t.italic or false
    t.oblique = t.oblique or false
    t.bold = t.bold or false
    t.orientation = t.orientation or "ww"
    t.h_align = t.h_align or "l"
    t.v_align = t.v_align or "b"
    t.skew_x = t.skew_x or 0
    t.skew_y = t.skew_y or 0

    cairo_translate(cr, t.x, t.y)
    cairo_rotate(cr, t.angle * math.pi / 180)
    cairo_save(cr)

    local slant = CAIRO_FONT_SLANT_NORMAL
    local weight = CAIRO_FONT_WEIGHT_NORMAL
    if t.italic then slant = CAIRO_FONT_SLANT_ITALIC end
    if t.oblique then slant = CAIRO_FONT_SLANT_OBLIQUE end
    if t.bold then weight = CAIRO_FONT_WEIGHT_BOLD end
    cairo_select_font_face(cr, t.font_name, slant, weight)

    for i = 1, #t.colour do
        if #t.colour[i] ~= 3 then
            print("Color error: fallback to white")
            t.colour[i] = {1, 0xFFFFFF, 1}
        end
    end

    local matrix = cairo_matrix_t:create()
    local skew_x = t.skew_x / t.font_size
    local skew_y = t.skew_y / t.font_size
    cairo_matrix_init(matrix, 1, skew_y, skew_x, 1, 0, 0)
    cairo_transform(cr, matrix)
    cairo_set_font_size(cr, t.font_size)

    local te = cairo_text_extents_t:create()
    cairo_text_extents(cr, t.text, te)

    local mx, my = 0, 0
    if t.h_align == "c" then mx = -te.width / 2
    elseif t.h_align == "r" then mx = -te.width end
    if t.v_align == "m" then my = -te.height / 2 - te.y_bearing
    elseif t.v_align == "t" then my = -te.y_bearing end

    set_pattern(te)
    cairo_move_to(cr, mx, my)
    cairo_show_text(cr, t.text)

    cairo_restore(cr)
end

function linear_orientation(t, te)
    local w, h = te.width, te.height
    local xb, yb = 0, 0
    if t.h_align == "c" then xb = xb - w / 2
    elseif t.h_align == "r" then xb = xb - w end
    if t.v_align == "m" then yb = -h / 2
    elseif t.v_align == "t" then yb = 0 end

    local p
    if t.orientation == "nn" then p = {xb + w / 2, yb, xb + w / 2, yb + h}
    elseif t.orientation == "ne" then p = {xb + w, yb, xb, yb + h}
    elseif t.orientation == "ww" then p = {xb, h / 2, xb + w, h / 2}
    elseif t.orientation == "se" then p = {xb + w, yb + h, xb, yb}
    elseif t.orientation == "ss" then p = {xb + w / 2, yb + h, xb + w / 2, yb}
    elseif t.orientation == "ee" then p = {xb + w, h / 2, xb, h / 2}
    elseif t.orientation == "sw" then p = {xb, yb + h, xb + w, yb}
    elseif t.orientation == "nw" then p = {xb, yb, xb + w, yb + h} end
    return p
end
