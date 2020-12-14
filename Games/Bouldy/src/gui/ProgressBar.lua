ProgressBar = {}
ProgressBar.__index = ProgressBar

function ProgressBar:new(x, y, width, height, label)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["progress"] = {
      ["max"] = PROGRESS_MAX,
      ["step"] = math.floor(PROGRESS_MAX / PROGRESS_STEPS),
      ["value"] = PROGRESS_INITIAL
    },
    ["padding"] = {
      ["x"] = 4,
      ["y"] = 4
    },
    ["colorFill"] = label,
    ["colorStroke"] = "light"
  }

  setmetatable(this, self)
  return this
end

function ProgressBar:render()
  love.graphics.setColor(gColors[self.colorFill].r, gColors[self.colorFill].g, gColors[self.colorFill].b, 1)

  love.graphics.rectangle(
    "fill",
    self.x + self.padding.x,
    self.y + self.padding.y,
    (self.width - self.padding.x * 2) * (self.progress.value / self.progress.max),
    self.height - self.padding.y * 2
  )

  if self.progress.value ~= self.progress.max then
    love.graphics.setColor(gColors["light"].r, gColors["light"].g, gColors["light"].b, 1)
  end
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
