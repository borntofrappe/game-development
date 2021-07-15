# Angry Birds 5

_Please note_: the progress achieved in previous updates is not carried over, as the goal of this specific demo is to start developing the final game with a state machine, dependencies and graphics.

## StateMachine

The game has only two states: start and play. For the specific update, I decided to add a label to distinguish between the two and to move from one to the other following a specific key/button press:

- press enter or the right button of the mouse pointer to move to the play state

- press escape or the left button of the cursor to move back to the start state

## Quads

The `gFrames` table describes two tables of quads, for the background and the aliens. In `Utils.lua` you find the logic used to section to raster images and build the rectangles of a desired width and height.
