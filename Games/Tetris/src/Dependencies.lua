require "src/constants"
require "src/Utils"

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
