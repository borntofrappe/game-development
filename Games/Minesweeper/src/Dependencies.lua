require "src/constants"

require "src/Cell"
require "src/Grid"

gColors = {
  ["background-light"] = {
    ["r"] = 0.33,
    ["g"] = 0.54,
    ["b"] = 0.2
  },
  ["background-dark"] = {
    ["r"] = 0.29,
    ["g"] = 0.46,
    ["b"] = 0.18
  },
  ["cell-light"] = {
    ["r"] = 0.65,
    ["g"] = 0.83,
    ["b"] = 0.29
  },
  ["cell-dark"] = {
    ["r"] = 0.63,
    ["g"] = 0.81,
    ["b"] = 0.28
  },
  ["cell-revealed-light"] = {
    ["r"] = 0.89,
    ["g"] = 0.75,
    ["b"] = 0.63
  },
  ["cell-revealed-dark"] = {
    ["r"] = 0.84,
    ["g"] = 0.72,
    ["b"] = 0.6
  },
  ["mine"] = {
    ["r"] = 0.95,
    ["g"] = 0.21,
    ["b"] = 0.03
  },
  ["number-1"] = {
    ["r"] = 0.09,
    ["g"] = 0.46,
    ["b"] = 0.83
  },
  ["number-2"] = {
    ["r"] = 0.22,
    ["g"] = 0.55,
    ["b"] = 0.24
  },
  ["number-3"] = {
    ["r"] = 0.83,
    ["g"] = 0.18,
    ["b"] = 0.18
  }
}

gFonts = {
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 18),
  ["bold"] = love.graphics.newFont("res/fonts/font-bold.ttf", math.floor(CELL_SIZE / 1.5))
}

gTextures = {
  ["flag"] = love.graphics.newImage("res/graphics/flag.png"),
  ["stopwatch"] = love.graphics.newImage("res/graphics/stopwatch.png")
}