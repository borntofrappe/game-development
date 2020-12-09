require "src/constants"
require "src/Utils"

require "src/states/BaseState"
require "src/states/TitleState"
require "src/states/PlayState"
require "src/StateMachine"

Timer = require "res/lib/Timer"

gTextures = {
  ["title"] = love.graphics.newImage("res/graphics/title.png"),
  ["background"] = love.graphics.newImage("res/graphics/background.png"),
  ["cannon"] = love.graphics.newImage("res/graphics/cannon.png"),
  ["cannonball"] = love.graphics.newImage("res/graphics/cannonball.png")
}

gQuads = {
  ["cannon"] = GenerateQuads(gTextures["cannon"], CANNON_WIDTH, CANNON_HEIGHT)
}

gFonts = {
  ["title"] = love.graphics.newFont("res/fonts/font-title.ttf", 36),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 18)
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
