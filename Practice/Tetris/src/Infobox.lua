Infobox = {}

function Infobox:new(label, value, x, y, width, height)
  local padding = {
    ["x"] = gFont:getWidth("0"),
    ["y"] = math.floor(gFont:getHeight() / 2)
  }

  local this = {
    ["label"] = label,
    ["value"] = value,
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["padding"] = padding,
    ["rx"] = 4,
    ["lineWidth"] = 2
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Infobox:render()
  love.graphics.setColor(gColors[3].r, gColors[3].g, gColors[3].b)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.rx)
  love.graphics.setColor(gColors[4].r, gColors[4].g, gColors[4].b)
  love.graphics.rectangle(
    "fill",
    self.x + self.lineWidth,
    self.y + self.lineWidth,
    self.width - self.lineWidth * 2,
    self.height - self.lineWidth * 2,
    self.rx
  )

  love.graphics.setColor(gColors[1].r, gColors[1].g, gColors[1].b)
  love.graphics.print(self.label, self.x + self.padding.x, math.floor(self.y + self.padding.y))
  love.graphics.printf(
    self.value,
    self.x + self.padding.x,
    math.floor(self.y + self.height - self.padding.y - gFont:getHeight()),
    self.width - self.padding.x * 2,
    "right"
  )
end
