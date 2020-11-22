# Petri Dish

The goal is to create a game inspired by [agar.io](https://en.wikipedia.org/wiki/Agar.io), where a large particle assimilates neighboring, smaller units by entering into contact with them.

Using `love.math.noise` then, the goal is to animate the cells to avoid a regular circle shape.

## Prep

Before the actual game, I develop a series of demos in dedicated folders.

### Noise

In the `Noise` folder I explore `love.math.noise` with the ultimate goal of building the foundation for the blob-like animation. The folder works as a spiritual successor to `Lunar Lander/Noise`, and discusses noise functions with two arguments.

### Timer

In the `Timer` folder I try to create a small library to manage delays, intervals, and ultimately tween animations. This is a replacement from the code introduced in the CS50 course.

## Design

The game is set to have a single screen, with a larger particle symbolizing the player in the very center of the gaming window. All around this particle, smaller units make up the different, interactable cells.

The idea is to then:

- allow to move the player with arrow keys or the mouse cursor, with a delay and tween animation

- detect a collision between player and surrounding particles

- increase the size of the player considering the structure of the assimilating particles

### Color

Consider the following shades for the color palette.

- rgb(243, 248, 248)
- rgb(102, 227, 248)
- rgb(0, 180, 233)
- rgb(8, 8, 8)

The goal is to have a particle with a dark outline and a brighter, perhaps semi-transparent fill.
