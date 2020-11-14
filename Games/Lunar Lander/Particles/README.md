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

- [`ParticleSystem:update`](https://love2d.org/wiki/ParticleSystem:update)

  The function manages the update logic of the particles, which are made appeared and disappeared.

  ```lua
  particleSystem:update(dt)
  ```

- `love.graphics.draw`

  The function draws images, textures, quads, but also particle systems.

  ```lua
  love.graphics.draw(particleSystem, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  ```

- [`ParticleSystem:setParticleLifetime`](https://love2d.org/wiki/ParticleSystem:setParticleLifetime)

  In order to have the particles appear and disappear, the function specifies the minimum and maximum life span for an individual particle.

  ```lua
  particleSystem:setParticleLifetime(0.2, 0.5)
  ```

- [`ParticleSystem:setEmissionRate`](https://love2d.org/wiki/ParticleSystem:setEmissionRate)

  The function describes the number of particles emitted in a second.

  ```lua
  particleSystem:setEmissionRate(100)
  ```

- [`ParticleSystem:setEmissionArea`](https://love2d.org/wiki/ParticleSystem:setEmissionArea)

  To avoid showing the particles in the same point, the function describes the area in which to show the particles. It accepts an argument to specify the type of `distribution`, as well as values to define the area.

  ```lua
  particleSystem:setEmissionArea("uniform", WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  ```

The end result is that the particles are shown in the entirety of the gaming window, appearing and disappearing continuously.
