Interactable = Class {}

function Interactable:init(x, y, type)
  self.x = x
  self.y = y
  self.type = math.random(TYPES)
  self.width = INTERACTABLE_WIDTH
  self.height = INTERACTABLE_HEIGHTS[self.type]

  self.direction = math.random(2) == 1 and 1 or -1
  self.dx = INTERACTABLE_SPEED

  self.isAnimated = self.type == 2 or self.type == 4 or self.type == 8
  self.inPlay = true

  self.timer = 0
  self.interval = self.isAnimated and 1 or 0.07
  self.variety = 1
  self.varieties = 4
end

function Interactable:update(dt)
  if self.type == 4 or self.type == 8 then
    self.x = self.x + self.dx * self.direction * dt
    if self.x <= 0 then
      self.x = 0
      self.direction = self.direction * -1
    elseif self.x >= WINDOW_WIDTH - self.width then
      self.x = WINDOW_WIDTH - self.width
      self.direction = self.direction * -1
    end
  end

  if self.isAnimated then
    self.timer = self.timer + dt
    if self.timer >= self.interval then
      self.timer = self.timer % self.interval
      if self.variety == self.varieties then
        if self.type == 2 or self.type == 4 or self.type == 7 or self.type == 8 then
          self.variety = 1
        elseif self.type == 6 then
          self.variety = 1
          self.isAnimated = false
        else
          self.inPlay = false
        end
      else
        self.variety = self.variety + 1
      end
    end
  end
end

function Interactable:render()
  love.graphics.draw(
    gTextures["spritesheet"],
    gFrames["interactables"][self.type][self.variety],
    math.floor(self.x),
    math.floor(self.y)
  )
end
