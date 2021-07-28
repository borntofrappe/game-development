Player = {}

local ANIMATION_INTERVAL = 0.1

function Player:new(x, y, direction, state)
  local direction = direction or 1
  local state = state or "default"

  local data = PLAYER[state]
  local width = data.width
  local height = data.height
  local frames = data.frames

  local this = {
    ["x"] = x - width / 2,
    ["y"] = y - height / 2,
    ["width"] = width,
    ["height"] = height,
    ["dx"] = 0,
    ["dy"] = 0,
    ["direction"] = 1,
    ["state"] = state,
    ["frame"] = 1,
    ["frames"] = frames,
    ["timer"] = 0
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Player:update(dt)
  self.dy = self.dy + GRAVITY * dt
  self.y = self.y + self.dy

  self.dx = math.max(0, self.dx - FRICTION * dt)
  self.x = self.x + self.dx * self.direction

  if self.x < -self.width then
    self.x = WINDOW_WIDTH
  end

  if self.x > WINDOW_WIDTH then
    self.x = -self.width
  end

  if love.keyboard.isDown("right") then
    self:slide("right")
  end

  if love.keyboard.isDown("left") then
    self:slide("left")
  end

  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()

    if x > WINDOW_WIDTH / 2 then
      self:slide("right")
    else
      self:slide("left")
    end
  end

  if self.frames > 1 then
    self.timer = self.timer + dt
    if self.timer >= ANIMATION_INTERVAL then
      self.timer = self.timer % ANIMATION_INTERVAL
      self.frame = self.frame == self.frames and 1 or self.frame + 1
    end
  end
end

function Player:isOnTop(interactable)
  if self.x + self.width < interactable.x or self.x > interactable.x + interactable.width then
    return false
  end

  if self.y + self.height < interactable.y or self.y > interactable.y + interactable.height then
    return false
  end

  return self.y + self.height / 2 < interactable.y
end

function Player:bounce(intensity)
  local intensity = intensity or 1
  self.dy = JUMP * intensity * -1
end

function Player:slide(direction)
  self.dx = SLIDE
  self.direction = direction == "right" and 1 or -1
end

function Player:change(state)
  local data = PLAYER[state]
  local width = data.width
  local height = data.height
  local frames = data.frames

  self.state = state
  self.x = self.x + (self.width - width)
  self.y = self.y + (self.height - height)
  self.width = width
  self.height = height
  self.frame = 1
  self.frames = frames
end

function Player:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTextures["spritesheet"],
    gFrames["player"][self.state][self.frame],
    self.direction == 1 and math.floor(self.x) or math.floor(self.x) + self.width,
    math.floor(self.y),
    0,
    self.direction == 1 and 1 or -1,
    1
  )
end
