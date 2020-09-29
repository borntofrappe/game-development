Snake = {}
Snake.__index = Snake

function Snake:create()
  this = {
    column = math.random(COLUMNS),
    row = math.random(ROWS),
    width = CELL_SIZE,
    height = CELL_SIZE,
    direction = DIRECTIONS[math.random(#DIRECTIONS)],
    timer = 0,
    interval = 0.15
  }

  setmetatable(this, self)
  return this
end

function Snake:update(dt)
  if love.keyboard.wasPressed("up") then
    self.direction = "top"
  elseif love.keyboard.wasPressed("right") then
    self.direction = "right"
  elseif love.keyboard.wasPressed("down") then
    self.direction = "bottom"
  elseif love.keyboard.wasPressed("left") then
    self.direction = "left"
  end

  self.timer = self.timer + dt
  if self.timer > self.interval then
    self.timer = self.timer % self.interval

    self.column = self.column + DIRECTIONS_CHANGE[self.direction].dx
    self.row = self.row + DIRECTIONS_CHANGE[self.direction].dy
  end

  if self.column < 1 then
    self.column = COLUMNS
  end
  if self.column > COLUMNS then
    self.column = 1
  end

  if self.row < 1 then
    self.row = ROWS
  end
  if self.row > ROWS then
    self.row = 1
  end
end

function Snake:render()
  love.graphics.setColor(gColors["snake"].r, gColors["snake"].g, gColors["snake"].b)
  love.graphics.rectangle("fill", (self.column - 1) * CELL_SIZE, (self.row - 1) * CELL_SIZE, self.width, self.height)
end
