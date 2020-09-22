Snake = {}
Snake.__index = Snake

function Snake:create(x, y)
  this = {
    x = x or math.random(math.floor(WINDOW_WIDTH / CELL_SIZE) * CELL_SIZE),
    y = y or math.random(math.floor(WINDOW_HEIGHT / CELL_SIZE) * CELL_SIZE),
    width = CELL_SIZE,
    height = CELL_SIZE,
    direction = DIRECTIONS[math.random(#DIRECTIONS)],
    changeDirection = false
  }

  setmetatable(this, self)
  return this
end

function Snake:update(dt, userInput)
  if userInput then
  else
    if CELL_DIRECTION_SPEED[self.direction].x == 0 then
      self.y = self.y + CELL_DIRECTION_SPEED[self.direction].y * math.floor(CELL_MOVEMENT_SPEED * dt)
      if self.y % CELL_SIZE == 0 then
        self.changeDirection = math.random(5) == 1
        if self.changeDirection then
          self.direction = DIRECTIONS[math.random(#DIRECTIONS)]
        end
      end

      if self.y < -CELL_SIZE then
        self.y = WINDOW_HEIGHT
      elseif self.y > WINDOW_HEIGHT then
        self.y = -CELL_SIZE
      end
    else
      self.x = self.x + CELL_DIRECTION_SPEED[self.direction].x * math.floor(CELL_MOVEMENT_SPEED * dt)
      if self.x % CELL_SIZE == 0 then
        self.changeDirection = math.random(5) == 1
        if self.changeDirection then
          self.direction = DIRECTIONS[math.random(#DIRECTIONS)]
        end
      end

      if self.x < -CELL_SIZE then
        self.x = WINDOW_WIDTH
      elseif self.x > WINDOW_WIDTH then
        self.x = -CELL_SIZE
      end
    end
  end
end

function Snake:render()
  love.graphics.setColor(gColors["snake"].r, gColors["snake"].g, gColors["snake"].b)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
