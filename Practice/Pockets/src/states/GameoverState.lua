GameoverState = BaseState:new()

function GameoverState:enter(params)
  self.ball = params.ball
  self.pockets = params.pockets
  self.data = params.data
end

function GameoverState:update(dt)
  if love.mouse.waspressed(1) then
    gStateMachine:change(
      "points",
      {
        ["ball"] = self.ball,
        ["pockets"] = self.pockets,
        ["data"] = self.data
      }
    )
  end
end

function GameoverState:render()
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
    "All done!",
    0,
    TABLE_INNER_HEIGHT / 2 - gFonts.large:getHeight() / 2,
    TABLE_INNER_WIDTH,
    "center"
  )
end
