Interactable = Class {}

function Interactable:init(x, y, type)
  self.x = x
  self.y = y
  self.y0 = y
  self.type = type
  self.width = INTERACTABLE_WIDTH
  self.height = INTERACTABLE_HEIGHTS[self.type]

  self.directionX = math.random(2) == 1 and 1 or -1
  self.dx = INTERACTABLE_SPEED_X
  self.directionY = math.random(2) == 1 and 1 or -1
  self.dy = INTERACTABLE_SPEED_Y

  self.isAnimated = self.type == 2 or self.type == 4 or self.type == 7 or self.type == 8
  self.inPlay = true

  self.timer = 0
  self.interval = INTERACTABLE_INTERVALS[self.type]
  self.variety = 1
  if self.type == 2 or self.type == 7 or self.type == 8 then
    self.variety = math.random(#gFrames["interactables"][1])
  end
  self.varieties = #gFrames["interactables"][1]

  self.hat = nil
  if math.random(4) == 1 then
    for k, type in pairs(INTERACTABLE_HAT) do
      if self.type == type then
        self.hat = Hat(self.x + self.width / 2 - HAT_WIDTH / 2, self.y - HAT_HEIGHT - 10)
        break
      end
    end
  end
end

function Interactable:update(dt)
  if self.type == 4 or self.type == 8 then
    self.x = self.x + self.dx * self.directionX * dt
    if self.hat then
      self.hat.x = self.x + self.width / 2 - HAT_WIDTH / 2
    end
    if self.x <= 0 then
      self.x = 0
      self.directionX = self.directionX * -1
    elseif self.x >= WINDOW_WIDTH - self.width then
      self.x = WINDOW_WIDTH - self.width
      self.directionX = self.directionX * -1
    end

    if self.type == 8 then
      self.y = self.y + self.dy * self.directionY * dt
      if math.abs(self.y - self.y0) > INTERACTABLE_JIGGER then
        self.directionY = self.directionY * -1
      end
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

  if self.hat then
    self.hat:update(dt)
  end
end

function Interactable:render()
  love.graphics.draw(
    gTextures["spritesheet"],
    gFrames["interactables"][self.type][self.variety],
    math.floor(self.x),
    math.floor(self.y)
  )

  if self.hat then
    self.hat:render()
  end
end
