# Lunar Lander

The goal of this project is to recreate the [Atari game Lunar Lander](https://en.wikipedia.org/wiki/Lunar_Lander), using Box2D and a noise function to produce terrain.

## Noise

Noise functions are useful well beyond terrain generation. To this end, I use the `Noise` folder to create a series of demos, of experiments and playgrounds to showcase how these functions work in the context of Lua and Love2D.

_Please note_: the concepts introduced in the folder work as the foundation of the sections which follow.

## Terrain

Terrain is built using `love.math.noise` in conjunction with `love.math.random`. This is because testing the first function I realized the random numbers returned by it were too smooth. To add more jagged edges, I therefore decided to have the smooth numbers incremented by a random amount.
