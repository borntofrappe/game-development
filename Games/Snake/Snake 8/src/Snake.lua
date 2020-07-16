
--[[
  Snake "class"
  describing a square moved according to dx and dy values
]]
Snake = {
  x = 0,
  y = 0,
  size = SNAKE_SIZE,
  dx = 0,
  dy = 0,
  -- direction modifying the movement of the snake
  direction = nil,
  -- variable describing if the shape has changed in dx or dy
  hasTurned = false,
  color = {
    r = 1,
    g = 1,
    b = 1
  }
}

-- init function initializing the snake
-- picking up the values described by default if not specified otherwise
function Snake:init(o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)
  return o
end


function Snake:update(dt)
  -- update the position of the square according to dx and dy
  self.x = self.x + self.dx
  self.y = self.y + self.dy


  -- change dx and dy only if the direction is specified
  -- the direction is specified exclusively on the first instance of the snake class
  if self.direction then
    -- when reaching the first track in the grid
    if self.x % CELL_SIZE == 0 and self.y % CELL_SIZE == 0 then
      -- retrieve the direction to avoid typying self.direction every time
      local direction = self.direction
      -- change dx and dy according to the actual value of direction
      if direction == 'up' then
        self.dy = -SNAKE_SPEED
        self.dx = 0
      elseif direction == 'down' then
        self.dy = SNAKE_SPEED
        self.dx = 0
      elseif direction == 'right' then
        self.dy = 0
        self.dx = SNAKE_SPEED
      elseif direction == 'left' then
        self.dy = 0
        self.dx = -SNAKE_SPEED
      end

      -- set self.hasTurned to true
      self.hasTurned = true

    end -- end of cell size condition

  end -- end of direction condition




  -- EXCEEDING WINDOW
  -- if the square exceeds the boundaties of the screen, have it spawn the opposite way from which it came
  if self.x < 0 - self.size then
    self.x = WINDOW_WIDTH
  elseif self.x > WINDOW_WIDTH then
    self.x = 0 - self.size
  end

  if self.y < 0 - self.size then
    self.y = WINDOW_HEIGHT
  elseif self.y > WINDOW_HEIGHT then
    self.y = 0 - self.size
  end
end


-- detect a collision with another shape
function Snake:collides(shape)
  -- check if the snake and shape cannot overlap
  if self.x  + self.size < shape.x + SHAPE_OVERLAP or self.x > shape.x + shape.size - SHAPE_OVERLAP then
    return false
  end
  if self.y + self.size < shape.y + SHAPE_OVERLAP or self.y > shape.y + shape.size - SHAPE_OVERLAP then
    return false
  end

  -- if they cannot not being overlapping, they overlap
  return true
end

-- draw the snake through a square
function Snake:render()
  -- love.graphics.setColor(0.224, 0.824, 0.604, 1)
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)

  love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end