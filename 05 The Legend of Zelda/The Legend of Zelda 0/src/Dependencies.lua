push = require("res/lib/push")
Class = require("res/lib/Class")

require("src/constants")
require("src/Utils")

require("src/StateMachine")
require("src/states/BaseState")
require("src/states/TitleState")
require("src/states/PlayState")
require("src/states/GameoverState")

gTextures = {
  ["backgrounds"] = love.graphics.newImage("res/graphics/backgrounds.png")
}

gFrames = {
  ["backgrounds"] = GenerateQuads(gTextures["backgrounds"], VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
}

gFonts = {
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 32),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
}
