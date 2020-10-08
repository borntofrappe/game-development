push = require "res/lib/push"
Class = require "res/lib/Class"
Timer = require "res/lib/timer"

require "src/constants"

require "src/StateStack"
require "src/states/BaseState"
require "src/states/StartState"

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
  }
}

gFonts = {
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 48),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24),
  ["small"] = love.graphics.newFont("res/fonts/font.ttf", 16)
}
