gFonts = {
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 48),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 20)
}

gImages = {
  ["moon"] = love.graphics.newImage("res/graphics/moon.png"),
  ["buildings-1"] = love.graphics.newImage("res/graphics/buildings-1.png"),
  ["buildings-2"] = love.graphics.newImage("res/graphics/buildings-2.png"),
  ["buildings-3"] = love.graphics.newImage("res/graphics/buildings-3.png")
}

-- key, offset, speed
gParallax = {
  {
    key = "buildings-3",
    offset = 0,
    speed = 5
  },
  {
    key = "buildings-2",
    offset = 0,
    speed = 10
  },
  {
    key = "buildings-1",
    offset = 0,
    speed = 30
  }
}
