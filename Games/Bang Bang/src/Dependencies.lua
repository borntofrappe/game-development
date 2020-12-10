require "src/constants"
require "src/Utils"

require "src/Terrain"
require "src/Cannon"
require "src/Cannonball"
require "src/Target"
require "src/Level"

require "src/gui/Button"
require "src/gui/Label"
require "src/gui/Menu"

require "src/states/BaseState"
require "src/states/TitleState"
require "src/states/PlayState"
require "src/StateMachine"

Timer = require "res/lib/Timer"

gTextures = {
  ["background"] = love.graphics.newImage("res/graphics/background.png"),
  ["cannon"] = love.graphics.newImage("res/graphics/cannon.png"),
  ["cannonball"] = love.graphics.newImage("res/graphics/cannonball.png"),
  ["gameover"] = love.graphics.newImage("res/graphics/gameover.png"),
  ["target"] = love.graphics.newImage("res/graphics/target.png"),
  ["title"] = love.graphics.newImage("res/graphics/title.png")
}

gQuads = {
  ["cannon"] = GenerateQuads(gTextures["cannon"], CANNON_WIDTH, CANNON_HEIGHT)
}

gFonts = {
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 42),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 22)
}

gColors = {
  ["dark"] = {
    ["r"] = 0.047,
    ["g"] = 0.062,
    ["b"] = 0.067
  },
  ["light"] = {
    ["r"] = 0.89,
    ["g"] = 0.89,
    ["b"] = 0.89
  }
}

function getNormalDistribution(x, mu, sigma)
  return 1 / (sigma * (2 * math.pi) ^ 0.5) * EULER_NUMBER ^ ((-1 / 2) * ((x - mu) / sigma) ^ 2)
end

function getTerrain()
  local yStart = love.math.random(math.floor(WINDOW_HEIGHT * 2 / 3), WINDOW_HEIGHT)
  local mu = love.math.random(MU_MIN, MU_MAX)
  local sigma = love.math.random(SIGMA_MIN, SIGMA_MAX)

  local points = {}
  local scale1 = love.math.random(NORMAL_DISTRIBUTION_SCALE_MIN, NORMAL_DISTRIBUTION_SCALE_MAX)
  local scale2 = yStart < WINDOW_HEIGHT * 3 / 4 and math.floor(scale1 * 1.5) or math.floor(scale1 * 0.75)
  for i = 1, POINTS + 1 do
    local x = (i - 1) * WINDOW_WIDTH / POINTS
    local dy = getNormalDistribution(x, mu, sigma)
    if x < mu then
      dy = dy * scale1
    else
      dy = dy * scale2 - (getNormalDistribution(mu, mu, sigma) * scale2 - getNormalDistribution(mu, mu, sigma) * scale1)
    end
    local y = yStart - dy
    table.insert(points, x)
    table.insert(points, y)
  end

  return points
end
