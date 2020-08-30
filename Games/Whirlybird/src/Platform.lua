Platform = Class {}

function Platform:init(x, y, type)
  self.x = x
  self.y = y
  self.width = PLATFORM_WIDTH
  self.height = PLATFORM_HEIGHT
  self.type = type
end

function Platform:render()
  love.graphics.draw(gTextures["spritesheet"], gFrames["platforms"][self.type], self.x, self.y)
end
