Interactable = {}

function Interactable:new(x, y, type)
  local type = type or "solid"
  local data = INTERACTABLES[type]
  local width = data.width
  local height = data.height
  local frames = data.frames
  local interval = data.interval
  local isAnimated = data.isAnimated
  local canBeDestroyed = data.canBeDestroyed

  local this = {
    ["x"] = math.floor(x - width / 2),
    ["y"] = math.floor(y - height / 2),
    ["width"] = width,
    ["height"] = height,
    ["type"] = type,
    ["frame"] = 1,
    ["frames"] = frames,
    ["timer"] = 0,
    ["interval"] = interval,
    ["isAnimated"] = isAnimated,
    ["inPlay"] = true,
    ["isInteracted"] = false,
    ["canBeDestroyed"] = canBeDestroyed,
    ["isDestroyed"] = false
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Interactable:update(dt)
  if self.isInteracted and self.inPlay then
    self.inPlay = false
    self.timer = self.timer + dt
    if self.timer >= self.interval then
      if self.frame == self.frames then
        if self.canBeDestroyed then
          self.isDestroyed = true
        else
          self.isInteracted = false
          self.inPlay = true
          self.frame = 1
        end
      else
        self.frame = self.frame + 1
      end
      self.timer = self.timer % self.interval
    end
  end

  if self.isAnimated then
    self.timer = self.timer + dt
    if self.timer >= self.interval then
      self.timer = self.timer % self.interval
      self.frame = self.frame == self.frames and 1 or self.frame + 1
    end
  end
end

function Interactable:render()
  love.graphics.draw(gTextures["spritesheet"], gFrames["interactables"][self.type][self.frame], self.x, self.y)
end
