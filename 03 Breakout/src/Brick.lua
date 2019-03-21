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
  - locked, (boolean determining the sprite)
  - unlocked (boolean used to show the unlocked sprite after the locked one)
  - inPlay, whether or not the brick is to be rendered on the screen
  ! specify color and tier when creating an instance of the class

  in addition and for the powerups
  - hasPowerup, a boolean to dictate whether or not to include one
  - powerup, an instance of the actuall Powerup class
  the idea is to have the power up hidden in the brick and have it rendered/updated when the bricks is removed from play
]]
function Brick:init(x, y, color, tier, locked)
  self.x = x
  self.y = y
  self.width = 32
  self.height = 16
  self.color = color
  self.tier = tier
  self.locked = locked
  self.unlocked = false
  self.inPlay = true
  -- POWERUP
  -- always add a powerup when the brick is locked
  -- otherwise add it in 25% of the instanes
  self.hasPowerup = self.locked and true or math.random(4) == 1 and true or false
  -- powerup included in the center of the brick
  self.powerup = Powerup(self.x + self.width / 2, self.y + self.height / 2, self.locked)


  -- PARTICLE SYSTE;
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
  in the hit function consider how the brick might be locked/unlocked or othewise pattern-ed
]]
function Brick:hit()
  -- if the brick is locked, avoid changing tier or color
  if self.locked then
    -- if the powerup is not in play (by default and when the powerup goes past the bottom of the screeen), show it
    if not self.powerup.inPlay then
      self.powerup.inPlay = true
    end
    -- play the appropriate sound
    gSounds['brick-hit-3']:stop()
    gSounds['brick-hit-3']:play()
  else
    -- if unlocked, set the color for the particle system for the last possible value
    if self.unlocked then
      self.particleSystem:setColors(
        colorPalette[#colorPalette]['r'],
        colorPalette[#colorPalette]['g'],
        colorPalette[#colorPalette]['b'],
        0.5,
        colorPalette[#colorPalette]['r'],
        colorPalette[#colorPalette]['g'],
        colorPalette[#colorPalette]['b'],
        0
      )
      self.particleSystem:emit(80)

      -- destroy the brick by setting its flag to false
      self.inPlay = false
      -- play the appropriate sound
      gSounds['score']:stop()
      gSounds['score']:play()

      -- for normal bricks, set the color of the particle system according to the pattern of the brick
    else
      -- play the sound for the hit
      gSounds['brick-hit-1']:stop()
      gSounds['brick-hit-1']:play()
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

      self.particleSystem:emit(80)

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
          -- if the brick has a powerup, display it
          if self.hasPowerup then
            self.powerup.inPlay = true
          end
          -- play the sound for the destrution of the brick
          gSounds['score']:stop()
          gSounds['score']:play()
        end
      end
    end
  end

end


-- in the :update(dt) function update the particle system and the
-- the powerup is updated in its own class, conditional to its inPlay flag being set to true
function Brick:update(dt)
  self.particleSystem:update(dt)

  if self.powerup.inPlay then
    self.powerup:update(dt)
  end
end


-- in the :render function, use love.graphics to draw the brick as identified from the color and tier
-- ! render the power up but only if its flag is set to true
function Brick:render()
  if self.inPlay then
    -- depending on locked describe the pattern
    -- 22 or the pattern identified by the tier/color
    local pattern = self.locked and 22 or self.unlocked and 21 or self.tier + 4 * (self.color - 1)
    love.graphics.draw(gTextures['breakout'], gFrames['bricks'][pattern], self.x, self.y)
  end

  if self.powerup.inPlay then
    self.powerup:render()
  end
end


-- in the :renderParticles() function draw the particles on the center of the brick calling it
function Brick:renderParticles()
  love.graphics.draw(self.particleSystem, self.x + 16, self.y + 8)
end