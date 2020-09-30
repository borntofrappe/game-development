Fruit = {}
Fruit.__index = Fruit

function Fruit:create()
  this = {
    column = math.random(COLUMNS),
    row = math.random(ROWS),
    width = CELL_SIZE,
    height = CELL_SIZE,
    padding = math.floor(CELL_SIZE / 8)
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
  love.graphics.setColor(gColors["foreground"].r, gColors["foreground"].g, gColors["foreground"].b)
  love.graphics.rectangle(
    "fill",
    (self.column - 1) * CELL_SIZE + self.padding,
    (self.row - 1) * CELL_SIZE + self.padding,
    self.width - self.padding * 2,
    self.height - self.padding * 2
  )
end
