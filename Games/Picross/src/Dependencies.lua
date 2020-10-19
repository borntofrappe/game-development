Class = require "res/lib/class"

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
