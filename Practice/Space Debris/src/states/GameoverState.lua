GameoverState = BaseState:new()

local DELAY = 5

function GameoverState:enter(params)
  self.timer = 0

  self.debris = params.debris
  self.seconds = string.format("%.2f", params.seconds)
  self.hasHighScore = true

  local x = params.x
  local y = params.y
  local dx = params.dx
  local dy = params.dy
  self.collision = Collision:new(x, y, dx, dy, dx * 3, dy * 3)
end

function GameoverState:update(dt)
  self.timer = self.timer + dt
  if self.timer >= DELAY then
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("start")
  end

  for k, deb in pairs(self.debris) do
    deb:update(dt)

    if deb.x < -deb.width or deb.x > VIRTUAL_WIDTH then
      table.remove(self.debris, k)
    end
  end

  self.collision:update(dt)
end

function GameoverState:render()
  for k, deb in pairs(self.debris) do
    deb:render()
  end

  self.collision:render()

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(
    self.seconds .. " seconds",
    0,
    VIRTUAL_HEIGHT / 2 - gFonts.large:getHeight(),
    VIRTUAL_WIDTH,
    "center"
  )

  if self.hasHighScore then
    love.graphics.setFont(gFonts.normal)

    love.graphics.printf(string.upper("High score"), 0, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, "center")
  end
end
