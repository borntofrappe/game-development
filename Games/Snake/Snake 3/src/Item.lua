--[[
  Item "class"
  - setting up a series of variables describing the position and size
  - drawing the item through a circle
]]
Item = {
  x = 0,
  y = 0,
  size = ITEM_SIZE,
  -- table describing the color of the shape
  color = {
    r = 1,
    g = 1,
    b = 1
  },
  -- boolean describing whether the item needs to be rendered
  inPlay = true,
  -- time variables to have the items spawn for a selected amount of time
  playTime = 10,
  currentTime = 0
}

-- initialize the item instance
function Item:init(o)
  o = o or {}
  -- set a random number of seconds for playTime, if not already specified in the instance
  if not o.playTime then
    o.playTime = math.random(5, 10)
  end
  self.__index = self
  setmetatable(o, self)
  return o
end

-- switch the inPlay boolean to false after currentTime reaches playTime, considering the passting of time through dt
function Item:update(dt)

  if self.inPlay then
    self.currentTime = self.currentTime + dt
    if self.currentTime > self.playTime then
      self.inPlay = false
      self.currentTime = 0
    end
  end

end

-- show the item through a circle
function Item:render()
  if self.inPlay then
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.circle('fill', self.x + self.size / 2, self.y + self.size / 2, self.size/2)
  end
end

