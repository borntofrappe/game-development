## Noise

The folder explores noise functions with a series of demos. These demos are mostly inspired by [What is Perlin Noise](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6bgPNQAdxQZpJuJCjeOr7VD), a playlist from the YouTube channel [the coding train](https://www.youtube.com/c/TheCodingTrain).

## Random functions

Here I introduce two functions from the `love.math` module:

- `love.math.random()`; returns a random number between `0` and `1`

  In previous games I've always used `math.random` from the `math` library of the Lua language, but there are benefits to use the Love2D alternative. First and foremost, it is not necessary to call `math.randomseed`,

  ```lua
  -- math.randomseed(os.time())
  -- num = math.random()

  num = love.math.random()
  ```

  Love2D provides the seed using `os.time()` behind the scenes, automatically and as `love.load` is executed.

  Without arguments, the value is in the `[0-1]` range, but it is possible to provide a maximum value, or again a range.

- `love.math.noise(x)`; returns a random number between `0` and `1` using a simplex noise function

  It is necessary to specify an argument, `x`, to have the function return different values. This is because fundamentally, noise functions return the same number for the same input. To return a different value, you modify the input itself.

  ```lua
  function love.load()
    x = 0
  end

  function love.update(dt)
    num = love.math.noise(x)
    x = x + 0.1
  end
  ```

  The noise function works by building a sequence of numbers, loosely connected to each other. By modifying the offset `x` you are traversing through this sequence. This means that the greater the offset `x`, the greater the value is different from the previous measure.

In the specific demo, I modify the position of a circle using one of the two functions. By pressing a specific key, the demo is updated to change the function being used, and to also modify the offset used to update the noise function.

## Buzzing bee

The demo considers random movement in both the `x` and `y` dimension, and it works to illustrate how the same noise function can be used for two values and yet show difference in how the values evolve. This is because the `x` and `y` coordinate pick from a different point in the imaginary curve describing the sequence of random numbers.

```lua
bee.x = love.math.noise(offset) * WINDOW_WIDTH
bee.y = love.math.noise(offset + 1000) * WINDOW_HEIGHT
```
