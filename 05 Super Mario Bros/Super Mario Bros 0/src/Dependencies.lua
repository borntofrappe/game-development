push = require("res/lib/push")
Class = require("res/lib/Class")
require("res/lib/Animation")

require("src/constants")
require("src/Utils")

require("src/Player")

require("src/LevelMaker")
require("src/StateMachine")
require("src/states/BaseState")
require("src/states/PlayState")

gTextures = {
  ["tiles"] = love.graphics.newImage("res/graphics/tiles.png"),
  ["tops"] = love.graphics.newImage("res/graphics/tile_tops.png"),
  ["backgrounds"] = love.graphics.newImage("res/graphics/backgrounds.png"),
  ["player"] = love.graphics.newImage("res/graphics/character.png")
}

gFrames = {
  ["tiles"] = GenerateQuadsTiles(gTextures["tiles"]),
  ["tops"] = GenerateQuadsTileTops(gTextures["tops"]),
  ["backgrounds"] = GenerateQuads(gTextures["backgrounds"], 256, 128),
  ["player"] = GenerateQuads(gTextures["player"], PLAYER_WIDTH, PLAYER_HEIGHT)
}
