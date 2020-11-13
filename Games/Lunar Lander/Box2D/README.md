# Box2D

The folder illustrates the different components of the eventual game _Lunar Lander_. Dedicating a specific environment for these elements allows to experiment with the physics library.

## ChainShape — Terrain

The demo considers the `makeTerrain` function developed for the game in the `src/Utils`. This one is however modified so that the `y` coordinates describe the height with a negative value. This is beceuse the body making up the terrain is already positioned at the bottom of the window.

```lua
love.physics.newBody(world, 0, WINDOW_HEIGHT)
```

To build the terrain in the Box2D world, the script uses a chain shape, passing the points to the `newChainShape` function.

```lua
local points = makeTerrain()
terrain.shape = love.physics.newChainShape(false, points)
```

This works, but has the unfortumate result of having a line connecting the first and last points. To fix this, I decided to add two additional points, describing the outline of the gaming window.

Bottom right corner.

```lua
table.insert(points, WINDOW_WIDTH)
table.insert(points, 0)
```

Bottom left corner.

```lua
table.insert(points, 0)
table.insert(points, 0)
```

To illustrate that the demo works, the game adds circle objects through a dedicated function. The code is borrowed here from the `Box2D Demos` folder, and specifically the `Dynamic particles` demo.

## Complex shape — Lander

The demo builds the lander by tying a series of shapes together. These shapes are attached to the same body, which is ultimately how box2D is able to wrangle the lander's physics, gravity, forces and collision detection.

The lander is made of:

- a circle making the lander's body, or its core if you will

- two polygons to make the lander's feet, or again landing gear

- a rectangle connecting the two polygons

The rectangle is stored in the same table as the polygons, as they fundamentally describe the same structure. Moreover, both the polygons and the rectangles can be rendered through `love.graphics.polygon`.

```lua
for i, gear in ipairs(lander.landingGear) do
  love.graphics.polygon("line", lander.body:getWorldPoints(gear.shape:getPoints()))
end
```

Specific to the demo:

- in order to make the lander collide with restitution, it is necessary to add such a value to the individual fixtures

  ```lua
  lander.landingGear[1].fixture:setRestitution(0.5)
  lander.landingGear[2].fixture:setRestitution(0.5)
  ```

  This is not necessary in the actual game, but it's a helpful reminder to highlight how fixtures work.

- setting a fixture to be a sensor provides a minor improvement, but is more generally good practice when a particular fixture doesn't need to cause a collision

  Case in point, the rectangle connecting the two polygons, which is purely aesthetical.

  ```lua
  lander.landingGear[3].fixture:setSensor(true)
  ```

Finally, pressing the letter `r` has the body reset to its original position. Pressing the letter `p` toggles the update function so that the lander is paused midair. This allows to show the lander sans motion.

## Physics — World and Lander

For the world, the gravity picks up the value registered on the moon satellite. This gravity is however scaled by a factor of `10`

```lua
METER = 10
GRAVITY = 1.62

function love.load()
  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * METER, true)
end
```

The meter seems to provide a subtle enough force for the window itself `500` pixels tall.

For the lander, as one of the prescribed arrow keys is pressed, the game applies an impulse in the desired direction.

```lua
if key == "up" then
  lander.body:applyLinearImpulse(0, -IMPULSE)
end
```

As the arrow key is continuously being pressed, the game applies then a force.

```lua
function love.update(dt)
  if love.keyboard.isDown("up") then
    lander.body:applyForce(0, -VELOCITY)
  end
end
```

This is in line with the suggestion described [in the wiki](https://love2d.org/wiki/Body:applyForce). The force has a minor influence, which is felt as it is continuously applied in `love.update(dt)`.

As the keys are being pressed, `love.draw` finally renders a series of polygons as a helper visual, a signifier for the body being subject to a force.
