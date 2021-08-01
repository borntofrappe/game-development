PlayState = BaseState:new()

function PlayState:enter()
  local balls = {}

  local r = BALL_SIZE

  local xStart = TABLE_PADDING + TABLE_INNER_WIDTH * 3 / 4
  local yStart = TABLE_PADDING + TABLE_INNER_HEIGHT / 2

  for i = 1, 6 do
    local angle = math.rad((i - 1) * 360 / 6 - 90)

    local x = xStart + math.cos(angle) * r * 2.5
    local y = yStart + math.sin(angle) * r * 2.5

    table.insert(
      balls,
      {
        ["number"] = #balls + 1,
        ["x"] = x,
        ["y"] = y,
        ["r"] = r,
        ["color"] = {
          ["r"] = math.random() ^ 0.35,
          ["g"] = math.random() ^ 0.35,
          ["b"] = math.random() ^ 0.35
        }
      }
    )
  end

  table.insert(
    balls,
    {
      ["number"] = #balls + 1,
      ["x"] = xStart,
      ["y"] = yStart,
      ["r"] = r,
      ["color"] = {
        ["r"] = math.random() ^ 0.35,
        ["g"] = math.random() ^ 0.35,
        ["b"] = math.random() ^ 0.35
      }
    }
  )

  self.balls = balls
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end
end

function PlayState:render()
  love.graphics.translate(TABLE_MARGIN, TABLE_MARGIN)

  love.graphics.setLineWidth(TABLE_LINE_WIDTH)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", 0, 0, TABLE_WIDTH, TABLE_HEIGHT, 24)
  love.graphics.rectangle("line", TABLE_PADDING, TABLE_PADDING, TABLE_INNER_WIDTH, TABLE_INNER_HEIGHT)

  love.graphics.circle("line", POCKET_PADDING, POCKET_PADDING, POCKET_RADIUS)
  love.graphics.circle("line", TABLE_WIDTH - POCKET_PADDING, POCKET_PADDING, POCKET_RADIUS)
  love.graphics.circle("line", TABLE_WIDTH / 2, POCKET_RADIUS, POCKET_RADIUS)
  love.graphics.circle("line", TABLE_WIDTH / 2, TABLE_HEIGHT - POCKET_RADIUS, POCKET_RADIUS)
  love.graphics.circle("line", TABLE_WIDTH - POCKET_PADDING, TABLE_HEIGHT - POCKET_PADDING, POCKET_RADIUS)
  love.graphics.circle("line", POCKET_PADDING, TABLE_HEIGHT - POCKET_PADDING, POCKET_RADIUS)

  love.graphics.setColor(0.18, 0.18, 0.19)
  love.graphics.setLineWidth(TABLE_PADDING - TABLE_LINE_WIDTH)
  love.graphics.rectangle(
    "line",
    TABLE_PADDING / 2,
    TABLE_PADDING / 2,
    TABLE_INNER_WIDTH + TABLE_PADDING,
    TABLE_INNER_HEIGHT + TABLE_PADDING,
    20
  )

  love.graphics.circle("fill", POCKET_PADDING, POCKET_PADDING, POCKET_INNER_RADIUS)
  love.graphics.circle("fill", TABLE_WIDTH - POCKET_PADDING, POCKET_PADDING, POCKET_INNER_RADIUS)
  love.graphics.circle("fill", TABLE_WIDTH / 2, POCKET_RADIUS, POCKET_INNER_RADIUS)
  love.graphics.circle("fill", TABLE_WIDTH / 2, TABLE_HEIGHT - POCKET_RADIUS, POCKET_INNER_RADIUS)
  love.graphics.circle("fill", TABLE_WIDTH - POCKET_PADDING, TABLE_HEIGHT - POCKET_PADDING, POCKET_INNER_RADIUS)
  love.graphics.circle("fill", POCKET_PADDING, TABLE_HEIGHT - POCKET_PADDING, POCKET_INNER_RADIUS)

  love.graphics.setLineWidth(4)
  for _, ball in ipairs(self.balls) do
    love.graphics.setColor(ball.color.r, ball.color.g, ball.color.b)
    love.graphics.circle("line", ball.x, ball.y, ball.r)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gFonts.normal)
    love.graphics.printf(ball.number, ball.x - ball.r, ball.y - gFonts.normal:getHeight() / 2, ball.r * 2, "center")
  end

  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", TABLE_PADDING + TABLE_INNER_WIDTH / 4, TABLE_PADDING + TABLE_INNER_HEIGHT / 2, BALL_SIZE)

  love.graphics.rectangle(
    "fill",
    TABLE_PADDING + TABLE_INNER_WIDTH / 4 - BALL_SIZE * 2 - CUE_WIDTH,
    TABLE_PADDING + TABLE_INNER_HEIGHT / 2 - 4,
    CUE_WIDTH,
    CUE_HEIGHT
  )
end
