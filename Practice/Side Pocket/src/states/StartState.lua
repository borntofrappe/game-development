StartState = BaseState:new()

function StartState:enter()
  local balls = {}
  local columns = 3
  local rows = 1
  local r = 12

  local xStart = PLAYING_WIDTH * 3 / 4
  local yStart = PLAYING_HEIGHT / 2

  for column = 1, columns do
    for row = 1, rows do
      local ball = {
        ["x"] = xStart + (column - (columns - 1) / 2 - 1) * r * 2.5,
        ["y"] = yStart + (row - (rows - 1) / 2 - 1) * r * 2.5,
        ["r"] = r,
        ["color"] = {
          ["r"] = math.random() ^ 0.5,
          ["g"] = math.random() ^ 0.5,
          ["b"] = math.random() ^ 0.5
        }
      }

      table.insert(balls, ball)
    end
    rows = rows + 1
  end

  self.balls = balls
end

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end
end

function StartState:render()
  --table
  love.graphics.setColor(0.63, 0.63, 0.63)
  love.graphics.rectangle("fill", 0, 0, PLAYING_WIDTH, PLAYING_HEIGHT, 24)

  love.graphics.setColor(0.25, 0.39, 0.25)
  love.graphics.rectangle("fill", 28, 28, PLAYING_WIDTH - 56, PLAYING_HEIGHT - 56)

  love.graphics.setColor(0.49, 0.33, 0.28)
  love.graphics.rectangle("fill", 0, 28, 28, PLAYING_HEIGHT - 56)
  love.graphics.rectangle("fill", 28, 0, PLAYING_WIDTH - 56, 28)
  love.graphics.rectangle("fill", 28, PLAYING_HEIGHT - 28, PLAYING_WIDTH - 56, 28)
  love.graphics.rectangle("fill", PLAYING_WIDTH - 28, 28, 28, PLAYING_HEIGHT - 56)

  love.graphics.setColor(0.63, 0.63, 0.63)
  love.graphics.rectangle("fill", PLAYING_WIDTH / 2 - 20, 0, 40, 12)
  love.graphics.rectangle("fill", PLAYING_WIDTH / 2 - 20, PLAYING_HEIGHT - 12, 40, 12)

  love.graphics.setColor(0.12, 0.11, 0.12)
  love.graphics.circle("fill", 28, 28, 18)
  love.graphics.circle("fill", PLAYING_WIDTH - 28, 28, 18)
  love.graphics.circle("fill", PLAYING_WIDTH / 2, 22, 18)
  love.graphics.circle("fill", PLAYING_WIDTH / 2, PLAYING_HEIGHT - 22, 18)
  love.graphics.circle("fill", PLAYING_WIDTH - 28, PLAYING_HEIGHT - 28, 18)
  love.graphics.circle("fill", 28, PLAYING_HEIGHT - 28, 18)

  -- balls
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", PLAYING_WIDTH / 4, PLAYING_HEIGHT / 2, 14)

  for _, ball in ipairs(self.balls) do
    love.graphics.setColor(ball.color.r, ball.color.g, ball.color.b)
    love.graphics.circle("fill", ball.x, ball.y, ball.r)
  end
end
