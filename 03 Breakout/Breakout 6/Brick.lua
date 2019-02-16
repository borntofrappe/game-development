-- create a Brick class
Brick = Class{}

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
end

-- in the hit function switch the flag to false and play the sound to match the brick hit
function Brick:hit()
  self.inPlay = false
  gSounds['brick-hit-2']:play()
end

-- in the :render function, use the love.graphics function to draw the brick as identified from the color and tier
function Brick:render()
  if(self.inPlay) then
    -- 4 colors for every tier
    love.graphics.draw(gTextures['breakout'], gFrames['bricks'][self.tier + 4 * (self.color - 1)], self.x, self.y)
  end
end