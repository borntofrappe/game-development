Particles = Class {}

function Particles:init(x, y)
  self.x = x
  self.y = y
  self.variety = 1
  self.varieties = #gFrames["particles"]

  self.inPlay = true
  self.timer = 0
  self.interval = 0.08
end

function Particles:update(dt)
  if self.inPlay then
    self.timer = self.timer + dt
    if self.timer > self.interval then
      self.timer = self.timer % self.interval
      if self.variety == self.varieties then
        self.inPlay = false
      else
        self.variety = self.variety + 1
      end
    end
  end
end

function Particles:render()
  if self.inPlay then
    love.graphics.draw(
      gTextures["spritesheet"],
      gFrames["particles"][self.variety],
      math.floor(self.x),
      math.floor(self.y)
    )
  end
end
