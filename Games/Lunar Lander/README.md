# Lunar Lander

The goal of this project is to recreate the [Atari game Lunar Lander](<https://en.wikipedia.org/wiki/Lunar_Lander_(1979_video_game)>), using Box2D and a noise function to produce terrain.

## Design

The game uses [Overpass Mono](https://fonts.google.com/specimen/Overpass+Mono) for its one and only font.

In terms of flow, the game is divided in two states: `OrbitState` and `PlatformState`. The goal is to have a more focused, zoomed in version of the terrain as the lander actually approaches the ground level.

Terrain covers the bottom half of the screen. It is created using `love.math.noise` in conjunction with `love.math.random`. As noticed in the `Noise` folder, `love.math.noise` provieds a sequence of random numbers which is too smooth, and the inclusion of `love.math.random` allows to modify the segments to have jagged edges.

Data covers the top half of the screen, displaying the score, time, but also fuel, altitude, horizontal and vertical speed. The information is divided in groups of three, aligning the text to the left. For the speed, the game also uses arrows. While it is possible to create `.png` images for these visuals, the characters ` ↑`,`↓`,`→`, and `←` provide a quick alternative.

## Development

In the `Noise` and `Box2D` folder I develop a series of demos which work as the foundation of the eventual game. These are useful given personal inexperience with noise functions and the physics library respectively.

Each folder has a dedicated `README` to describe the different concepts and demos. Here, however, I annotate the specificities introduced in the game itself.

### displayData

The idea is to display data by passing it to a function.

```lua
function displayData(keys, formattingFunctions, startX, startY, gapX, gapY)
end
```

In order, these arguments describe:

- `keys`, a table for the type of data to actually display. This is a sequence of strings like `{"score", "time", "fuel"}`, and allows the display function to print the information in a precise order

- `formattingFunctions`, a table describing the formatting function for the value of the data. Not every value requires a formatting function, so that the table also includes `nil` values. In this instance, `displayFunction` should use the value as-in.

  _Please note_: using `nil` creates a table with "holes". This means the table is not a sequence, and the `ipairs` iterator is not able to consider the different values. It is not an issue in the specific project, but it is something of which to be aware.

- `startX` and `startY`, two variables describing where the data needs to be displayed. Multiple keys are shown from these two initial coordinates.

- `gapX` and `gapY`, two variables describing the gap between a key and it value (`gapX`), and between successive key-value pairs (`gapY`)
