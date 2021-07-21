# Picross

Develop the basics of the game picross, a puzzle game in which the player fills a grid based on the instructions given on the side of the rows and columns of a square. The goal is to ultimately draw a stylized picture based on the pixelated structure.

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

The whitespace helps to create the level, giving a first idea of the structure of the columns and rows. In the development of the level, however, the same whitespace becomes superfluous, and is removed with the `gsub` function from the string library. It is here possible to consider several sequences to remove the whitespace, but one of the most straightforward is to actually remove any character that does not match the prescribed `x` and `o`.

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

## Level

The class builds the grid starting from the long string introduced in the previous section. From this starting point, the idea is to populate a table detailing the grid structure.

The grid is built looping through the string and considering the letter at a specific index.

```lua
local index = column + (row - 1) * dimension
```
