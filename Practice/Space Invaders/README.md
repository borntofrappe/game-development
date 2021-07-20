# Space Invaders

The goal is to recreate the game <i>Space Invaders</i> while practicing with the concept of a state machine and a timer library.

## Resources

In the `res` folder I include the static assets used in the project, including `spritesheet.png`, which I created to describe the player and aliens, and `Timer.lua`, which I documented in the `Utils` folder as an alternative library to that introduced in the course.

_Please note:_ at the time of writing the timer library is actually different from that in the `Utils` folder, as I've modified the code following the progress made with <i>Space Debris</i>.

## Collisions

Different types, but sharing the `inPlay` boolean and feature.

Consider that the x,y coordinates describe the top left corner.

## Pause

Either you remove the interval and re-initialize the timer function altogether. Or, as I've chosen, just stop updating the timer library.
