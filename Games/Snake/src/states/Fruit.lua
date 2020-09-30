Fruit = {}
Fruit.__index = Fruit

function Fruit:create()
  this = {
    column = math.random(COLUMNS),
    row = math.random(ROWS),
    width = CELL_SIZE,
    height = CELL_SIZE
  }

  this.x = r
  this.y = r

  setmetatable(this, self)
  return this
end

function Fruit:spawn(snake)
  local fruit = Fruit:create()
  while true do
    local isOverlapping = false

    if #snake.tail > 0 then
      for k, tail in pairs(snake.tail) do
        if testAABB(fruit, tail) then
          isOverlapping = true
          break
        end
      end
    end

    if not isOverlapping and not testAABB(snake, fruit) then
      break
    else
      fruit = Fruit:create()
    end
  end

  return fruit
end

function Fruit:render()
  love.graphics.setColor(gColors["fruit"].r, gColors["fruit"].g, gColors["fruit"].b)
  love.graphics.rectangle("fill", (self.column - 1) * CELL_SIZE, (self.row - 1) * CELL_SIZE, self.width, self.height)
end
