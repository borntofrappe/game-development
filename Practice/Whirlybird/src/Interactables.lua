Interactables = {}

local PADDING = 50
local GAP = {math.floor(WINDOW_HEIGHT / 5), math.floor(WINDOW_HEIGHT / 4)}
local X = {PADDING, WINDOW_WIDTH - PADDING}

function Interactables:new(x, y)
  local interactables = {}

  local y = PADDING
  while y < WINDOW_HEIGHT * 2 do
    local x = math.random(X[1], X[2])
    table.insert(interactables, Interactable:new(x, WINDOW_HEIGHT - y))
    local gap = math.random(GAP[1], GAP[2])
    y = y + gap
  end

  local this = {
    ["interactables"] = interactables,
    ["y"] = y
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Interactables:add()
  local x = math.random(X[1], X[2])

  table.insert(self.interactables, Interactable:new(x, WINDOW_HEIGHT - self.y))
  local gap = math.random(GAP[1], GAP[2])
  self.y = self.y + gap
end

function Interactables:update(dt, scrollY)
  for k, interactable in pairs(self.interactables) do
    if interactable.y > WINDOW_HEIGHT - scrollY then
      self:add()

      table.remove(self.interactables, k)
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
