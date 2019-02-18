-- create a Brick class
Brick = Class{}

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

--[[
  in the :init function detail the variables which define the class
  - x and y, for the coordinates specified when creating an instance of the class
  - width and height, matching the pixel value of the sprite to maintain the ratio
  - color, for the color of the brick (up to 4 variants)
  - tier, for the tier of the brick (5 variants + a single brick type)
  - inPlay, whether or not the brick is to be rendered on the screen

  ! specify color and tier when creating an instance of the class
]]
function Brick:init(x, y, color, tier)
  self.x = x
  self.y = y
  self.width = 32
  self.height = 16

  self.color = color
  self.tier = tier

  self.inPlay = true

  -- create a particle system using the texture of the particle
  self.particleSystem = love.graphics.newParticleSystem(gTextures['particle'], 80)

  --[[ shorten the lifetime of the particles
    arguments:
    - min
    - max
    both representing the time in seconds
  ]]
  self.particleSystem:setParticleLifetime(0.3, 0.8)

  --[[ accelrate the particles
    arguments:
    - xmin
    - ymin
    - xmax
    - ymax
    horizontally around the the origin of the system
    vertically downwards
  ]]
  self.particleSystem:setLinearAcceleration(-20, 10, 20, 80)

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

--[[
  in the hit function consider the color and tier of the brick
  - reduce the color
  - reduce the tier
  - make the brick disappear
  play the sound brick-hit-1 when the brick needs to disappear
]]
function Brick:hit()
  --[[ set the colors of the particle system according to the brick's own color
    arguments: quadruples of r, g, b, a values

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
  self.particleSystem:emit(80)

  -- play the hit sound, giving precedence to the last hit being recorded
  gSounds['brick-hit-1']:stop()
  gSounds['brick-hit-1']:play()

  -- higher color, decrement the color
  if self.color > 1 then
    self.color = self.color - 1
  -- color 1, check tier
  else
    -- color 1 **and** higher tier, decrement the tier
    if self.tier > 1 then
      self.tier = self.tier - 1
    -- color 1 **and** tier 1, make the brick disappear
    else
      self.inPlay = false
      gSounds['score']:stop()
      gSounds['score']:play()
    end
  end
end


-- in the :update(dt) function update the particle system
function Brick:update(dt)
  self.particleSystem:update(dt)
end


-- in the :render function, use love.graphics to draw the brick as identified from the color and tier
function Brick:render()
  if self.inPlay then
    -- 4 colors for every tier
    love.graphics.draw(gTextures['breakout'], gFrames['bricks'][self.tier + 4 * (self.color - 1)], self.x, self.y)
  end
end


-- in the :renderParticles() function draw the particles on the center of the brick calling it
function Brick:renderParticles()
  love.graphics.draw(self.particleSystem, self.x + 16, self.y + 8)
end