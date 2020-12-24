Ball = Class {}

function Ball:init(x, y)
  self.x = x
  self.y = y
  self.width = 8
  self.height = 8

  self.dx = math.random(2) == 1 and math.random(60, 100) or math.random(60, 100) * -1
  self.dy = math.random(60, 120) * -1

  self.color = 1
end

function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if self.x <= 0 then
    self.x = 0
    self.dx = self.dx * -1
    gSounds["wall_hit"]:play()
  end

  if self.x >= VIRTUAL_WIDTH - self.width then
    self.x = VIRTUAL_WIDTH - self.width
    self.dx = self.dx * -1
    gSounds["wall_hit"]:play()
  end

  if self.y <= 0 then
    self.y = 0
    self.dy = self.dy * -1
    gSounds["wall_hit"]:play()
  end
end

function Ball:render()
  love.graphics.draw(gTextures["breakout"], gFrames["balls"][self.color], self.x, self.y)
end
