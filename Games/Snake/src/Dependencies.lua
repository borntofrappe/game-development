require "src/constants"

require "src/StateMachine"
require "src/states/BaseState"
require "src/states/StartState"
require "src/states/PlayState"
require "src/states/GameoverState"

require "src/Snake"
require "src/Tail"
require "src/Fruit"

gFonts = {
  ["large"] = love.graphics.newFont("res/font.ttf", 64),
  ["normal"] = love.graphics.newFont("res/font.ttf", 24)
}

gSounds = {
  ["gameover"] = love.audio.newSource("res/gameover.wav", "static"),
  ["score"] = love.audio.newSource("res/score.wav", "static")
}

gColors = {
  ["background"] = {
    ["r"] = 130 / 255,
    ["g"] = 163 / 255,
    ["b"] = 131 / 255
  },
  ["foreground"] = {
    ["r"] = 38 / 255,
    ["g"] = 37 / 255,
    ["b"] = 41 / 255
  }
}
