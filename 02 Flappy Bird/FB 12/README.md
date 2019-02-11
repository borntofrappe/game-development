# Flappy Bird 12 - Mouse

As flappy bird was a mobile game, update 12 sets out to accommodate for input in the form of a click. This through the `love.mousepressed()` function.

From the [docs](https://love2d.org/wiki/love.mousepressed), this function gives the following values:

- `x` and `y`, describing the coordinates of the press;

- `button`, identifying a left, right or middle click (1, 2 or 3);

- `isTouch`, whether the press was originated from a touchscreen press (true or false);

- `presses`, the number of presses in a short time frame (for multiple clicks).

The `x` and `y` coordinates might be the only values needed for the update.

It is essential to track user input in the form of a click, but to react only when the click overlaps with the bird.

Here's how I implemented the feature.

## main.lua

Inspired by the approach taken with `love.keyboard`, and how the lecturer added an empty table of `keyPressed`, I used the global `love.mouse` and added a table to keep track of the coordinates of the mouse.

```lua
love.mouse.coor = {
  ['x'] = 0,
  ['y'] = 0
}
```

These coordinates are updated following a `mousepressed` event.

```lua
function love.mousepressed(x, y)
  love.mouse.coor['x'], love.mouse.coor['y'] = push:toGame(x, y)
end
```

Essentially, they are updated through the `push:toGame` function. This is because the screen is projected through the push library, and the bird coordinates refer to virtual coordinates. Mouse coordinates on the other hand, refer to the real dimensions of the window. This function allows to turn real dimensions into the appropriate values for the pushed resolution.

Finally in the `update(dt)` function, the coordinate are set back to 0. This is a rather imperfect fix, but as the bird is always stuck in the center of the screen, the risk of an overlap is avoided.

```lua
love.mouse.coor['x'], love.mouse.coor['y'] = 0, 0
```

## bird.lua

It is in `bird.lua` that the coordinates are then accessed and used. They are considered in the `update(dt)` function and implement the same 'jump' following a press on the space key.

```lua
if love.mouse.coor['x'] > self.x - 5 and love.mouse.coor['x'] < self.x + self.width + 5 then
  if love.mouse.coor['y'] > self.y - 5 and love.mouse.coor['y'] < self.y + self.height + 5 then
    -- play the matching audio
    sounds['jump']:play()
    self.dy = -7
  end
end
```

Here we make sure to make the bird 'jump' when the mouse falls within the area represented by teh bird, minus plus 5 pixels to give a bit of leeway (with an actual mouse it is rather tricky to click it, but with a touchpress it might be easier).
