# Lunar Lander

Safely land a module on one of the platforms intersposed between jagged surface.

## Prep

The `Prep` folder includes a series of smaller demos to independently work on the game's main features.

### Terrain

The goal is to show how to create uneven, smooth terrain with platforms, relying on the random functions provided by Love2D. The demo plots different lines, leading up to the formula ultimately used in the project:

1. baseline, where the vertical coordinate does not change

2. random, where the `y` coordinate is computed through `love.math.random`. The solution is random, but excessively so

3. noise, where the same value is computed through `love.math.noise`, incrementing the offset passed to the function at each iteration

   ```lua
   love.math.noise(offsetNoise)

   offsetNoise = offsetNoise + offsetIncrement
   ```

   The greater the increment, the more the function resembles `love.math.random`. The smaller the increment, the smoother the change in value. It is worth noting that the function returns the same value for the same offset, which becomes exceedingly useful considering the final line

4. platform, where the line uses `love.math.noise`, but does not increment the offset for a selection of points. In so doing, the vertical coordinate remains the same and the line produces the desired, even surface suitable for a soft landing

   ```lua
   love.math.noise(offsetNoisePlatform)

   if platform then --pseudocode
     offsetNoisePlatform = offsetNoisePlatform + offsetIncrement
   end
   ```

   In practice, the code highlights a platform with a table populated with the points which need to be skipped.

   ```lua
   pointsPlatforms = {
     [3] = true,
     [4] = true,
     -- ...
   }
   ```

Press the left and right arrow keys to move between the different options.

### Box2D Module

The goal is to build a basic Box2D simulation to showcase how the lander should look and behave.
