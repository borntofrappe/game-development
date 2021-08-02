PointsState = BaseState:new()

function PointsState:enter(params)
  self.ball = params.ball
  self.pockets = params.pockets
  self.data = params.data

  local points = self.data.ballsPocketed * 50 - self.data.ballPocketed * 50
  for _, pocket in pairs(self.pockets) do
    if pocket.color then
      points = points + 100
    end
  end

  self.points = points
end

function PointsState:update(dt)
  if love.mouse.waspressed(1) then
    gStateMachine:change("start")
  end
end

function PointsState:render()
  love.graphics.setColor(self.ball.color.r, self.ball.color.g, self.ball.color.b)
  love.graphics.circle("fill", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius())

  for _, pocket in pairs(self.pockets) do
    if pocket.color then
      love.graphics.setColor(pocket.color.r, pocket.color.g, pocket.color.b)
      love.graphics.circle("fill", pocket.x, pocket.y, BALL_SIZE)
    end
  end

  love.graphics.setColor(gColors.ui.r, gColors.ui.g, gColors.ui.b)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(
    self.points .. " Points",
    0,
    TABLE_INNER_HEIGHT / 2 - gFonts.large:getHeight() / 2,
    TABLE_INNER_WIDTH,
    "center"
  )
end
