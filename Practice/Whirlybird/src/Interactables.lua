Interactables = {}

local PADDING = 50
local GAP = {70, 150}
local X = {PADDING, WINDOW_WIDTH - PADDING}

function Interactables:new(x, y)
  local interactables = {}

  local types = {}
  for type, _ in pairs(INTERACTABLES) do
    table.insert(types, type)
  end

  local wasSafe = true

  local y = PADDING
  while y < WINDOW_HEIGHT * 2 do
    local x = math.random(X[1], X[2])
    local type = wasSafe and types[math.random(#types)] or INTERACTABLES_SAFE[math.random(#INTERACTABLES_SAFE)]
    table.insert(interactables, Interactable:new(x, WINDOW_HEIGHT - y, type))
    local gap = math.random(GAP[1], GAP[2])
    y = y + gap
    wasSafe = not wasSafe
  end

  local this = {
    ["interactables"] = interactables,
    ["y"] = y,
    ["types"] = types,
    ["wasSafe"] = wasSafe
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Interactables:add()
  local x = math.random(X[1], X[2])
  local type =
    self.wasSafe and self.types[math.random(#self.types)] or INTERACTABLES_SAFE[math.random(#INTERACTABLES_SAFE)]

  table.insert(self.interactables, Interactable:new(x, WINDOW_HEIGHT - self.y, type))
  local gap = math.random(GAP[1], GAP[2])
  self.y = self.y + gap
  self.wasSafe = not self.wasSafe
end

function Interactables:update(dt, scrollY)
  for k, interactable in pairs(self.interactables) do
    interactable:update(dt)
    if interactable.y > WINDOW_HEIGHT - scrollY or not interactable.inPlay then
      self:add()

      table.remove(self.interactables, k)
    end
  end
end

function Interactables:render()
  love.graphics.setColor(1, 1, 1)
  for k, interactable in pairs(self.interactables) do
    interactable:render()
  end
end
