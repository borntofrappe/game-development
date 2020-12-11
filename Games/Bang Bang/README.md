# Bang Bang

The goal is to create a shooting game inspired by the [Windows 3 game BangBang](<(https://www.youtube.com/watch?v=Y89ByQPqODk)>), but with one player instead of two. The idea is create consider projectile motion to have a cannon throw a cannonball toward a target, and have this target separated from the player by a hill.

## Prep

In dedicated folders I develop the building blocks for the final project.

- `Terrain` explores how to render the game's terrain and cannoball holes

- `Physics` considers projectile motion and the rules governing the game

## res

The game adopts a choppy art style inspired by the font [Arbutus](https://fonts.google.com/specimen/Arbutus).

In the `graphics` folder you find several images created with GIMP. While `cannon` is designed as a spritesheet, with the goal of rendering the body of the cannon above the small pedestal by using quads, the other assets are created as one-off images.

Finally, and in the `lib` folder, you find `Timer.lua`. This is a utility I first designed for _Petri Dish_, with the goal of providing a basic API for time-based events (delays, intervals, tweens).

## gui

The `gui` folder describes a few classes to build the menu considering mouse input. The menu also works as a signifier when using the keyboard by highlight the angle and velocity attributed to the cannon.

While `Panel` and `Label` are quite self-explanatory, and work to render the outline of a rectangle and a text label, `Button` is more complicated, and includes a few lines in the `update` function to execute some code if the mouse is pressed within the boundaries of the button itself

`Menu` works then as a wrapper for the different labels and buttons.

## Collision

In the `Level.lua`, the game considers whether or not the cannonball collides with the terrain. Only when the ball reaches the terrain, however, the script continues to evaluate an overlap between cannonball and target/cannon. The idea is to destroy both elements by checking the `x` coordinate only, and modify the terrain only if neither is destroyed.
