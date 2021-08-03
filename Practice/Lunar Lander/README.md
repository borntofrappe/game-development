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

The goal is to build a basic Box2D simulation to showcase how the lander should look and behave. The object has one body.

```lua
lander.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
```

The different parts of the lander are then attached to the body, individually through a shape and fixture.

```lua
lander.core = {}
lander.core.shape = love.physics.newCircleShape(10)
lander.core.fixture = love.physics.newFixture(lander.body, lander.core.shape)
```

The same sequence is repeated for the portions describing the landing gear, and also the thrusters shown when the arrow keys are actively being pressed. These last objects are however made into sensors, so that Box2D ignores them when considering a collision.

```lua
thruster.fixture:setSensor(true)
```

In terms of world simulation, the demo attempts at updating the position of the lander as subject to a small force of gravity. When pressing the up arrow key, the idea is to then move the lander upwards. This last action is achieved in two layers: immediately with a linear impulse.

```lua
if key == "up" then
  lander.body:applyLinearImpulse(0, -IMPULSE)
end
```

The action is conditioned to a single key press. Then continuously by applying a force.

```lua
function love.update(dt)
  if love.keyboard.isDown("up") then
    lander.body:applyForce(0, -VELOCITY)
  end
end
```

The force is applied as long as the key keeps being pressed.

For the left and right arrow key the same logic is applied to the horizontal movement.
