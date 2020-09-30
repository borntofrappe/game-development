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
    interval = 0.15,
    tail = {}
  }

  setmetatable(this, self)
  return this
end

function Snake:update(dt)
  self.timer = self.timer + dt
  if self.timer > self.interval then
    self.timer = self.timer % self.interval

    column = self.column + DIRECTIONS_CHANGE[self.direction].dx
    row = self.row + DIRECTIONS_CHANGE[self.direction].dy

    for i = #self.tail, 1, -1 do
      if i == 1 then
        self.tail[i].column = self.column
        self.tail[i].row = self.row
        self.tail[i].direction = self.direction
      else
        self.tail[i].column = self.tail[i - 1].column
        self.tail[i].row = self.tail[i - 1].row
        self.tail[i].direction = self.tail[i - 1].direction
      end
    end

    self.column = column
    self.row = row

    if self:eatsTail() then
      self.tail = {}
    end
  end

  if love.keyboard.wasPressed("up") and self.direction ~= "bottom" then
    self.direction = "top"
  elseif love.keyboard.wasPressed("right") and self.direction ~= "left" then
    self.direction = "right"
  elseif love.keyboard.wasPressed("down") and self.direction ~= "top" then
    self.direction = "bottom"
  elseif love.keyboard.wasPressed("left") and self.direction ~= "right" then
    self.direction = "left"
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

  for k, tail in pairs(self.tail) do
    tail:render()
  end
end

function Snake:growTail()
  local reference = self.tail[#self.tail] or self
  local direction = reference.direction
  local column = reference.column + DIRECTIONS_CHANGE[direction].dx * -1
  local row = reference.row + DIRECTIONS_CHANGE[direction].dy * -1
  local tail = Tail:create(column, row, direction)
  table.insert(self.tail, tail)
end

function Snake:eatsTail()
  for k, tail in pairs(self.tail) do
    if testAABB(self, tail) then
      return true
    end
  end
  return false
end