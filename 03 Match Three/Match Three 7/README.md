# Match Three 7

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

## Letters

Instead of showing the word as a single string, use a loop to include the letters one at a time.

```lua
for i = 1, #self.title do
  letter = self.title:sub(i, i)

  love.graphics.printf(
    letter,
    -- ??
    )
end
```

For the horizontal position, include an offset on the basis of the current index and number of letters in the input string. This formula was introduced in the `EnterScoreState` from _Breakout_, and the idea is to position the individual letters around the center that is `VIRTUAL_WIDTH / 2`

```lua
for i = 1, #self.title do
  offsetX = (i - (#self.title + 1) / 2) * 26

  love.graphics.printf(
    letter,
    offsetX,
    VIRTUAL_HEIGHT / 6,
    VIRTUAL_WIDTH,
    'center'
    )
end
```

## Colors

To style each letter with a different color, start from a hard-coded list of colors.

```lua
self.colors = {
  [1] = {0.88, 0.34, 0.36, 1},
  [2] = {0.37, 0.8, 0.89, 1},
  [3] = {0.98, 0.94, 0.21, 1},
  [4] = {0.47, 0.25, 0.54, 1},
  [5] = {0.6, 0.89, 0.31, 1},
  [6] = {0.82, 0.48, 0.14, 1}
}
```

From this starting point, the idea is to use a controlling variable, and have it incremented at an interval.

```end
self.color = 1

Timer.every(
  0.08,
  function()
    self.color = self.color % #self.colors + 1
  end
)
```

In this manner, `self.color` is forced to have a value in the `[1, 6]` range. With the timer, then, the color is updated at every iteration.

The color is however and still applied to the letters without distinction. To fix this, add to `self.color` the current index of the loop, making sure to have the value fall in the prescribed range.

```lua
for i = 1, #self.title do
  local color = math.abs(self.color - i) % #self.colors + 1
end
```

## printf

In the `render` function you find multiple instances of the `love.graphics.printf` function, often for the same word/letter. These are included to create a dark shadow.
