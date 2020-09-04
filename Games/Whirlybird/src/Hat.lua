Hat = Class {}

function Hat:init(x, y)
  self.x = x
  self.y = y

  self.width = HAT_WIDTH
  self.height = HAT_HEIGHT

  self.variety = 1
  self.varieties = #gFrames["hat"]
  self.timer = 0
  self.interval = 0.2
end

function Hat:update(dt)
  self.timer = self.timer + dt
  if self.timer >= self.interval then
    self.timer = self.timer % self.interval
    if self.variety == self.varieties then
      self.variety = 1
    else
      self.variety = self.variety + 1
    end
  end
end

function Hat:render()
  love.graphics.draw(gTextures["spritesheet"], gFrames["hat"][self.variety], math.floor(self.x), math.floor(self.y))
end
