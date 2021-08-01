PlayState = BaseState:new()

function PlayState:enter()
  local balls = {}
  local columns = 3
  local rows = 1
  local r = 12

  local xStart = TABLE_WIDTH * 3 / 4
  local yStart = TABLE_HEIGHT / 2

  for column = 1, columns do
    for row = 1, rows do
      local ball = {
        ["x"] = xStart + (column - (columns - 1) / 2 - 1) * r * 2.5,
        ["y"] = yStart + (row - (rows - 1) / 2 - 1) * r * 2.5,
        ["r"] = r,
        ["color"] = {
          ["r"] = math.random() ^ 0.35,
          ["g"] = math.random() ^ 0.35,
          ["b"] = math.random() ^ 0.35
        }
      }

      table.insert(balls, ball)
    end
    rows = rows + 1
  end

  self.balls = balls
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end
end

function PlayState:render()
  love.graphics.translate(TABLE_MARGIN, TABLE_MARGIN)

  love.graphics.setLineWidth(6)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", 0, 0, TABLE_WIDTH, TABLE_HEIGHT, 24)
  love.graphics.rectangle("line", 16, 16, TABLE_WIDTH - 32, TABLE_HEIGHT - 32, 24)

  love.graphics.circle("line", 26, 26, 18)
  love.graphics.circle("line", TABLE_WIDTH - 26, 26, 18)
  love.graphics.circle("line", TABLE_WIDTH / 2, 18, 18)
  love.graphics.circle("line", TABLE_WIDTH / 2, TABLE_HEIGHT - 18, 18)
  love.graphics.circle("line", TABLE_WIDTH - 26, TABLE_HEIGHT - 26, 18)
  love.graphics.circle("line", 26, TABLE_HEIGHT - 26, 18)

  love.graphics.setColor(0.18, 0.18, 0.18)
  love.graphics.setLineWidth(12)
  love.graphics.rectangle("line", 8, 8, TABLE_WIDTH - 16, TABLE_HEIGHT - 16, 24)

  love.graphics.circle("fill", 26, 26, 15)
  love.graphics.circle("fill", TABLE_WIDTH - 26, 26, 15)
  love.graphics.circle("fill", TABLE_WIDTH / 2, 18, 15)
  love.graphics.circle("fill", TABLE_WIDTH / 2, TABLE_HEIGHT - 18, 15)
  love.graphics.circle("fill", TABLE_WIDTH - 26, TABLE_HEIGHT - 26, 15)
  love.graphics.circle("fill", 26, TABLE_HEIGHT - 26, 15)

  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", 16 + (TABLE_WIDTH - 32) / 4, TABLE_HEIGHT / 2, 14)

  love.graphics.setLineWidth(4)
  for _, ball in ipairs(self.balls) do
    love.graphics.setColor(ball.color.r, ball.color.g, ball.color.b)
    love.graphics.circle("line", ball.x, ball.y, ball.r)
  end
end
