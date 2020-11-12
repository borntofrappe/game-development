require "src/Dependencies"

function makeTerrain()
  local terrain = {}
  local offset = love.math.random(1000)
  local increment = 0.1
  local points = 50
  local terrainHeightRandom = love.math.random(15, 30)
  local terrainHeightNoise = WINDOW_HEIGHT / 2 - terrainHeightRandom

  for i = 0, points do
    local x = i * WINDOW_WIDTH / points
    local y = WINDOW_HEIGHT - (love.math.noise(offset) * terrainHeightNoise + love.math.random() * terrainHeightRandom)

    table.insert(terrain, x)
    table.insert(terrain, y)

    offset = offset + increment
  end

  return terrain
end

function love.load()
  love.window.setTitle("Lunar Lander")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.05, 0.05, 0.05)

  terrain = makeTerrain()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.setLineWidth(1)
  love.graphics.line(terrain)
end
