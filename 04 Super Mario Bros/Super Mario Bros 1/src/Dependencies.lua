push = require("res/lib/push")
Class = require("res/lib/Class")

require("res/lib/Animation")

require("src/constants")
require("src/Utils")
require("src/LevelMaker")

require("src/Entity")
require("src/Player")

require("src/StateMachine")
require("src/states/BaseState")

require("src/states/game/StartState")
require("src/states/game/PlayState")

require("src/states/entities/player/PlayerIdleState")
require("src/states/entities/player/PlayerWalkingState")
require("src/states/entities/player/PlayerJumpState")
require("src/states/entities/player/PlayerFallingState")

gFonts = {
  ["small"] = love.graphics.newFont("res/fonts/font.ttf", 8),
  ["medium"] = love.graphics.newFont("res/fonts/font.ttf", 16),
  ["large"] = love.graphics.newFont("res/fonts/font.ttf", 32)
}

gTextures = {
  ["tiles"] = love.graphics.newImage("res/graphics/tiles.png"),
  ["tops"] = love.graphics.newImage("res/graphics/tile_tops.png"),
  ["backgrounds"] = love.graphics.newImage("res/graphics/backgrounds.png"),
  ["character"] = love.graphics.newImage("res/graphics/character.png")
}

gFrames = {
  ["tiles"] = GenerateQuadsTiles(gTextures["tiles"]),
  ["tops"] = GenerateQuadsTileTops(gTextures["tops"]),
  ["backgrounds"] = GenerateQuads(gTextures["backgrounds"], BACKGROUND_WIDTH, BACKGROUND_HEIGHT),
  ["character"] = GenerateQuads(gTextures["character"], PLAYER_WIDTH, PLAYER_HEIGHT)
}
