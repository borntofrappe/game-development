# [Picross](https://github.com/borntofrappe/game-development/projects/2)

Create a demo developing the concept of picross, a puzzle game in which the player fills a grid based on the instructions given on the side of each row and column, and in order to draw a stylized picture.

## Topics

- keyboard and touch input, similarly to _Match Three_

- levels based on data, similarly to _Angry Birds_. The idea is to have a table collect the design of the levels through `x`s and `o`s, and have the script create the associated grid at startup

## Levels

As mentioned, the levels are designed with `x`s and `o`s. `Levels.lua` describes these structure using Lua's format for long strings.

```lua
[[
  ooxoo
  ooxoo
  xxxxx
  oxxxo
  oxoxo
]]
```

The only issue with this format comes from the length of the string. You can attest this in the [live environment](https://www.lua.org/cgi-bin/demo) by running the following script:

```lua
level = [[
  ooxoo
  ooxoo
  xxxxx
  oxxxo
  oxoxo
]]

print(level:len()) -- 40
```

The length considers the whitespace and new line characters. This is problematic in the moment you eventually want to build the grid in which the `x`s and `o`s are slotted in rows and columns. One solution I found is to use `gsub`, and replace every character that is not one of the two accepted literals with an empty string.

```lua
level = [[
  ooxoo
  ooxoo
  xxxxx
  oxxxo
  oxoxo
]]
level = string.gsub(level, "[^xo]", "")
print(level:len()) -- 25
```

The sequence `[xo]` matches the two characters, and the circumflex `^` the complement set, meaning anything but the two characters.

_Nifty_: you can achieve a similar result using different [patterns](https://www.lua.org/pil/20.2.html). The following are equivalent in this particular context.

```lua
-- anything that is not a letter
level = string.gsub(level, "%A", "")
-- space characters
level = string.gsub(level, "%s", "")
```
