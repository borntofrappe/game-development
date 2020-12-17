-- good luck

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400
SPOTLIGHT_SPEED = 100
GHOST_SPEED = 50
GHOSTS = 10
SCALE_SPRITE = 2

function love.load()
  love.window.setTitle("Stencil — Hide")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
  love.graphics.setDefaultFilter("nearest")

  spotlight = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT / 2,
    ["r"] = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 6)
  }

  texture = love.graphics.newImage("ghost.png")
  local width = texture:getWidth() * SCALE_SPRITE
  local height = texture:getHeight() * SCALE_SPRITE

  ghosts = {}
  local ghostSize = math.floor(spotlight.r / 4)
  for i = 1, GHOSTS do
    local x = love.math.random(0, WINDOW_WIDTH)
    local y = love.math.random(0, WINDOW_HEIGHT)
    local dx = love.math.random(2) == 1 and 1 or -1
    local dy = love.math.random(2) == 1 and 1 or -1
    local ghost = {
      ["x"] = x,
      ["y"] = y,
      ["dx"] = dx,
      ["dy"] = dy,
      ["width"] = width,
      ["height"] = height
    }
    table.insert(ghosts, ghost)
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  if love.keyboard.isDown("up") then
    spotlight.y = math.max(0, spotlight.y - SPOTLIGHT_SPEED * dt)
  end
  if love.keyboard.isDown("right") then
    spotlight.x = math.min(WINDOW_WIDTH, spotlight.x + SPOTLIGHT_SPEED * dt)
  end
  if love.keyboard.isDown("down") then
    spotlight.y = math.min(WINDOW_HEIGHT, spotlight.y + SPOTLIGHT_SPEED * dt)
  end
  if love.keyboard.isDown("left") then
    spotlight.x = math.max(0, spotlight.x - SPOTLIGHT_SPEED * dt)
  end

  for i, ghost in ipairs(ghosts) do
    ghost.x = ghost.x + ghost.dx * dt * GHOST_SPEED
    ghost.y = ghost.y + ghost.dy * dt * GHOST_SPEED

    if ghost.x >= WINDOW_WIDTH then
      ghost.dx = -1
      ghost.x = WINDOW_WIDTH
    elseif ghost.x + ghost.width <= 0 then
      ghost.dx = 1
      ghost.x = -ghost.width
    end

    if ghost.y >= WINDOW_HEIGHT then
      ghost.dy = -1
      ghost.y = WINDOW_HEIGHT
    elseif ghost.y + ghost.height <= 0 then
      ghost.dy = 1
      ghost.y = -ghost.height
    end
  end

  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()
    spotlight.x = x
    spotlight.y = y
  end
end

local function stencilFunction()
  love.graphics.circle("fill", spotlight.x, spotlight.y, spotlight.r)
end

function love.draw()
  love.graphics.setColor(0.9, 0.68, 0.34)
  love.graphics.circle("fill", spotlight.x, spotlight.y, spotlight.r)

  love.graphics.stencil(stencilFunction, "replace", 1)
  love.graphics.setStencilTest("less", 1)

  love.graphics.setColor(1, 1, 1, 1)
  for i, ghost in ipairs(ghosts) do
    love.graphics.draw(texture, ghost.x, ghost.y, 0, SCALE_SPRITE, SCALE_SPRITE)
  end

  love.graphics.setStencilTest()
end
