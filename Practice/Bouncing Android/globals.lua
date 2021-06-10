gFonts = {
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 48),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 20)
}

gImages = {
  ["android"] = love.graphics.newImage("res/graphics/android.png"),
  ["background"] = love.graphics.newImage("res/graphics/background.png"),
  ["buildings-1"] = love.graphics.newImage("res/graphics/buildings-1.png"),
  ["buildings-2"] = love.graphics.newImage("res/graphics/buildings-2.png"),
  ["buildings-3"] = love.graphics.newImage("res/graphics/buildings-3.png"),
  ["lollipop-1"] = love.graphics.newImage("res/graphics/lollipop-1.png"),
  ["lollipop-2"] = love.graphics.newImage("res/graphics/lollipop-2.png"),
  ["lollipop-3"] = love.graphics.newImage("res/graphics/lollipop-3.png"),
  ["lollipop-4"] = love.graphics.newImage("res/graphics/lollipop-4.png"),
  ["lollipop-5"] = love.graphics.newImage("res/graphics/lollipop-5.png"),
  ["lollipop-6"] = love.graphics.newImage("res/graphics/lollipop-6.png"),
  ["moon"] = love.graphics.newImage("res/graphics/moon.png")
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
