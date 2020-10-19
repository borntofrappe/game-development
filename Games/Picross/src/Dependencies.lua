Class = require "res/lib/class"
Timer = require "res/lib/timer"

require "src/Levels"
require "src/Level"
require "src/Cell"

require "src/constants"

require "src/StateMachine"
require "src/states/BaseState"
require "src/states/StartState"
require "src/states/SelectState"
require "src/states/PlayState"

gFonts = {
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 72),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
}

gTextures = {
  ["background"] = love.graphics.newImage("res/graphics/background.png")
}

gColors = {
  ["text"] = {["r"] = 0.07, ["g"] = 0.07, ["b"] = 0.2, ["a"] = 1},
  ["shadow"] = {["r"] = 0.05, ["g"] = 0.05, ["b"] = 0.15, ["a"] = 0.2}
}
