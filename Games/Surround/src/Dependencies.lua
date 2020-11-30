Timer = require "res/lib/Timer"

require "src/constants"
require "src/Player"

require "src/StateMachine"
require "src/states/BaseState"
require "src/states/StartState"
require "src/states/PlayState"
require "src/states/GameoverState"

gFonts = {
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 54),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
}

gSounds = {
  ["gameover"] = love.audio.newSource("res/sounds/gameover.wav", "static"),
  ["select"] = love.audio.newSource("res/sounds/select.wav", "static"),
  ["turn"] = love.audio.newSource("res/sounds/turn.wav", "static")
}
