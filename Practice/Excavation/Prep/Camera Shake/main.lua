local WINDOW_WIDTH = 520
local WINDOW_HEIGHT = 380
local WINDOW_PADDING = 20

local OFFSETS = 20
local ITERATIONS = 2
local offsets = {}
local angle = math.pi * 2 * iterations
local increment = angle / OFFSETS

for a = 0, angle, increment do
  table.insert(offsets, math.sin(a))
end

local DURATION = 0.5
local index = 1
local interval = DURATION / OFFSETS
local timer = 0

local isShaking = false

-- visual debugging
local Y_OFFSET = 100
local offsetLine = {}
for i, offset in ipairs(offsets) do
  table.insert(offsetLine, (i - 1) * WINDOW_WIDTH / (#offsets - 1))
  table.insert(offsetLine, WINDOW_HEIGHT / 2 + offset * Y_OFFSET)
end

function love.load()
  love.window.setTitle("Camera Shake")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.694, 0.659, 0.624)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    if not isShaking then
      index = 1
      isShaking = true
    end
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "return" then
    if not isShaking then
      index = 1
      isShaking = true
    end
  end
end

function love.update(dt)
  if isShaking then
    timer = timer + dt
    if timer > interval then
      timer = timer % interval
      index = index + 1
      if index == #offsets then
        isShaking = false
      end
    end
  end
end

function love.draw()
  love.graphics.translate(offsets[index], 0)

  -- -- visual debugging
  -- love.graphics.line(offsetLine)

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
  love.graphics.printf("Camera shake\nOn click\nOn key press", 0, WINDOW_HEIGHT / 2 - 24, WINDOW_WIDTH, "center")
end
