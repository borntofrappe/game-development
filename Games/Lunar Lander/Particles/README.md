# Particles

Following the [documentation for ParticleSystem](https://love2d.org/wiki/ParticleSystem), the folder sets out to explore how particles are able to visualize the possible crash of the lunar lander.

## ParticleSystem

The demo shows the functions necessary to set up the most basic particle system.

A particle system relies on a series of foundational functions, well documented in the wiki and repeated here in the context of the specific demo.

- [`newParticleSystem`](https://love2d.org/wiki/love.graphics.newParticleSystem)

  The function is necessary to initialize the particle system. It accepts two arguments, in an `image` and `buffer`.

  `image` describes a `png` image for the individual particle, while `buffer` details the maximum number of particles emitted at the same time.

  ```lua
  particleSystem = love.graphics.newParticleSystem(particleImage, 200)
  ```

- [`update`](https://love2d.org/wiki/ParticleSystem:update)

  The function manages the update logic of the particles, which are made appeared and disappeared.

  ```lua
  particleSystem:update(dt)
  ```

- `love.graphics.draw`

  The function draws images, textures, quads, but also particle systems.

  ```lua
  love.graphics.draw(particleSystem, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  ```

- [`setParticleLifetime`](https://love2d.org/wiki/ParticleSystem:setParticleLifetime)

  In order to have the particles appear and disappear, the function specifies the minimum and maximum life span for an individual particle.

  ```lua
  particleSystem:setParticleLifetime(0.2, 0.5)
  ```

- [`setEmissionRate`](https://love2d.org/wiki/ParticleSystem:setEmissionRate)

  The function describes the number of particles emitted in a second.

  ```lua
  particleSystem:setEmissionRate(100)
  ```

- [`setEmissionArea`](https://love2d.org/wiki/ParticleSystem:setEmissionArea)

  To avoid showing the particles in the same point, the function describes the area in which to show the particles. It accepts an argument to specify the type of `distribution`, as well as values to define the area.

  ```lua
  particleSystem:setEmissionArea("uniform", WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  ```

The end result is that the particles are shown in the entirety of the gaming window, appearing and disappearing continuously.

## ParticleSystem — Emit

The demo adds functionality in terms of the `love.mousepressed` function, with the goal of emitting a series of particles on click, and exactly at the coordinates specified by the mouse cursor.

In so doing, it explores a series of helpfyl functions. These do not cover the possibilities provided by the particle system, but in the context of the lunar lander, they provide a satisfactory, if not pleasing, result.

- [`emit`](https://love2d.org/wiki/ParticleSystem:emit)

  Instead of constantly emitting particles, as in the first demo, `emit` allows to spawn a burst of particles in a specific moment in time.

  Case in point, when the cursor is pressed.

  ```lua
  function love.mousepressed(x, y, button)
    if button == 1 then
      particleSystem:emit(50)
    end
  end
  ```

- [`setPosition`](https://love2d.org/wiki/ParticleSystem:setPosition)

  This function doesn't introduce a new concept, but provides a convenience with respect to the previous demo. Instead of specifying the `x` and `y` position in `love.graphics.draw`, you set the position of the emitter directly.

  ```lua
  particleSystem:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  ```

  All that `love.graphics.draw` needs is then the particle system itself.

  ```lua
  love.graphics.draw(particleSystem)
  ```

  Providing additional `x` and `y` values would have the particles spawn _from_ the position described by `setPosition`

- [`setRadialAcceleration`](https://love2d.org/wiki/ParticleSystem:setRadialAcceleration)

  [`setLinearAcceleration`](https://love2d.org/wiki/ParticleSystem:setLinearAcceleration) accepts four arguments to have the particles move in the `x` and `y` dimensions.

  `setRadialAcceleration` instead accepts two arguments to have the particles move away from the center described by the emitter. It is especially useful in the context of the game, as the particles spawn away from where the collision happens.

  ```lua
  particleSystem:setRadialAcceleration(0, 400)
  ```

- [`setLinearDamping`](https://love2d.org/wiki/ParticleSystem:setLinearDamping)

  The function describes the deceleration applied to the particles. It works to slow down the particles as they are emitted.

  ```lua
  particleSystem:setLinearDamping(10, 20)
  ```

  It accepts two arguments for the minimum and maximum amount of deceleration.

- [`setSizes`](https://love2d.org/wiki/ParticleSystem:setSizes)

  The function works to describe the sizes assumed by the particles in their lifetime, and it accepts up to eight values.

  ```lua
  particleSystem:setSizes(0, 1, 1, 0)
  ```
