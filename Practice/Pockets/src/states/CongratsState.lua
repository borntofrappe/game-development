CongratsState = BaseState:new()

function CongratsState:enter(params)
  self.ball = params.ball
  self.pockets = params.pockets
end

function CongratsState:update(dt)
  if love.mouse.waspressed(1) then
    gStateMachine:change("start")
  end
end

function CongratsState:render()
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
    "Well done!",
    0,
    TABLE_INNER_HEIGHT / 2 - gFonts.large:getHeight() / 2,
    TABLE_INNER_WIDTH,
    "center"
  )
end
