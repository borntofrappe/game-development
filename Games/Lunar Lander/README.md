# Lunar Lander

The goal of this project is to recreate the [Atari game Lunar Lander](https://en.wikipedia.org/wiki/Lunar_Lander), using Box2D and a noise function to produce terrain.

## Noise

Noise functions are useful well beyond terrain generation. To this end, I use the `Noise` folder to create a series of demos, of experiments and playgrounds to showcase how the functions work in the context of Lua and Love2D.

## Design

The game uses [Overpass Mono](https://fonts.google.com/specimen/Overpass+Mono) for its one and only font.

In terms of flow, the game is split in two states, `OrbitState` and `PlatformState`. The goal is to have a more focused, zoomed in version of the initial state as the lander actually approaches the ground level.

Terrain covers the bottom half of the screen. It is created using `love.math.noise` in conjunction with `love.math.random`. As noticed in the `Noise` folder, `love.math.noise` provieds a sequence of random numbers which is too smooth, and the inclusion of `love.math.random` allows to modify the segments to have jagged edges.

Data covers the top half of the screen, displaying the score, time, but also fuel, altitude, horizontal and vertical speed. The information is divided in groups of three, aligning the text to the left. For the speed, the game also uses arrows. While it is possible to create `.png` images for these visuals, the characters ` ↑`,`↓`,`→`, and `←` provide a quick alternative.

## Data

The idea is to display data by passing it to a function. A function which accepts the following arguments:

- keys, a table describing the specific data points by name. This guarantees the order.

- formattingFunctions, a table describing the formatting function, if necessary, for the value described by the key

- startX, startY, two variables describing where the data needs to be displayed

- gapX, gapY, two variables to dictate the gap between key-value pairs and the gap between successive pairs

Most importantly, `data` is made to be a global variable, and it is rendered from `main.lua`. It is then in the individual state where its values are modified.
