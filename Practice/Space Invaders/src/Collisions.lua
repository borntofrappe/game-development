Collisions = {}

function Collisions:new()
  local this = {
    ["collisions"] = {}
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Collisions:update(dt)
  for k, collision in pairs(self.collisions) do
    collision:update(dt)

    if not collision.inPlay then
      table.remove(self.collisions, k)
    end
  end
end

function Collisions:render()
  love.graphics.setColor(1, 1, 1)
  for k, collision in pairs(self.collisions) do
    collision:render()
  end
end
