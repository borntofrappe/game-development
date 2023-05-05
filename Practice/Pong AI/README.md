# pong-ai

A "game" of pong where two AI-controlled paddles try to make up for the lost time.

- pick a side to support

- the chosen side receives the ball

- the winner takes double the points if it was **not** chosen

- you win if, by the end of the game, you've chosen the right side more often than not

- game ends at 8

## Dev notes

### window.setMode

- vsync is not a boolean, but a number (0, -1, 1); set to enabled by default (1)

- resizable set to `false` by default
