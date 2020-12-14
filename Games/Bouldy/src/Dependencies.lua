Timer = require "res/lib/Timer"

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
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
}

gTextures = {
  ["particle-debris"] = love.graphics.newImage("res/graphics/particle-debris.png"),
  ["particle-dust"] = love.graphics.newImage("res/graphics/particle-dust.png")
}

gSounds = {
  ["bouldy"] = love.audio.newSource("res/sounds/bouldy.wav", "static"),
  ["bounce"] = love.audio.newSource("res/sounds/bounce.wav", "static"),
  ["coin"] = love.audio.newSource("res/sounds/coin.wav", "static"),
  ["gameover"] = love.audio.newSource("res/sounds/gameover.wav", "static"),
  ["gate"] = love.audio.newSource("res/sounds/gate.wav", "static"),
  ["speed"] = love.audio.newSource("res/sounds/speed.wav", "static")
}
