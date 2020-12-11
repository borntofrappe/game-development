require "src/constants"
require "src/Utils"

require "src/Terrain"
require "src/Cannon"
require "src/Cannonball"
require "src/Target"
require "src/Level"

require "src/gui/Panel"
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
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 46),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 22)
}

gColors = {
  ["dark"] = {
    ["r"] = 0.12,
    ["g"] = 0.13,
    ["b"] = 0.12
  },
  ["light"] = {
    ["r"] = 0.97,
    ["g"] = 0.93,
    ["b"] = 0.86
  }
}
