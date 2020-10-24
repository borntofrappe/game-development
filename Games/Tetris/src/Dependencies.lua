require "src/constants"
require "src/Utils"

require "src/Tetriminos"

gTextures = {
  ["tiles"] = love.graphics.newImage("res/tilesheet.png")
}

gFrames = {
  ["tiles"] = GenerateQuads(gTextures.tiles, TILE_SIZE, TILE_SIZE)
}

gFonts = {
  ["big"] = love.graphics.newFont("res/font.ttf", 36),
  ["normal"] = love.graphics.newFont("res/font.ttf", 20),
  ["small"] = love.graphics.newFont("res/font.ttf", 14)
}
