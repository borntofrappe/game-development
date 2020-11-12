# Noise

The folder explores noise functions with a series of demos. These demos are mostly inspired by [What is Perlin Noise](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6bgPNQAdxQZpJuJCjeOr7VD), a playlist from the YouTube channel [the coding train](https://www.youtube.com/c/TheCodingTrain) describing noise functions starting from Perlin noise and in the context of the library p5.js.

Think of a function, which maps points through time and according through their value. The value describes the function's amplitude, and the distance between maximum and minimum points shows the function's frequency. A Perlin function works by creating random functions with different amplitude and frequency, and by considering the sum of said functions. By overlapping gentler, smoother curves with more jagged, changing patterns it provides a sequence of number which are random, and yet connected to one another. This is why the function ultimately expects an argument, `x`.

```js
noise(x);
```

The idea is to provide a number at a specific offset. To find a different number then, you modify the offset value. Considering how the function is built, the greater the change, the greater the difference between numbers. A smaller change results in having two numbers closely resembling one another, and this is ultimately how you achieve smooth randomness.

_Please note_: Love2D works with a Simplex noise function, which seems to be the answer to issues existing with the Perlin variant. The way smooth randomness is achieved is still the same, by passing an offset to the noise function.

## Random functions

Here I introduce two functions from the `love.math` module:

- `love.math.random()`; returns a random number between `0` and `1`

  The function works similarly to `math.random()`, the method available from the `math` library and in the Lua language. Conveniently, it sets a random seed behind the scenes, and using `os.time()`. It it therefore not necessary to set the seed at run time.

  ```lua
  -- math.randomseed(os.time())
  -- num = math.random()

  num = love.math.random()
  ```

  Without arguments, the value is in the `[0-1]` range, but it is possible to provide a maximum value, or again a range. For the purpose of the demo, it is used without arguments to show the similarities with the noise function.

- `love.math.noise(x)`; returns a random number between `0` and `1` and using a simplex noise function

  As detailed earlier, it is necessary to specify an argument to have the function return different values.

  ```lua
  function love.load()
    x = 0
  end

  function love.update(dt)
    num = love.math.noise(x)
    x = x + 0.1
  end
  ```

In the specific demo, I modify the position of a circle using one of the two functions. By pressing a specific key, the coordinate is updated to change the function being used, and to also modify the offset used to update the noise function.

_Please note_: with the demo I also set up a timer. This is helpful to have the circle updated less frequently.

## Buzzing bee

The demo considers random movement in both the `x` and `y` dimension. The project is also useful to illustrate how the same noise function can be used for two values and yet produce different measures, by picking the values from the same noise function, but using a different offset.

```lua
bee.x = love.math.noise(offset) * WINDOW_WIDTH
bee.y = love.math.noise(offset + OFFSET_DISTANCE) * WINDOW_HEIGHT
```

## Noise graph

The demo populates a table with a series of points. These are meant to describe a line stretching to cover the entirety of the gaming window, and changing in their `y` coordinate according to a noise function.

```lua
points = {}
for i = 0, numberPoints do
  table.insert(points, i * (WINDOW_WIDTH / numberPoints))
  table.insert(points, WINDOW_HEIGHT * 3 / 8 + love.math.noise(offset) * WINDOW_HEIGHT / 4)
  offset = offset + offsetIncrement
end
```

`love.graphics.line` is able to draw a line based on a table of points, which explains why the coordinates are included in pairs directly in the table.

By pressing the arrow keys, the demo updates the number of points (left or right), or again the increment to the noise function (up or down).

It is worth highlighting the variable `offsetStart`. This one is initialized with a random value in `love.load`, and it is then used to determine the first value of `offset`.

```lua
function love.load()
  offsetStart = love.math.random(1000)
end

function love.update(dt)
  offset = offsetStart
end
```

After each iteration computing the points, it is finally updated with the increment variable.

```lua
function love.update(dt)
  offset = offsetStart
  for i = 0, numberPoints
    -- add x, y points
  end
  offsetStart = offsetStart + offsetIncrement
end
```

The end result is that the line is seemingly moving to the right. In reality, each point considers the coordinates of the point coming after it. Remember that `love.math.noise` returns the same number for the same input value.

## 2D Noise

_Please note_: the demo exceeds the scope of the game _Lunar Lander_, but is included to illustrate how `love.math.noise` accepts multiple arguments.

The demo creates a noise field by passing two arguments to `love.math.noise`.

`makeGrid` builds a two-dimensional table in which each individual cell describes a number in the `[0,1]` range, with the goal of using the value for the alpha channel of a black rectangle.

```lua
grid = {}
for x = 1, WINDOW_WIDTH + 1 do
  grid[x] = {}
  for y = 1, WINDOW_HEIGHT + 1 do
    grid[x][y] = love.math.noise(???, ???)
  end
end
```

The arguments describe the offset in the `x` and `y` dimension, and are updated according to the specific loop:

- in the innermost loop update `offsetY`

  ```lua
  for y = 1, WINDOW_HEIGHT + 1 do
    offsetY = offsetY + increment
  end
  ```

- in the outer loop increment `offsetX`

  ```lua
  for x = 1, WINDOW_WIDTH + 1 do
    for y = 1, WINDOW_HEIGHT + 1 do
    end
    offsetX = offsetX + increment
  end
  ```

This works, but creates a connection between rows. For each column, it is necessary to reset `offsetY`, so that the first cell in the new column is connected to the last cell of the column coming before it.

```lua
for x = 1, WINDOW_WIDTH + 1 do
  offsetY = 0
end
```
