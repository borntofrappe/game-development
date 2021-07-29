Interactable = {}

function Interactable:new(x, y, type)
  local type = type or "solid"
  local data = INTERACTABLES[type]
  local width = data.width
  local height = data.height
  local frames = data.frames
  local animationInterval = data.animationInterval
  local interactionInterval = data.interactionInterval
  local canBeDestroyed = data.canBeDestroyed
  local dx = data.dx

  local this = {
    ["x"] = math.floor(x - width / 2),
    ["y"] = math.floor(y - height / 2),
    ["width"] = width,
    ["height"] = height,
    ["type"] = type,
    ["frame"] = 1,
    ["frames"] = frames,
    ["timer"] = 0,
    ["animationInterval"] = animationInterval,
    ["interactionInterval"] = interactionInterval,
    ["canBeDestroyed"] = canBeDestroyed,
    ["inPlay"] = true,
    ["isInteracted"] = false,
    ["dx"] = dx,
    ["direction"] = math.random(2) == 1 and 1 or -1,
    ["hat"] = hat
  }

  if data.hatOdds > 0 and math.random(data.hatOdds) == 1 then
    this.hat = Hat:new(this.x + this.width / 2, this.y - HAT.height)
  end

  self.__index = self
  setmetatable(this, self)

  return this
end

function Interactable:update(dt)
  if self.hat then
    self.hat:update(dt)
  end

  if self.animationInterval then
    self.timer = self.timer + dt
    if self.timer >= self.animationInterval then
      self.timer = self.timer % self.animationInterval
      self.frame = self.frame == self.frames and 1 or self.frame + 1
    end
  end

  if self.interactionInterval and self.isInteracted then
    self.timer = self.timer + dt
    if self.timer >= self.interactionInterval then
      self.timer = self.timer % self.interactionInterval
      if self.frame == self.frames then
        if self.canBeDestroyed then
          self.inPlay = false
        else
          self.isInteracted = false
          self.frame = 1
        end
      else
        self.frame = self.frame + 1
      end
    end
  end

  if self.dx then
    self.x = self.x + self.dx * self.direction * dt
    if self.hat then
      self.hat.x = self.x + self.width / 2 - self.hat.width / 2
    end
    if self.x > WINDOW_WIDTH - self.width then
      self.x = WINDOW_WIDTH - self.width
      self.direction = -1
    end
    if self.x < 0 then
      self.x = 0
      self.direction = 1
    end
  end
end

function Interactable:render()
  love.graphics.draw(gTextures["spritesheet"], gFrames["interactables"][self.type][self.frame], self.x, self.y)

  if self.hat then
    self.hat:render()
  end
end
