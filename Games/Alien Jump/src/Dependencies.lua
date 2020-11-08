Class = require("res/lib/Class")
push = require("res/lib/push")
require("res/lib/Animation")

require("src/constants")
require("src/Utils")

require("src/Player")

require("src/StateStack")
require("src/states/BaseState")
require("src/states/game/StartState")
require("src/states/game/ScrollState")
require("src/states/game/PauseState")

require("src/StateMachine")
require("src/states/player/PlayerIdleState")
require("src/states/player/PlayerWalkState")
require("src/states/player/PlayerJumpState")
require("src/states/player/PlayerSquatState")

gTextures = {
  ["alien"] = love.graphics.newImage("res/graphics/blue_alien.png"),
  ["backgrounds"] = love.graphics.newImage("res/graphics/backgrounds.png")
}

gQuads = {
  ["alien"] = GenerateQuads(gTextures["alien"], ALIEN_WIDTH, ALIEN_HEIGHT),
  ["backgrounds"] = GenerateQuads(gTextures["backgrounds"], BACKGROUND_WIDTH, BACKGROUND_HEIGHT)
}
