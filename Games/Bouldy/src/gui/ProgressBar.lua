ProgressBar = {}
ProgressBar.__index = ProgressBar

function ProgressBar:new(x, y, width, height, progress)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["progress"] = progress or 0,
    ["padding"] = {
      ["x"] = 4,
      ["y"] = 4
    }
  }

  setmetatable(this, self)
  return this
end

function ProgressBar:setProgress(progress)
  self.progress = progress
end

function ProgressBar:render()
  love.graphics.setColor(gColors["light"].r, gColors["light"].g, gColors["light"].b, 1)

  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

  love.graphics.rectangle(
    "fill",
    self.x + self.padding.x,
    self.y + self.padding.y,
    (self.width - self.padding.x * 2) * (self.progress / 100),
    self.height - self.padding.y * 2
  )
end
