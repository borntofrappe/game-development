Interactables = {}

local PADDING = 50
local GAP = {math.floor(WINDOW_HEIGHT / 4), math.floor(WINDOW_HEIGHT / 3)}
local X = {PADDING, WINDOW_WIDTH - PADDING}

function Interactables:new(x, y, type)
  local interactables = {}

  local types = {}
  for k, interactable in pairs(INTERACTABLES) do
    table.insert(types, k)
  end

  local y = PADDING

  while y < WINDOW_HEIGHT * 2 do
    local x = math.random(X[1], X[2])
    local type = types[math.random(#types)]
    table.insert(interactables, Interactable:new(x, WINDOW_HEIGHT - y, type))
    local gap = math.random(GAP[1], GAP[2])
    y = y + gap
  end

  local this = {
    ["interactables"] = interactables,
    ["types"] = types,
    ["y"] = y
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Interactables:update(dt, scrollY)
  for k, interactable in pairs(self.interactables) do
    if interactable.y > WINDOW_HEIGHT - scrollY then
      table.remove(self.interactables, k)

      local x = math.random(X[1], X[2])
      local type = self.types[math.random(#self.types)]

      table.insert(self.interactables, Interactable:new(x, WINDOW_HEIGHT - self.y, type))
      local gap = math.random(GAP[1], GAP[2])
      self.y = self.y + gap
      break
    end
  end
end

function Interactables:render()
  love.graphics.setColor(1, 1, 1)
  for k, interactable in pairs(self.interactables) do
    interactable:render()
  end
end
