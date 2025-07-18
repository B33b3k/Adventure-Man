# 🎮 Pixel Adventure

A side-scrolling action game built using **Flutter + Flame Engine**. Pixel Adventure brings a retro-style platformer experience to mobile, where players explore mysterious pixel worlds, avoid traps, defeat enemies, and complete levels.

---

## 🚀 Features

- 🕹️ Smooth side-scrolling gameplay  
- 🎨 Retro pixel-art environment and characters  
- 🔊 Sound effects and background music integration  
- 🎮 Multi-level platformer with obstacles and gravity  
- 📱 Runs on Android (and supports Web with minimal tweaks)  
- 🛠️ Built using **Flutter + Flame** game engine  

---

## 🎥 Gameplay & Tutorial Videos

### Gameplay Preview  
<video width="640" height="360" controls>
  <source src="./nxkrSFqL_77Sl6le.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

### Adding Player Mechanics Tutorial
<video width="640" height="360" controls>
  <source src="./final.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

---

## 🧠 Tech Stack

- **Flutter** (UI framework)  
- **Flame Engine** (game loop, collisions, physics)  
- **Forge2D** (optional physics, if used)  
- **Tiled** (for level/map design)  

---

## 📁 Project Structure

```plaintext
lib/
├── main.dart                 # App entry point
├── game/
│   ├── pixel_adventure.dart  # Main game class
│   ├── components/           # Player, enemies, platforms, etc.
│   ├── levels/               # Level data and rendering
│   └── utils/                # Helpers, constants
assets/
├── images/                   # Sprite sheets, tilesets
├── audio/                    # Sound effects and music
├── maps/                     # .tmx files from Tiled
pubspec.yaml                  # Flutter + Flame dependencies
