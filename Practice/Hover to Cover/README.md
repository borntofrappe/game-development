# Hover to Cover

Avoid incoming debris by hovering a spaceship vertically.

## Resources

In the `res` folder you find a few images I created with GIMP for the demo.

## Gameplay

The debris should spawn at a different vertical coordinate from the existing pieces. With some semblance of AI, the vertical coordinate of the shapeship should also be considered, so to force the player to change the vertical coordinate.

## Particles

From Breakout 9, the game sets up a particle system with a dedicated class. The system spaws a series of particles from `particle.png` below the spaceship, and as the player instructs the spaceship to move upwards.
