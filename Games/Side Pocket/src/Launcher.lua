Launcher = {}
Launcher.__index = Launcher

function Launcher:new()
  this = {
    ["x"] = 8,
    ["y"] = 8,
    ["width"] = WINDOW_WIDTH / 2 + 16,
    ["height"] = WINDOW_HEIGHT / 3 - 16,
    ["lineWidth"] = 6,
    ["rx"] = 8
  }

  this.xLauncher = this.x + 16
  this.yLauncher = this.y + this.height / 2
  this.widthLauncher = this.width - 32
  this.heightLauncher = this.height / 2 - 16
  this.rxLauncher = this.rx * 2
  this.radiusLauncher = this.heightLauncher / 3
  this.paddingLauncher = 8
  this.percentageLauncher = 100

  setmetatable(this, self)
  return this
end

function Launcher:update(dt)
end

function Launcher:render()
  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.rx)

  love.graphics.setFont(gFonts["ui"])
  love.graphics.print(string.upper("Min"), self.x + 16, self.y + 16)
  for i = 1, 4 do
    love.graphics.rectangle(
      "fill",
      self.x + gFonts["ui"]:getWidth("min") + 54 + (i - 1) * 18,
      self.y + 14 + (4 - i) * 3,
      10,
      14 + (i) * 3,
      4
    )
  end
  love.graphics.print(string.upper("Max"), self.x + self.width - 24 - gFonts["ui"]:getWidth("max"), self.y + 16)

  love.graphics.setLineWidth(self.lineWidth - 2)
  love.graphics.rectangle(
    "line",
    self.xLauncher,
    self.yLauncher,
    self.widthLauncher,
    self.heightLauncher,
    self.rxLauncher
  )
  love.graphics.circle(
    "fill",
    self.xLauncher + self.paddingLauncher + self.radiusLauncher +
      (self.widthLauncher - self.radiusLauncher * 2 - self.paddingLauncher * 2) * self.percentageLauncher / 100,
    self.yLauncher + self.heightLauncher / 2,
    self.radiusLauncher
  )
end
