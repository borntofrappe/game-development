# Lunar Lander

Safely land a module on one of the platforms interspersed in the jagged terrain.

![Lunar Lander in a few frames](https://github.com/borntofrappe/game-development/blob/main/Practice/Lunar%20Lander/lunar-lander.gif)

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

The different parts of the lander are then attached to the body, individually with a shape and fixture each.

```lua
lander.core = {}
lander.core.shape = love.physics.newCircleShape(10)
lander.core.fixture = love.physics.newFixture(lander.body, lander.core.shape)
```

The same sequence is repeated for the portions describing the landing gear and the thrusters shown when the arrow keys are actively being pressed. These last objects are however made into sensors, so that Box2D ignores them when considering a collision.

```lua
thruster.fixture:setSensor(true)
```

In terms of physics, the demo tries to update the position of the lander with a small force of gravity. When pressing the up arrow key, the idea is to then move the lander upwards. This last action is achieved in two layers: immediately with a linear impulse.

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

For the left and right arrow key the same two-step sequence is repeated to modify the horizontal movement.

## Game

The game builds on the logic introduced in the `Prep` folder to have a functional demo split in four states:

- `StartState` introduces the title of the game as well as the terrain on which the player will need to land

- `PlayState` is where most of the game takes place, where the lander moves subject to gravity and the impulses, velocities applied through the arrow keys. It is here essential to detect a collision between lander and terrain to ultimately decide the fate of the lander module

- `LandState` describes a successfull landing, shows a congratulatory message and updates the score according to the altitude

- `CrashState` shows a series of particles from the point of contact together with a half-deprecating message

The game moves between the land and crash state to the play state by pressing the enter key, or back to the start state by pressing the escape key.

The different `.lua` scripts incorporate several features, highlighted here for posterity.

### Terrain

Just like the demo in the `Prep` folder the terrain is created with a series of points with a varying `y` coordinate. This measure is picked with `love.math.noise`, but also `love.math.random`. Without the purely random value, and relying only on the offset passed to the noise function, I feel the terrain tends to be excessively jagged or excessively smooth.

The function generating the points also returns a second table to describe the horizontal coordinates of the platforms, where they start and where they end. The sequence is exceedingly useful in order to have a safe landing only on the flat surfaces, and not just according to the horizontal and vertical velocity.

### Classes

`Lander` and `Terrain` are defined to contain the instructions necessary to set up and render the world's objects. I've chosen to modify the objects directly from the different states, but it is equally possible to define new functions to delegate the necessary behavior. For instance, `Lander:applyLinearImpulse` can be defined to have the class itself modify the position of the object through `self.body` (instead of `self.lander.body`).

### Collision Callback

The start state includes a basic simulation to have the title move following the position of a hidden, dynamic object. When the object collides with a line describing where the title should stop, the game shows the subtitle and allows to move to the play state. When this happens, notice how `setCallbacks()` is called again, without arguments.

```lua
if userData["sensor"] and userData["threshold"] then
  gWorld:setCallbacks()
end
```

This helps to ensure that the collision is detected only once. It also helps to avoid states react to the callbacks set elsewhere.

### Destroy

In a similar vein to the previous sections, the different states need to "clean up" the world from the objects which are no longer necessary. This describes both the lander, for instance when moving to the play to the crash state, and to the terrain.

### Data

The code in `Data.lua` tries to include the different metrics on either sie of the window. With a rather tentative approach, `string.format` allows to immediately format the values, and then the string with enough whitespace to maintain a consistent look and feel.

Notice that the script is plentiful in terms of "magic numbers", set to have the particular configuration work.

```lua
string.format("Score% 8s", formattedValue)
string.format("Time% 9s", formattedValue)
```

The number of whitespace included between the label and the corresponding value should chance according to the number of characters before the value, but I ended up hard-coding the integers instead of automating the process.
