push = require "res/lib/push"
Class = require "res/lib/Class"
Timer = require "res/lib/timer"

require "src/constants"
require "src/Utils"

require "src/Tile"

require "src/StateStack"
require "src/states/BaseState"
require "src/states/FadeState"
require "src/states/StartState"
require "src/states/PlayState"
require "src/states/DialogueState"

gTextures = {
  ["pokemon"] = {
    ["aardart"] = {
      ["back"] = love.graphics.newImage("res/graphics/pokemon/aardart-back.png"),
      ["front"] = love.graphics.newImage("res/graphics/pokemon/aardart-front.png")
    },
    ["agnite"] = {
      ["back"] = love.graphics.newImage("res/graphics/pokemon/agnite-back.png"),
      ["front"] = love.graphics.newImage("res/graphics/pokemon/agnite-front.png")
    },
    ["anoleaf"] = {
      ["back"] = love.graphics.newImage("res/graphics/pokemon/anoleaf-back.png"),
      ["front"] = love.graphics.newImage("res/graphics/pokemon/anoleaf-front.png")
    },
    ["bamboon"] = {
      ["back"] = love.graphics.newImage("res/graphics/pokemon/bamboon-back.png"),
      ["front"] = love.graphics.newImage("res/graphics/pokemon/bamboon-front.png")
    },
    ["cardiwing"] = {
      ["back"] = love.graphics.newImage("res/graphics/pokemon/cardiwing-back.png"),
      ["front"] = love.graphics.newImage("res/graphics/pokemon/cardiwing-front.png")
    }
  },
  ["sheet"] = love.graphics.newImage("res/graphics/sheet.png")
}

gFrames = {
  ["sheet"] = GenerateQuads(gTextures["sheet"], TILE_SIZE, TILE_SIZE)
}

gFonts = {
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 48),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24),
  ["small"] = love.graphics.newFont("res/fonts/font.ttf", 16)
}
