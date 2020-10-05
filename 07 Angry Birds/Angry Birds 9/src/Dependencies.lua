push = require "res/lib/push"
Class = require "res/lib/Class"

require "src/constants"
require "src/Utils"

require "src/Alien"
require "src/Obstacle"

require "src/StateMachine"
require "src/states/BaseState"
require "src/states/StartState"
require "src/states/PlayState"

gTextures = {
  ["aliens"] = love.graphics.newImage("res/graphics/aliens.png"),
  ["background"] = love.graphics.newImage("res/graphics/background.png"),
  ["obstacles"] = love.graphics.newImage("res/graphics/obstacles.png")
}

gFrames = {
  ["aliens"] = GenerateQuadsAliens(gTextures["aliens"]),
  ["background"] = GenerateQuadsBackground(gTextures["background"]),
  ["obstacles"] = GenerateQuadsObstacles(gTextures["obstacles"])
}

gFonts = {
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 56),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
}
