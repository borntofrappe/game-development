# Space Invaders

The goal is to recreate the game <i>Space Invaders</i> while practicing with the concept of a state machine and a timer library.

## Resources

In the `res` folder I include the stat ic assets used in the project, including `spritesheet.png`, which I created to describe the player and aliens, and `Timer.lua`, which I documented in the `Utils` folder as an alternative library to that introduced in the course.

## Collisions

Different types, but sharing the `inPlay` boolean and feature.

Consider that the x,y coordinates describe the top left corner.

## Pause

Either you remove the interval and re-initialize the timer function altogether. Or, as I've chosen, just stop updating the timer library.
