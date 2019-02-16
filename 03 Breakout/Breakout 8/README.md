# Breakout 8 - Particles

This is quite the entertaining and challenging update: when a brick gets hit, introduce a puff of smoke animating the collision.

Animations like a puff of smoke or the flame of a fire can be created through **particle systems**. The idea is to spawn a series of particles, like the ones available in `particle.png`, and animate their introduction, their movement to fake the appearance of a desired effect. In the instance of the project at hand, the idea is to introduce a multitude of particles and let them fade as gravity pulls them downwards from the position of the affected brick.

For particles systems, love2D provides a function in `love.graphics.newParticleSystem`. It takes as argument:

- texture, like the one mentioned in `particle.png`;

- particles, the maximum number of particles to emit.

Based on these values, and logic specified throughout the `update(dt)` function, particles are introduced and animated to obtain the desired effect.

## Brick.lua

Before initializing the `Brick` class, introduce a variable describing the color palette used by the particle system. For an extremely apt effect, the idea is to have the puff of smoke match the color of the brick being hit.

```lua
-- introduce a table describing the possible colors used in the particle system. match the order of the bricks.
colorPalette = {
  -- each table contains three values for the red, green, blue component of the color
  [1] = {
    ['r'] = 99/255,
    ['g'] = 155/255,
    ['b'] = 255/255
  },
  [2] = {
    ['r'] = 106/255,
    ['g'] = 190/255,
    ['b'] = 47/255
  },
  [3] = {
    ['r'] = 217/255,
    ['g'] = 87/255,
    ['b'] = 99/255
  },
  [4] = {
    ['r'] = 215/255,
    ['g'] = 123/255,
    ['b'] = 186/255
  },
  [5] = {
    ['r'] = 251/255,
    ['g'] = 242/255,
    ['b'] = 54/255
  }
}
```

Remember that with the most recent version of love2D colors are described with a [0-1] range, and no longer through the [0-255] range explained in the course.

In the `init()` function, initialize the particle system using the mentioned function.

```lua
function Brick:init()
  -- previous code

  -- create a particle system using the texture of the particle
  self.particleSystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

end
```

This allows to take the texture as provided in the global variable and create a particle system around 64 copies of that image.

On its own the particle system achieves very little though. Always in the `init()` function, define a few options regarding the system. [The docs](https://love2d.org/wiki/ParticleSystem) have plenty of functions to customize one's solution, but here focus on:

- how much the particles need to stay on page, through the `setParticleLifetime` function;

- how the particles move from their point of origin, through the `setLinearAcceleration` function;

- the area in which the particles are made to move, through the `setEmissionArea` function. `setAreaSpread` is actually deprecated in favor of this new method.

```lua
function Brick:init()
  -- previous code

  -- create a particle system using the texture of the particle
  self.particleSystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

  --[[ shorten the lifetime of the particles
    arguments:
    - min
    - max
    both representing the time in seconds
  ]]
  self.particleSystem:setParticleLifetime(0.3, 1)

  --[[ accelrate the particles
    arguments:
    - xmin
    - ymin
    - xmax
    - ymax
    horizontally around the the origin of the system
    vertically downwards
  ]]
  self.particleSystem:setLinearAcceleration(-15, 0, 15, 80)

  --[[ describe the area affected by the particle
    arguments
    - distribution
    - dx
    - dy
    distribution is a type
    dx and dy the maximum spawn ditance from the source of origin
  ]]
  self.particleSystem:setEmissionArea('normal', 10, 10)
end
```

In the `hit()` function, set the colors of the particle system through the `:setColors()` function and use the `:emit()` function to ultimately have the animation play out.

```lua
function Brick:hit()
  --[[ set the colors of the particle system according to the brick's own color
    arguments:
    - r
    - g
    - b
    - a

    and once more
    - r
    - g
    - b
    - a

    the particle system interpolates from quadruple to quadruple (up to 8 groupings)
    in the specific instance, it goes from semi transparent to completely transparent particles
  ]]

  self.particleSystem:setColors(
    colorPalette[self.color]['r'],
    colorPalette[self.color]['g'],
    colorPalette[self.color]['b'],
    -- slightly more opaque values for higher tiers
    0.2 + 0.1 * self.tier,
    colorPalette[self.color]['r'],
    colorPalette[self.color]['g'],
    colorPalette[self.color]['b'],
    0
  )

  --[[ play the animation provided by the particle system
    argument:
    - the number of particles being emitted
  ]]
  self.particleSystem:emit(64)

  -- logic for the brick being hit
end
```

This takes care of setting up the particle system. The particles are created and readied to be introduced. It is however necessary, as specified in [the docs](https://love2d.org/wiki/ParticleSystem), to **update** the particle system in the `update(dt)` function in which they are used.

```lua
function Brick:update(dt)
  self.particleSystem:update(dt)
end
```

Finally, with regards to `Brick.lua`, the particle system needs to be drawn on the screen. Once more [the docs](https://love2d.org/wiki/ParticleSystem) relate how the `love.graphics.draw` function can be used for a particle system as well (this one being a drawable).

In `Brick.lua`, declare a `:rendeerParticles()` function exactly drawing the particles on the screen. For the coordinates use the coordinate of the calling object, a brick, and specifically position the particles in the center of said object.

```lua
-- in the :renderParticles() function draw the particles on the center of the brick calling it
function Brick:renderParticles()
  love.graphics.draw(self.particleSystem, self.x + 16, self.y + 8)
end
```

## PlayState.lua

The code explained so far helps setting up a particle system and describing its behavior. It also provides the `renderParticles` function to actually draw the particles on the screen.

Without input from the `PlayState` however, the particle system is relegated to just being set up, not played out.

- in the `update(dt)` function, specify on each brick that it shoud be updated. I set it up in the for loop later checking for collision, but it can also be the subject of a separate for loop. The important thing is that the function needs to be fired in the `update(dt)` method.

  ```lua
  for k, brick in pairs(self.bricks) do
    -- update the brick (mainly the particle system of the brick)
    brick:update(dt)
    -- check for collision
  end
  ```

- finally and in the `render()` function, render the particles through the specified function, `renderParticles`. You can ahieve this in the for loop already rendering the bricks.

```lua
for k, brick in pairs(self.bricks) do
  brick:render()
  -- render also the particles connected to each brick (and positioned at its center)
  brick:renderParticles()
end
```

If it sounds complex, it's because at first it is. The code in the `PlayState` is rather understandable though. Think of the particles just as another asses, like a brick, a ball. In the state class using it, update and render such asset through the matching `update(dt)` and `render()` functions.
