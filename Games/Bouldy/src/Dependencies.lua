Timer = require "res/Timer"

require "src/constants"

require "src/gui/ProgressBar"
require "src/Bouldy"
require "src/Coin"
require "src/Cell"
require "src/Maze"

gColors = {
  ["dark"] = {
    ["r"] = 0.12,
    ["g"] = 0.12,
    ["b"] = 0.12
  },
  ["light"] = {
    ["r"] = 0.97,
    ["g"] = 0.97,
    ["b"] = 0.97
  },
  ["speed"] = {
    ["r"] = 0.19,
    ["g"] = 0.82,
    ["b"] = 0.67
  },
  ["coin"] = {
    ["r"] = 0.92,
    ["g"] = 0.82,
    ["b"] = 0.07
  }
}

gFonts = {
  ["normal"] = love.graphics.newFont("res/font.ttf", 16)
}

gTextures = {
  ["particle-debris"] = love.graphics.newImage("res/particle-debris.png"),
  ["particle-dust"] = love.graphics.newImage("res/particle-dust.png")
}
