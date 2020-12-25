push = require("res/lib/push")
Class = require("res/lib/Class")

require("src/constants")
require("src/Utils")

require("src/Room")

require("src/StateMachine")
require("src/states/BaseState")
require("src/states/TitleState")
require("src/states/PlayState")
require("src/states/GameoverState")

gTextures = {
  ["backgrounds"] = love.graphics.newImage("res/graphics/backgrounds.png"),
  ["tilesheet"] = love.graphics.newImage("res/graphics/tilesheet.png"),
  ["hearts"] = love.graphics.newImage("res/graphics/hearts.png")
}

gFrames = {
  ["backgrounds"] = GenerateQuads(gTextures["backgrounds"], VIRTUAL_WIDTH, VIRTUAL_HEIGHT),
  ["tilesheet"] = GenerateQuads(gTextures["tilesheet"], TILE_SIZE, TILE_SIZE),
  ["hearts"] = GenerateQuads(gTextures["hearts"], TILE_SIZE, TILE_SIZE)
}

gFonts = {
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 32),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
}
