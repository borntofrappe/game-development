local WINDOW_WIDTH = 520
local WINDOW_HEIGHT = 380
local WINDOW_PADDING = 20

local UPDATE_SPEED = 300
local RADIUS_MAX = ((WINDOW_WIDTH ^ 2 + WINDOW_HEIGHT ^ 2) ^ 0.5) / 2
local radius = RADIUS_MAX

local isTransitioning = false
local isHidden = false

function love.load()
  love.window.setTitle("Stencil Transition")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0, 0, 0)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    if not isTransitioning then
      isTransitioning = true
    end
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    if not isTransitioning then
      isTransitioning = true
    end
  end
end

function love.update(dt)
  if isTransitioning then
    if isHidden then
      radius = math.min(RADIUS_MAX, radius + dt * UPDATE_SPEED)
    else
      radius = math.max(0, radius - dt * UPDATE_SPEED)
    end
    if radius == 0 then
      isHidden = true
    end
    if radius == RADIUS_MAX then
      isHidden = false
      isTransitioning = false
    end
  end
end

local function stencilFunction()
  love.graphics.circle("fill", WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, radius)
end

function love.draw()
  love.graphics.stencil(stencilFunction, "replace", 1)

  love.graphics.setStencilTest("greater", 0)

  love.graphics.setColor(0.694, 0.659, 0.624)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setColor(0.392, 0.322, 0.255)
  love.graphics.rectangle(
    "line",
    WINDOW_PADDING,
    WINDOW_PADDING,
    WINDOW_WIDTH - WINDOW_PADDING * 2,
    WINDOW_HEIGHT - WINDOW_PADDING * 2
  )

  love.graphics.circle("fill", WINDOW_PADDING, WINDOW_PADDING, 10)
  love.graphics.circle("fill", WINDOW_WIDTH - WINDOW_PADDING, WINDOW_HEIGHT - WINDOW_PADDING, 10)
  love.graphics.circle("fill", WINDOW_PADDING, WINDOW_HEIGHT - WINDOW_PADDING, 10)
  love.graphics.circle("fill", WINDOW_WIDTH - WINDOW_PADDING, WINDOW_PADDING, 10)
  love.graphics.printf("Stencil Transition\nOn click\nOn key press", 0, WINDOW_HEIGHT / 2 - 24, WINDOW_WIDTH, "center")

  love.graphics.setStencilTest()
end
