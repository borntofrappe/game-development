--[[
  Appendage "class"
  - setting up a series of variables describing the position, size of the appendage
  - drawing the appendage through a square
]]
Appendage = {
  x = 0,
  y = 0,
  size = APPENDAGE_SIZE,
  -- dx and dy determine the movement of the square
  dx = 0,
  dy = 0,
  -- turns and counter establish when the direction of the square should be updated
  turns = 0,
  counter = 0
}


function Appendage:init(o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)
  return o
end

--[[
  update the appendage according to the movement of the snake

  turns determines the number of tracks to cross before the appendage should be updated
]]
function Appendage:update(dt, dx, dy)
  -- if the direction of the appendage differs from the one of the snake
  if self.dx ~= dx or self.dy ~= dy then
    -- if the appendage crosses a grid
    if self.x % CELL_SIZE == 0 and self.y % CELL_SIZE == 0 then
      -- increment the counter variable
      self.counter = self.counter + 1

      -- as the couunter exceeds the number identified through turns
      if self.counter > self.turns then
        -- update the direction
        self.dx = dx
        self.dy = dy

        -- reset the counter for the next round
        self.counter = 0
      end
    end
  end

  -- update the position of the square
  self.x = self.x + self.dx
  self.y = self.y + self.dy
end


-- include the appendage as a slightly rounded square
function Appendage:render()
  love.graphics.setColor(0.224, 0.524, 0.604, 1)
  love.graphics.rectangle('fill', self.x, self.y, self.size, self.size, 2)
end

