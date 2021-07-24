# Picross

A puzzle game in which the player fills a grid based on the instructions given on the side of the rows and columns. The goal is to ultimately draw a stylized picture based on the pixelated structure.

![Picross](https://github.com/borntofrappe/game-development/blob/master/Showcase/picross.gif)

## Resources

The `res` folder includes the static assets used in the game, and also `Timer.lua`, a small library I created to manage time events.

## Levels

The levels are designed with `x`s and `o`s, using Lua's format for long strings.

```lua
local grid = [[
xxoxx
xxoxx
ooooo
xooox
xoxox
]]
```

The whitespace helps to draw the level, giving a first idea of the structure of the columns and rows. In the development of the level, however, the same whitespace becomes superfluous, and is removed with the `gsub` function from the string library. It is here possible to consider several sequences to remove the whitespace, but one of the most straightforward is to actually remove any character that does not match the prescribed `x`s and `o`s.

```lua
string.gsub(grid, '[^xo]', '')
```

Note that it is equally possible to use the function on the string through the semicolon operator.

```lua
grid:gsub('[^xo]', '')
```

`gsub` returns the string with the desired replacement and the number of replacements as a second argument. This last value actually helps to describe the dimensions of the grid.

```lua
grid:gsub('[^xo]', '') -- xxoxxxx... 5
```

Keep in mind that lua ignores the first character when this is a new line character.

The `Levels` class builds the grid by populating a table, and specifically looping through the string and considering the letter at a specific index.

```lua
for row = 1, dimension do
    for column = 1, dimension do
      local index = column + (row - 1) * dimension
      local state = sequence:sub(index, index)
  end
end
```

## Hints

The `Level` class is devoted to the cells making up the level. In the play state, then, it is helpful to garnish the visual with additional, extra elements:

- a solid background

- grid lines

- hints on the columns and rows

The hints are built from the level, looping through the grid and considering the state of the individual cells.

```lua
local hints = {
  ["columns"] = {},
  ["rows"] = {}
}

for row = 1, self.dimension do
    for column = 1, self.dimension do

  end
end
```

The tables are populated considering the state to highlight the number of continguous `o`s. The hints are then positioned at the side of the level considering the size of the cell.

The tables do include a `0` by default, but the value is removed if there are hints.

## Input

The game can be played with keyboard or a mouse cursor.

With keyboard, it is possible to move between states by pressing the `escape` and `enter` key, toggle the tool with the `tab` or `space` key, choose the pen or eraser with the `p` and `e` key respectively and populate the grid again with the `enter` key.

With a mouse pointer, it is enough to press the different visuals to move onwards, select the tool and populate the grid. To move backwards, the game includes a "back" button in the top left corner. The visual is conditioned to a boolean `gMouseInput`, so that the button is included only when the game is played with a mouse, and not with a keyboard.
