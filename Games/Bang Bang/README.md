# Bang Bang

The goal is to recreate the Windows 3 game Bangbang, where two players fire cannon balls with the goal of hitting the opposing sides.

## Prep

In dedicated folders I develop the building blocks for the final project.

- `Terrain` explores how to render the game's terrain and cannoball holes

- `Physics` considers projectile motion and the rules governing the game

## res

The `.png` images in the `res` folder are designed with GIMP, to have solid, black shapes above a texture visualizing scrapped paper.

- `cannonball` describes a circle with a radius of `27` pixels

- `cannon` provides three pieces to build the cannons for both sides.

  Each piece is sized `42*92`, and the second/third sprites are meant to describe the body of the left/right cannon respectively. This piece is drawn behind the first sprite, and is meant to be rotated from the bottom center. Consider turning the shape from `(21,64)`

## Resources

- [Gameplay footage](https://www.youtube.com/watch?v=Y89ByQPqODk)
