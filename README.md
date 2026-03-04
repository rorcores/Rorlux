# Rorlux

A simple blue light filter for macOS that lives in your menu bar.

<img width="358" height="406" alt="Screenshot 2026-03-03 at 10 38 41 AM" src="https://github.com/user-attachments/assets/9d4911e0-b462-45ad-b249-113958d6c160" />


## Why

f.lux used to be great — a straightforward app that warmed your screen to reduce blue light. Over the years it became bloated with automatic scheduling, location-based fading, multiple colour presets, movie modes, and more. I just wanted to toggle a warm filter on, set the intensity, and have it stay there. So I built Rorlux: the blue light filter f.lux used to be.

## What It Does

Click the sun icon in your menu bar. Flip the toggle on. Drag the warmth slider to where your eyes feel comfortable. That's it. No schedules, no time-of-day logic, no complexity.

- **Menu bar app** — no dock icon, sits quietly in the top right
- **On/off toggle** — instant, no fade animation
- **Warmth slider** — from mild (6200K) to deep ember (500K)
- **2700K preset** — one-click shortcut to the sweet spot
- **All displays** — applies to every connected monitor
- **Persistent** — remembers your settings between launches

## Requirements

- macOS 13 (Ventura) or later
- Xcode Command Line Tools — install with `xcode-select --install`

## Build & Install

```bash
git clone https://github.com/rorcores/Rorlux.git
cd Rorlux
chmod +x build.sh
./build.sh
rm -rf /Applications/Rorlux.app && cp -r build/Rorlux.app /Applications/
```

Then open from Applications, Spotlight, or:

```bash
open /Applications/Rorlux.app
```

To rebuild after changes, run `./build.sh` again and re-copy to Applications.

## How It Works

Rorlux uses the same core technique as f.lux: it adjusts your display's gamma tables via the macOS CoreGraphics API (`CGSetDisplayTransferByFormula`). A colour temperature value (in Kelvin) is converted to per-channel RGB multipliers using blackbody radiation curves, then applied to every connected display. Lowering the temperature reduces blue and green light output, giving the screen a warm amber tint.

The filter automatically re-applies after wake from sleep, screen unlock, and monitor connect/disconnect events, and refreshes every 30 seconds to stay active even if another process resets the gamma.

## Notes

- Disable macOS Night Shift (System Settings → Displays → Night Shift) to avoid conflicts
- When Rorlux quits, your display colours return to normal immediately
- No data is collected — settings are stored locally in UserDefaults
