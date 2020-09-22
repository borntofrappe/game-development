# Snake

Recreate the popular game starting with shapes from the `love.graphics` module.

## State

The idea is to have the game divided in two stages, one showing the title, and one dedicated to actually playing the game.

In the title screen, however, I still plan to include the snake, perhaps even a dumbed down version of the game, played by the computer instead of following user input.

## Direction

The idea is to update the position of the snake with two variables `dx` and `dy`. Moreover, the idea is to update these values through `direction`, picking the `dx` and `dy` values from a table of prefefined instructions.

```lua
CELL_DIRECTIONS_SPEED = {
  ["top"] = {
    x = 0,
    y = -1
  },
  ["right"] = {
    x = 1,
    y = 0
  },
  ["bottom"] = {
    x = 0,
    y = 1
  },
  ["left"] = {
    x = -1,
    y = 0
  }
}
```

## Visual debugging

I decided to add helper structures like the `renderGrid` function. With this one, the idea is to draw a series of lines to show the potential movement of the snake, in a pixelated matrix of `CELL_SIZE` width and height.

Helper functions like `renderGrid` allow to have a visual as to how the game behaves, and a way to check that the snake doesn't move outside of the intended tracks.
