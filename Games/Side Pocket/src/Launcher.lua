Launcher = {}
Launcher.__index = Launcher

function Launcher:new()
  local panel =
    Panel:new(
    {
      ["x"] = 8,
      ["y"] = 8,
      ["width"] = WINDOW_WIDTH / 2,
      ["height"] = WINDOW_HEIGHT / 3,
      ["lineWidth"] = 6,
      ["rx"] = 16
    }
  )
  local slider =
    Slider:new(
    {
      ["x"] = panel.x + 16,
      ["y"] = panel.y + panel.height / 2 + 12,
      ["width"] = panel.width - 32,
      ["height"] = panel.height / 2 - 28,
      ["lineWidth"] = 4,
      ["rx"] = 16,
      ["offset"] = 8,
      ["radius"] = (panel.height / 2 - 28) / 3,
      ["value"] = 0,
      ["direction"] = 1
    }
  )

  this = {
    ["panel"] = panel,
    ["slider"] = slider
  }

  setmetatable(this, self)
  return this
end

function Launcher:update(dt)
  self.slider:update(dt)
end

function Launcher:getValue()
  return math.floor(self.slider.value)
end

function Launcher:reset()
  self.slider.value = 0
end

function Launcher:render()
  self.panel:render()
  self.slider:render()

  love.graphics.setColor(0.9, 0.9, 0.9)
  love.graphics.setFont(gFonts["ui"])
  love.graphics.print("MIN", self.panel.x + 16, self.slider.y - 20 - gFonts["ui"]:getHeight())
  love.graphics.print(
    "MAX",
    self.panel.x + self.panel.width - 16 - gFonts["ui"]:getWidth("MAX"),
    self.slider.y - 20 - gFonts["ui"]:getHeight()
  )
  for i = 1, 5 do
    love.graphics.rectangle(
      "fill",
      self.panel.x + 16 + gFonts["ui"]:getWidth("MIN") + 16 +
        (i - 1) * (self.panel.width - 48 - gFonts["ui"]:getWidth("MINMAX")) / 5,
      self.slider.y - 24 - 12 - (i - 1) * 3,
      12,
      12 + (i - 1) * 3,
      4
    )
  end
end
