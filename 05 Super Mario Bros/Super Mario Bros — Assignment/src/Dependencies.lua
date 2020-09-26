push = require("res/lib/push")
Class = require("res/lib/Class")

require("res/lib/Animation")

require("src/constants")
require("src/Utils")
require("src/LevelMaker")
require("src/GameLevel")

require("src/GameObject")
require("src/Entity")
require("src/Player")
require("src/Creature")

require("src/Tile")
require("src/TileMap")

require("src/StateMachine")
require("src/states/BaseState")

require("src/states/game/StartState")
require("src/states/game/PlayState")

require("src/states/entities/player/PlayerIdleState")
require("src/states/entities/player/PlayerWalkingState")
require("src/states/entities/player/PlayerJumpState")
require("src/states/entities/player/PlayerFallingState")

require("src/states/entities/creature/CreatureIdleState")
require("src/states/entities/creature/CreatureMovingState")
require("src/states/entities/creature/CreatureChasingState")

gFonts = {
  ["small"] = love.graphics.newFont("res/fonts/font.ttf", 8),
  ["medium"] = love.graphics.newFont("res/fonts/font.ttf", 16),
  ["large"] = love.graphics.newFont("res/fonts/font.ttf", 32)
}

gTextures = {
  ["tiles"] = love.graphics.newImage("res/graphics/tiles.png"),
  ["tops"] = love.graphics.newImage("res/graphics/tile_tops.png"),
  ["backgrounds"] = love.graphics.newImage("res/graphics/backgrounds.png"),
  ["character"] = love.graphics.newImage("res/graphics/character.png"),
  ["bushes_and_cacti"] = love.graphics.newImage("res/graphics/bushes_and_cacti.png"),
  ["gems"] = love.graphics.newImage("res/graphics/gems.png"),
  ["jump_blocks"] = love.graphics.newImage("res/graphics/jump_blocks.png"),
  ["creatures"] = love.graphics.newImage("res/graphics/creatures.png"),
  ["keys_and_locks"] = love.graphics.newImage("res/graphics/keys_and_locks.png"),
  ["flags"] = love.graphics.newImage("res/graphics/flags.png"),
  ["poles"] = love.graphics.newImage("res/graphics/poles.png")
}

gFrames = {
  ["tiles"] = GenerateQuadsTiles(gTextures["tiles"]),
  ["tops"] = GenerateQuadsTileTops(gTextures["tops"]),
  ["backgrounds"] = GenerateQuads(gTextures["backgrounds"], BACKGROUND_WIDTH, BACKGROUND_HEIGHT),
  ["character"] = GenerateQuads(gTextures["character"], PLAYER_WIDTH, PLAYER_HEIGHT),
  ["bushes_and_cacti"] = GenerateQuadsObjects(gTextures["bushes_and_cacti"], TILE_SIZE, TILE_SIZE),
  ["gems"] = GenerateQuadsObjects(gTextures["gems"], TILE_SIZE, TILE_SIZE),
  ["jump_blocks"] = GenerateQuadsObjects(gTextures["jump_blocks"], TILE_SIZE, TILE_SIZE),
  ["creatures"] = GenerateQuadsCreatures(gTextures["creatures"], TILE_SIZE, TILE_SIZE),
  ["keys_and_locks"] = GenerateQuadsObjects(gTextures["keys_and_locks"], TILE_SIZE, TILE_SIZE),
  ["flags"] = GenerateQuadsObjects(gTextures["flags"], FLAG_WIDTH, FLAG_HEIGHT),
  ["poles"] = GenerateQuadsObjects(gTextures["poles"], POLE_WIDTH, POLE_HEIGHT)
}

gSounds = {
  ["chasm"] = love.audio.newSource("res/sounds/chasm.wav", "static"),
  ["death"] = love.audio.newSource("res/sounds/death.wav", "static"),
  ["empty-block"] = love.audio.newSource("res/sounds/empty-block.wav", "static"),
  ["flag-reveal"] = love.audio.newSource("res/sounds/flag-reveal.wav", "static"),
  ["gem-reveal"] = love.audio.newSource("res/sounds/gem-reveal.wav", "static"),
  ["jump"] = love.audio.newSource("res/sounds/jump.wav", "static"),
  ["key-reveal"] = love.audio.newSource("res/sounds/key-reveal.wav", "static"),
  ["kill"] = love.audio.newSource("res/sounds/kill.wav", "static"),
  ["music"] = love.audio.newSource("res/sounds/music.wav", "static"),
  ["new-level"] = love.audio.newSource("res/sounds/new-level.wav", "static"),
  ["pickup"] = love.audio.newSource("res/sounds/pickup.wav", "static")
}
