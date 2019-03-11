--[[
  Snake "class"
  - setting up a series of variables describing the position, size and movement of the snake
  - updating the position depending on dt
  - drawing the snake through a square
]]
Snake = {
  x = 0,
  y = 0,
  width = SNAKE_WIDTH,
  height = SNAKE_HEIGHT,
  dx = 0,
  dy = 0,
  direction = nil
}



-- a class is created through a metatable
function Snake:init(o)
  -- o refers to the table passed as argument
  -- when it isn't passed it is set to an empty table
  o = o or {}
  -- __index allows to have the class use the fields of the Snake table when they aren't specified
  self.__index = self
  setmetatable(o, self)
  return o
end



-- the position of the snake is modified according dt describing the passing of time
function Snake:update(dt)
  -- update the position of the square according to dx and dy
  self.x = self.x + self.dx
  self.y = self.y + self.dy

  -- update the position of the square when reaching a track in the grid
  if self.x % SNAKE_WIDTH == 0 and self.y % SNAKE_HEIGHT == 0 then
    -- look at the direction of the self (nil by default, updated according to the arrow keys)
    if self.direction then
      -- retrieve the direction to avoid typying self. every time
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
      -- set self.direction back to nil
      self.direction = nil
    end
  end

  -- if the square exceeds the boundaties of the screen, have it spawn the opposite way from which it came
  if self.x < 0 - self.width then
    self.x = WINDOW_WIDTH
  end

  if self.x > WINDOW_WIDTH then
    self.x = 0 - self.width
  end

  if self.y < 0 - self.height then
    self.y = WINDOW_HEIGHT
  end

  if self.y > WINDOW_HEIGHT then
    self.y = 0 - self.height
  end
end


-- function detecting a collision with an item
function Snake:collides(item)
  -- check if the snake and item cannot overlap
  if self.x  + self.width < item.x + ITEM_OVERLAP or self.x > item.x + item.size - ITEM_OVERLAP then
    return false
  end
  if self.y + self.height < item.y + ITEM_OVERLAP or self.y > item.y + item.size - ITEM_OVERLAP then
    return false
  end

  -- if they cannot not being overlapping, they overlap
  return true
end


-- the snake itself is drawn through a square
function Snake:render()
  love.graphics.setColor(0.224, 0.824, 0.604, 1)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

