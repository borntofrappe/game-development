VictoryState = BaseState:new()

local TWEEN_OPACITY = 0.2

function VictoryState:enter(params)
  self.terrain = params.terrain
  self.cannon = params.cannon

  local instruction = "Continue"
  local width = gFonts.normal:getWidth(instruction) * 2
  local height = gFonts.normal:getHeight() * 2

  self.button =
    Button:new(
    WINDOW_WIDTH / 2 - width / 2,
    WINDOW_HEIGHT / 2 + 26,
    width,
    height,
    instruction,
    function()
      gStateMachine:change("play")
    end
  )
end

function VictoryState:update(dt)
  local x, y = love.mouse:getPosition()
  if x > self.cannon.x and x < WINDOW_WIDTH and y > 0 and y < self.cannon.y then
    local angle = math.atan((self.cannon.y - y) / (x - self.cannon.x))
    self.cannon.angle = math.max(math.min(ANGLE.max, angle * 180 / math.pi), ANGLE.min)
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("play")
  end

  if love.mouse.waspressed(2) or love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  self.button:update()
end

function VictoryState:render()
  self.cannon:render()
  self.terrain:render()

  love.graphics.setColor(0.18, 0.19, 0.26)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(
    string.upper("Congrats"),
    0,
    WINDOW_HEIGHT / 2 - gFonts.large:getHeight(),
    WINDOW_WIDTH,
    "center"
  )

  love.graphics.setFont(gFonts.normal)
  self.button:render()
end
