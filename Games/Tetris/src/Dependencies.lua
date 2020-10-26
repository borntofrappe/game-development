require "src/constants"
require "src/Utils"

require "src/Brick"
require "src/Tetriminos"

require "src/Panel"
require "src/DescriptionList"

gTextures = {
  ["tiles"] = love.graphics.newImage("res/tilesheet.png")
}

gFrames = {
  ["tiles"] = GenerateQuads(gTextures.tiles, TILE_SIZE, TILE_SIZE)
}

gFonts = {
  ["normal"] = love.graphics.newFont("res/font.ttf", 14),
  ["small"] = love.graphics.newFont("res/font.ttf", 12)
}

gColors = {
  ["background"] = {["r"] = 0.07, ["g"] = 0.07, ["b"] = 0.07, ["a"] = 1},
  ["text"] = {["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 1}
}
