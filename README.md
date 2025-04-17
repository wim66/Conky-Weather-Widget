# Conky Weather Widget

A weather widget for Conky, written in Lua. Features a customizable rounded background and weather icons.

## Weather Widget Preview

<p align="center"> <img src="https://github.com/wim66/Conky-Weather-Widget/blob/main/preview.png" alt="image"></p>

## Features

- Configurable via `settings.lua`: API key, city, units, language, colors, and icon set.
- Optional GUI tools: `WeatherSettingsUpdater` for weather settings, `ConkyColorUpdater` for colors.
- Portable and lightweight, runs via `start.sh`.

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/wim66/Conky-Weather-Widget.git
   cd conky-weather-lua
   ```

2. **Set up OpenWeatherMap API key**:
   - Sign up at [openweathermap.org](https://openweathermap.org) to get a free API key.

4. **Configure settings (optional)**:
   - Edit `settings.lua` for city, units, or colors (see [Configuration](#configuration)).
   - Or use `WeatherSettingsUpdater` and `ConkyColorUpdater` apps.

## Usage

1. **Start the widget**:
   ```bash
   ./start.sh
   ```
   Logs are saved to `conky.log` for debugging.

2. **Stop Conky**:
   ```bash
   killall conky
   ```

## Configuration

Edit `settings.lua` to customize:

- `API_KEY`: Your OpenWeatherMap key (set via `OWM_API_KEY` environment variable).
- `CITY_ID`: City ID from [openweathermap.org](https://openweathermap.org) (e.g., `2759794` for Amsterdam).
- `UNITS`: `"metric"` (Celsius) or `"imperial"` (Fahrenheit).
- `LANG`: Language for day labels (e.g., `"nl"` for Dutch, `"en"` for English).
- `ICON_SET`: Weather icons (e.g., `"Dark-SagiSan"`, `"Light-vclouds"`). Available in `resources/weather-icons/`.
- `border_COLOR`: Gradient for background border (e.g., `"0,0xff5500,1.00,0.5,0xffd0b9,1.00,1,0xff5500,1.00"`).
- `bg_COLOR`: Background color (e.g., `"0x1d1f30,0.75"`).

Advanced: Adjust background corners in `resources/background.lua` (e.g., `corners = {40, 40, 40, 40}`).

Use `WeatherSettingsUpdater` for `API_KEY`, `CITY_ID`, `UNITS`, `LANG`, `ICON_SET`, or `ConkyColorUpdater` for `border_COLOR`, `bg_COLOR`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.