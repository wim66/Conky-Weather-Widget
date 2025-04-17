-- settings.lua
-- by @wim66
-- April 17 2025

function conky_vars()
    -- ICON_SET: Defines the weather icon set to use.
    -- Available options:
    --   - Dark theme sets: "Dark-dovora", "Dark-modern", "Dark-monochrome", "Dark-openweathermap", "Dark-SagiSan", "Dark-spils-icons"
    --   - Light theme sets: "Light-dovora", "Light-modern", "Light-monochrome", "Light-openweathermap", "Light-spils-icons", "Light-vclouds"
    -- How to change:
    --   - Simply update the value below to one of the available options (e.g., "Light-vclouds").
    --   - Ensure the set exists in your weather-icons directory to avoid errors.
ICON_SET = "Light-vclouds"

    -- API_KEY: Your OpenWeatherMap API key.
    -- Recommended: Use the Weather Settings Updater GUI to set this value.
    -- Alternatively, follow these steps to set it manually:
    -- 1. Sign up at https://openweathermap.org/ and get your free API key (e.g., "abc123def456").
    -- 2. Add it to your shell configuration file to make it persistent:
    --    a. Open a terminal and check your shell with: echo $SHELL
    --    b. For Bash (/bin/bash), edit ~/.bashrc with: nano ~/.bashrc
    --    c. For Zsh (/bin/zsh), edit ~/.zshrc with: nano ~/.zshrc
    --    d. Add this line at the end: export OWM_API_KEY="your_api_key_here"
    --       Replace "your_api_key_here" with your actual key (e.g., "abc123def456").
    --    e. Save the file (Ctrl+O, Enter in nano; :w in vim) and exit (Ctrl+X in nano; :q in vim).
    --    f. Reload the config with: source ~/.bashrc (or source ~/.zshrc for Zsh).
    -- 3. Verify it works by running: echo $OWM_API_KEY (should output your key).
API_KEY = "OWM_API_KEY"

    -- CITY_ID: The ID of the city for which you want weather data.
    -- Recommended: Use the Weather Settings Updater GUI to set this value.
    -- Alternatively, find it manually:
    -- 1. Go to https://openweathermap.org/.
    -- 2. Search for your city, e.g., "Amsterdam".
    -- 3. Check the URL in your browser, e.g., https://openweathermap.org/city/2759794.
    -- 4. The number at the end (2759794 for Amsterdam) is your CITY_ID.
CITY_ID = "CITY_ID"

    -- UNITS: Temperature unit for the weather data.
    -- Options:
    --   "metric"   - Celsius (°C)
    --   "imperial" - Fahrenheit (°F)
UNITS = "imperial"

    -- LANG: Language for weather descriptions and labels.
    -- Options: "en" (English), "nl" (Dutch), "fr" (French), "es" (Spanish), "de" (German), etc.
    -- Full list for weather descriptions: https://openweathermap.org/current#multi
    -- Note: This also sets labels in display.lua (e.g., "Humidity", "Wind Speed").
    -- Supported languages in display.lua: "en", "nl", "fr", "es". Fallback is English.
    -- To add or modify translations:
    -- 1. Open display.lua in a text editor (e.g., nano display.lua).
    -- 2. Find the get_labels function.
    -- 3. Add a new elseif block for your language, e.g.:
    --    elseif lang == "de" then
    --        return { humidity = "Luftfeuchtigkeit", wind_speed = "Windgeschwindigkeit" }
    -- 4. Replace "de" with your language code and update the translations.
    -- 5. Save and reload Conky to apply changes.
LANG = "en"

    -- border_COLOR: Defines the gradient border for the Conky widget.
    -- Format: "start_angle,color1,opacity1,midpoint,color2,opacity2,steps,color3,opacity3"
    -- Example: "0,0x390056,1.00,0.5,0xff007f,1.00,1,0x390056,1.00" creates a purple-pink gradient.
    border_COLOR = "0,0xaa0000,1.00,0.5,0xffcdcd,1.00,1,0xaa0000,1.00"

    -- bg_COLOR: Background color and opacity for the widget.
    -- Format: "color,opacity"
    -- Example: "0x1d1e28,0.75" sets a dark purple background with 75% opacity.
    bg_COLOR = "0x1d1d2e,0.78"

    ----- Don't change these lines below -----
    API_KEY = API_KEY ~= "OWM_API_KEY" and API_KEY or os.getenv("OWM_API_KEY") or "your_default_api_key_here"
    CITY_ID = CITY_ID ~= "CITY_ID" and CITY_ID or os.getenv("CITY_ID") or "your_city_code_here"
end
