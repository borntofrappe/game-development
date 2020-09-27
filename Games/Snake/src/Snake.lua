Snake = {}
Snake.__index = Snake

function Snake:create(x, y)
  local column = math.random(math.floor(WINDOW_WIDTH / CELL_SIZE))
  local row = math.random(math.floor(WINDOW_HEIGHT / CELL_SIZE))

  local column = math.random(math.floor(WINDOW_WIDTH / CELL_SIZE))
  local row = math.random(math.floor(WINDOW_HEIGHT / CELL_SIZE))

  this = {
    x = x or (column - 1) * CELL_SIZE,
    y = y or (row - 1) * CELL_SIZE,
    width = CELL_SIZE,
    height = CELL_SIZE,
    dx = 0,
    dy = 0,
    direction = nil
  }

  setmetatable(this, self)
  return this
end

function Snake:update(dt, userInput)
  if self.dx ~= 0 then
    self.x = self.x + self.dx * CELL_MOVEMENT_SPEED
    if self.x >= WINDOW_WIDTH then
      self.x = -self.width
    elseif self.x <= -self.width then
      self.x = WINDOW_WIDTH
    end
  elseif self.dy ~= 0 then
    self.y = self.y + self.dy * CELL_MOVEMENT_SPEED
    if self.y > WINDOW_HEIGHT then
      self.y = -self.height
    elseif self.y <= -self.height then
      self.y = WINDOW_HEIGHT
    end
  end

  if self.direction then
    if (self.x % CELL_SIZE == 0) and (self.y % CELL_SIZE == 0) then
      self.dx = CELL_DIRECTIONS_SPEED[self.direction].x
      self.dy = CELL_DIRECTIONS_SPEED[self.direction].y

      self.direction = nil
    end
  end

  if userInput then
    if love.keyboard.wasPressed("up") then
      self.direction = "top"
    elseif love.keyboard.wasPressed("right") then
      self.direction = "right"
    elseif love.keyboard.wasPressed("down") then
      self.direction = "bottom"
    elseif love.keyboard.wasPressed("left") then
      self.direction = "left"
    end
  else
    if math.random(50) == 1 then
      self.direction = CELL_DIRECTIONS[math.random(#CELL_DIRECTIONS)]
    end
  end
end

function Snake:render()
  love.graphics.setColor(gColors["snake"].r, gColors["snake"].g, gColors["snake"].b)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
