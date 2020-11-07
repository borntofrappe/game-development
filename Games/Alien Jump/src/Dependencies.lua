Class = require("res/lib/Class")
push = require("res/lib/push")
require("res/lib/Animation")

require("src/constants")
require("src/Utils")

gTextures = {
  ["alien"] = love.graphics.newImage("res/graphics/blue_alien.png"),
  ["backgrounds"] = love.graphics.newImage("res/graphics/backgrounds.png")
}

gQuads = {
  ["alien"] = GenerateQuads(gTextures["alien"], ALIEN_WIDTH, ALIEN_HEIGHT),
  ["backgrounds"] = GenerateQuads(gTextures["backgrounds"], BACKGROUND_WIDTH, BACKGROUND_HEIGHT)
}
