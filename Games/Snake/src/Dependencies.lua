require "src/constants"

require "src/StateMachine"
require "src/states/BaseState"
require "src/states/StartState"
require "src/states/PlayState"

require "src/states/Snake"
require "src/states/Fruit"

gFonts = {
  ["large"] = love.graphics.newFont("res/font.ttf", 64),
  ["normal"] = love.graphics.newFont("res/font.ttf", 24)
}

gColors = {
  ["background"] = {
    ["r"] = 13 / 255,
    ["g"] = 13 / 255,
    ["b"] = 13 / 255
  },
  ["foreground"] = {
    ["r"] = 212 / 255,
    ["g"] = 185 / 255,
    ["b"] = 141 / 255
  },
  ["snake"] = {
    ["r"] = 113 / 255,
    ["g"] = 159 / 255,
    ["b"] = 160 / 255
  },
  ["fruit"] = {
    ["r"] = 222 / 255,
    ["g"] = 99 / 255,
    ["b"] = 78 / 255
  }
}
