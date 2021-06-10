TitleScreenState = Class {__includes = BaseState}

local RADIUS_MULTIPLIER = 1.5
local INNER_RADIUS_CHANGE = 100

function TitleScreenState:init()
  self.title = "lollipop"
  self.radius = 0
  self.pressed = false

  self.radius = gFonts.big:getWidth(self.title) / 2 * RADIUS_MULTIPLIER

  self.innnerRadius = 0
  self.dinnnerRadius = INNER_RADIUS_CHANGE
end

function TitleScreenState:update(dt)
  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()

    if ((x - WINDOW_WIDTH / 2) ^ 2 + (y - WINDOW_HEIGHT / 2) ^ 2) ^ 0.5 < self.radius then
      self.pressed = true
      self.innnerRadius = math.min(self.innnerRadius + self.dinnnerRadius * dt, self.radius)

      if self.innnerRadius == self.radius then
        gStateMachine:change("waiting")
      end
    else
      self.innnerRadius = 0
      self.pressed = false
    end
  else
    self.innnerRadius = 0
    self.pressed = false
  end
end

function TitleScreenState:render()
  love.graphics.setColor(0.98, 0.98, 0.98)
  love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 9, WINDOW_HEIGHT / 2, 18, WINDOW_HEIGHT / 2)

  love.graphics.setColor(0.7, 0.2, 0.8)
  love.graphics.circle("fill", WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, self.radius)
  love.graphics.setColor(1, 1, 1, 0.1)
  love.graphics.circle(
    "fill",
    WINDOW_WIDTH / 2 + gFonts.big:getWidth(self.title) / 3.75,
    WINDOW_HEIGHT / 2 - gFonts.big:getWidth(self.title) / 3.75,
    gFonts.big:getWidth(self.title) / 4
  )

  if self.pressed then
    love.graphics.setColor(1, 1, 1, 0.1)
    love.graphics.circle("fill", WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, self.radius)

    love.graphics.setColor(1, 1, 1, 0.25)
    love.graphics.circle("fill", WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, self.innnerRadius)
  end

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.big)
  love.graphics.printf(self.title, 0, WINDOW_HEIGHT / 2 - gFonts.big:getHeight() / 2, WINDOW_WIDTH, "center")
end
