# Breakout 9

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## Particle System

This is a considerable update, in that it requires the use of multiple LOVE2D-specific functions.

It helps to think of the particles as another asset, like a brick, a ball. You update the asset through an `update(dt)` function, and you show the visual through a `render()` function. The complication is that it is first necessary to set up the particles system and modify its behavior with a few functions.

## Setup

A particle system is based on an image, like the one provided in `particle.png`, but also a set of colors. The idea is to produce multiple copies of the image, tinted with the given hue, and animate their appearance in and out.

In `Brick.lua` start by defining the colors. In the instance of the breakout game, the colors are included in a table and match the hue chosen for the bricks.

```lua
local colorBricks = {
  [1] = {
    ['r'] = 99/255,
    ['g'] = 155/255,
    ['b'] = 255/255
  },
  -- other color variants
}
```

Past this table, it is in the `init` function that we set up the particle system. This using a few essential LOVE functions.

### newParticleSystem

The function takes as argument:

- an image like `particle.png`

- the number of copies reproduced with the image

The same function returns the particle system. so you can customize its behavior and ultimately shown in the game loop.

```lua
function Brick:init()
  -- ...

  self.particleSystem = love.graphics.newParticleSystem(gTextures['particle'], 80)
end
```

### Useful methods

[The love2d wiki](https://love2d.org/wiki/ParticleSystem) provide more information about particle systems and accompanying methods, but here, focus on the following functions:

- `setParticleLifetime`: how much time the particles need to stay visible

  The function accepts two arguments for the minimum and maximum number of seconds the images are shown

  ```lua
  self.particleSystem:setParticleLifetime(0.2, 0.7)
  ```

- `setLinearAcceleration`: how the particles move from their point of origin

  The function accepts two arguments for the minimum horizontal and vertical coordinate and two arguments for the maximum value. The particles spread in the range provided by the pair

  ```lua
  self.particleSystem:setLinearAcceleration(-10, 10, 10, 80)
  ```

- `setEmissionArea`: the area in which the particles move

  The function accepts one argument for the distribution type, and two arguments for the distance the particles cover horizontally and vertically

  ```lua
  self.particleSystem:setEmissionArea('normal', 10, 10)
  ```

These functions are available on the particle system object — notice the colon operator — and are specified in the `init` function.

There are two additional method, but these are set in the `hit()` function. This is because they depend on the brick being actually hit.

- `setColor`: the colors shown by the particles

  This function accepts arguments in groups of four, with each group describing a particular `rgba` combination.

  ```lua
  self.particleSystem:setColors(
    colorBricks[self.color]['r'],
    colorBricks[self.color]['g'],
    colorBricks[self.color]['b'],
    0.5,
    colorBricks[self.color]['r'],
    colorBricks[self.color]['g'],
    colorBricks[self.color]['b'],
    0
  )
  ```

  Following this function, the particles are animated from color to color. In this instance, from a semi-transparent tint to a fully transparent one.

- `emit`: produce the particles

  The method is responsible for actually producing the particles. It accepts as argument the number of particles being emitted, knowing that the value set when you create the particle system works as an upper threshold.

  ```lua
  self.particleSystem:emit(80)
  ```

## Update and render

Creating the particle system and emitting the particles is not enough. As mentioned, a particle system is an asset much alike the brick or the ball. In light of this, it is necessary to:

1. render the visual

   ```lua
   function Brick:renderParticles()
     love.graphics.draw(self.particleSystem, self.x + 16, self.y + 8)
   end
   ```

   In this instance add the particles in the middle of the brick

2. update the visual

   In this manner the game loop actually goes through the particle animation

   ```lua
   function Brick:update(dt)
     self.particleSystem:update(dt)
   end
   ```

Once you define these functions, you can use them in the play state exactly like `Brick:render()`, or again `Ball:update()`

```lua
function PlayState:update(dt)
  for k, brick in pairs(self.bricks) do
    brick:update(dt)

    -- ...
  end
end

function PlayState:render()
  for k, brick in pairs(self.bricks) do
    brick:render()
    brick:renderParticles()
  end
end
```

Having a separate function for the particles, `renderParticles`, helps to show the particles even if the brick is removed from view (as it is destroyed).
