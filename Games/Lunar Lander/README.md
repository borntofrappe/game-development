# Lunar Lander

The goal of this project is to recreate the [Atari game Lunar Lander](https://en.wikipedia.org/wiki/Lunar_Lander), using Box2D and a noise function to produce terrain.

## Noise

Noise functions are useful well beyond terrain generation. To this end, I use the `Noise` folder to create a series of demos, of experiments and playgrounds to showcase how these functions work in the context of Lua and Love2D.

_Please note_: the concepts introduced in the folder work as the foundation of the sections which follow.

## Design

The game uses [Syne Mono](https://fonts.google.com/specimen/Syne+Mono) for its one and only font.

In terms of flow, there are two main screens, which can be summarised by the states `OrbitState` and `PlatformState`. The goal is to have a more focused, zoomed in version as the lunar lander actually approaches the ground level.

Terrain covers the bottom half of the screen, while the top is devoted to information connected to the game's data:

- score

- time

- fuel

- altitude

- horizontal speed

- vertical speed

The information is divided in groups of three, aligning the text to the left. For the speed, the game also uses arrows. While it is possible to draw an icon for these visuals, the characters ` ↑`,`↓`,`→`, and `←` provide a quick alternative

Terrain is built using `love.math.noise` in conjunction with `love.math.random`. As noticed in the `Noise` folder, `love.math.noise` provieds a sequence of random numbers which is too smooth, and the inclusion of `love.math.random` allows to modify the segments to have jagged edges.
