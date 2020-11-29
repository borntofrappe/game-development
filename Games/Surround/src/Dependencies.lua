Timer = require "res/Timer"

require "src/constants"
require "src/Player"

require "src/StateMachine"
require "src/states/BaseState"
require "src/states/StartState"
require "src/states/PlayState"
require "src/states/VictoryState"

gFonts = {
  ["big"] = love.graphics.newFont("res/font.ttf", 54),
  ["normal"] = love.graphics.newFont("res/font.ttf", 16)
}
