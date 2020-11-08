Class = require("res/lib/Class")
push = require("res/lib/push")
require("res/lib/Animation")

require("src/constants")
require("src/Utils")

require("src/Player")
require("src/Bush")
require("src/Coin")
require("src/Creature")

require("src/StateStack")
require("src/states/BaseState")
require("src/states/game/StartState")
require("src/states/game/ScrollState")
require("src/states/game/PauseState")
require("src/states/game/GameoverState")

require("src/StateMachine")
require("src/states/player/PlayerIdleState")
require("src/states/player/PlayerWalkState")
require("src/states/player/PlayerJumpState")
require("src/states/player/PlayerSquatState")

gTextures = {
  ["alien"] = love.graphics.newImage("res/graphics/blue_alien.png"),
  ["bushes"] = love.graphics.newImage("res/graphics/bushes.png"),
  ["creatures_land"] = love.graphics.newImage("res/graphics/creatures_land.png"),
  ["creatures_sky"] = love.graphics.newImage("res/graphics/creatures_sky.png"),
  ["coins"] = love.graphics.newImage("res/graphics/coins.png"),
  ["backgrounds"] = love.graphics.newImage("res/graphics/backgrounds.png")
}

gQuads = {
  ["alien"] = GenerateQuads(gTextures["alien"], ALIEN_WIDTH, ALIEN_HEIGHT),
  ["bushes"] = GenerateQuadsObjects(gTextures["bushes"], BUSH_SIZE, BUSH_SIZE),
  ["coins"] = GenerateQuads(gTextures["coins"], COIN_SIZE, COIN_SIZE),
  ["creatures_land"] = GenerateQuadsObjects(gTextures["creatures_land"], CREATURE_SIZE, CREATURE_SIZE),
  ["creatures_sky"] = GenerateQuadsObjects(gTextures["creatures_sky"], CREATURE_SIZE, CREATURE_SIZE),
  ["backgrounds"] = GenerateQuads(gTextures["backgrounds"], BACKGROUND_WIDTH, BACKGROUND_HEIGHT)
}

gFonts = {
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
}

gSounds = {
  ["hit"] = love.audio.newSource("res/sounds/hit.wav", "static"),
  ["jump"] = love.audio.newSource("res/sounds/jump.wav", "static"),
  ["pickup"] = love.audio.newSource("res/sounds/pickup.wav", "static")
}
