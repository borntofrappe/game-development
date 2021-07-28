Interactable = {}

function Interactable:new(x, y, type)
  local type = type or "solid"
  local data = INTERACTABLES[type]
  local width = data.width
  local height = data.height
  local frames = data.frames
  local animation = data.animation
  local interaction = data.interaction
  local movement = data.movement

  local this = {
    ["x"] = math.floor(x - width / 2),
    ["y"] = math.floor(y - height / 2),
    ["width"] = width,
    ["height"] = height,
    ["type"] = type,
    ["frame"] = 1,
    ["frames"] = frames,
    ["timer"] = 0,
    ["animation"] = animation,
    ["interaction"] = interaction,
    ["inPlay"] = true,
    ["isInteracted"] = false,
    ["movement"] = movement,
    ["direction"] = math.random(2) == 1 and 1 or -1
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Interactable:update(dt)
  if self.animation.isAnimated then
    self.timer = self.timer + dt
    if self.timer >= self.animation.interval then
      self.timer = self.timer % self.animation.interval
      self.frame = self.frame == self.frames and 1 or self.frame + 1
    end
  end

  if self.interaction.canBeInteracted and self.isInteracted then
    self.timer = self.timer + dt
    if self.timer >= self.interaction.interval then
      self.timer = self.timer % self.interaction.interval
      if self.frame == self.frames then
        if self.interaction.isDestroyed then
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

  if self.movement.canMove then
    self.x = self.x + self.movement.dx * self.direction * dt
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
end
