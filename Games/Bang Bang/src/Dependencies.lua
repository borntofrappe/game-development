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
  ["bold"] = love.graphics.newFont("res/fonts/font-bold.ttf", 24),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 18)
}
