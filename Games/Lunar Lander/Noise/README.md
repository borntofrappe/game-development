# Noise

The folder explores noise functions with a series of demos. These demos are mostly inspired by [What is Perlin Noise](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6bgPNQAdxQZpJuJCjeOr7VD), a playlist from the YouTube channel [the coding train](https://www.youtube.com/c/TheCodingTrain) describing noise functions starting from Perlin noise and in the context of the library p5.js.

Think of a function, which maps points through time and according through their value. The value describes the function's amplitude, and the distance between maximum and minimum points shows the function's frequency. A Perlin function works by creating random functions with different amplitude and frequency, and by considering the sum of said functions. By overlapping gentler, smoother curves with more jagged, changing patterns it provides a sequence of number which are random, and yet connected to one another.

```js
noise(x);
```

This is why the function ultimately expects an argument, `x`. The idea is to provide a number at a specific offset. To find a different number then, you modify the offset value. Considering how the function is built, the greater the change, the greater the difference between numbers. A smaller change results in having two numbers closely resembling one another, and this is ultimately how you achieve smooth randomness.

`love.math.noise()` seems to implement different noise functions depending on the number of input arguments, but the logic is the same. With one argument, for instance, it uses a simplex noise function to provide an effect similar to that illustrated for the Perlin function.

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

_Please note_: with the demo I also set up a timer. This is helpful to slow down the rate of change.

## Buzzing bee

The demo builds on top of the progress achieved with the `Random functions` folder, and considers random movement in both the `x` and `y` dimension. Tthe project is also useful to illustrate how the same noise function can be used for two values and yet produce different measures. The idea is to pick the values from the same fnoise function, but using a different offset.

```lua
bee.x = love.math.noise(offset) * WINDOW_WIDTH
bee.y = love.math.noise(offset + 1000) * WINDOW_HEIGHT
```
