# Snake

Recreate the popular game snake, with a blocky design inspired by the display of a Nokia phone.

## Movement

The snake moves in a grid described by `COLUMNS` and `ROWS`. It does so by using the change described by the constants `DIRECTIONS_CHANGE`.

```lua
DIRECTIONS_CHANGE = {
  ["top"] = {
    ["column"] = 0,
    ["row"] = -1
  },
  ["right"] = {
    ["column"] = 1,
    ["row"] = 0
  },
  ["bottom"] = {
    ["column"] = 0,
    ["row"] = 1
  },
  ["left"] = {
    ["column"] = -1,
    ["row"] = 0
  }
}
```

In short, the idea is to pick a direction, and update the `row`, `column` value of the snake.

What complicates this rather straightforward design is that, as the game progresses, the snake needs to grow in size, and the tail needs to move in the path described by the head. In previous versions, I tried to work around this by adding a `delay` on each successive square describing the tail, and having the tail change direction after crossing the same number of columns or rows. Ultimately however, I realized that a much simpler approach is to have the tail move where the previous square _was_. For the first piece of the tail, then, to move where the head was.

This approach is why the snake updates itself by looping through the `tails` table backwards.

```lua
for i = #self.tail, 1, -1 do
  -- update tail
end
```

It is also why the snake updates itself only after the loop. In the opposite order, the coordinates would be overriden before being used for the first piece of tail.

```lua
for i = #self.tail, 1, -1 do
  -- update tail
end

-- update snake
```

## Tail direction

This is worth noting given the fact that a `direction` is initialized in the `Tail` table, but never used in the table itself.

```lua
function Tail:create(column, row, direction)
  this = {
    -- previous attributes
    direction = direction
  }
end
```

The value proves useful when the tail grows in size, and is indeed used in the `Snake` table. Retrieve a _reference_ to the previous square (the snake or the last existing piece of tail).

```lua
local reference = self.tail[#self.tail] or self
```

Based on the direction, position the new piece in the opposite direction to which the reference is going.

```lua
local direction = reference.direction
local column = reference.column + DIRECTIONS_CHANGE[direction].column * -1
local row = reference.row + DIRECTIONS_CHANGE[direction].row * -1
```

## Fruit spawn

While a piece of fruit is created with the `:create()` function, the two states referencing the table use the `:spawn` method instead. This is necessary to ensure that the fruit doesn't spawn on top of the snake, be it its head or tail. If it were positioned on the head, the overlap would almost be excusable, as the piece of fruit would be immediately removed. On top of the tail however, the square would be hardly recognizable.

To this end, the `:spawn` method takes as argument the snake, and proceeds to create a piece of fruit until said piece doesn't overlap with the tail, nor the head.

## Window, margin and padding

After the game computes the width and height of the gaming window, I've decided to include two variables in `MARGIN` and `PADDING`. The idea is to recreate the look of a phone display, where the window is surrounded by a visible border, and the snake/fruit are separated from said border.

## Secret(s)

The code has a few features which are not publicized in the game itself:

- press `g` to display the grid in which the snake moves and the fruit is positioned

- press `r` to reposition the head of the snake and the fruit. When the snail has a tail, this has a revealing effect where the tail catches up one piece at a time

- hold `c` while pressing enter to preserve the snake and fruit displayed in the screen showing the "Snake" title

With regards to the last point, it is worth noting that the game is fully playable from the title screen, since the direction of the snake is updated directly in the `Snake` table. It is just a tad cumbersome as the snake is updated randomly as well.
