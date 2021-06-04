ProgressBar = {}
ProgressBar.__index = ProgressBar

function ProgressBar:new(x, y, width, height, value, max, steps, colorFill)
  local step = math.floor(max / steps)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["progress"] = {
      ["value"] = value,
      ["max"] = max,
      ["steps"] = steps,
      ["step"] = step
    },
    ["padding"] = {
      ["x"] = 4,
      ["y"] = 4
    },
    ["colorFill"] = colorFill or "light",
    ["colorStroke"] = "light"
  }

  setmetatable(this, self)
  return this
end

function ProgressBar:render()
  love.graphics.setColor(gColors[self.colorStroke].r, gColors[self.colorStroke].g, gColors[self.colorStroke].b, 1)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

  love.graphics.setColor(gColors[self.colorFill].r, gColors[self.colorFill].g, gColors[self.colorFill].b, 1)

  love.graphics.rectangle(
    "fill",
    self.x + self.padding.x,
    self.y + self.padding.y,
    (self.width - self.padding.x * 2) * (self.progress.value / self.progress.max),
    self.height - self.padding.y * 2
  )
end