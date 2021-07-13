ProgressBar = {}

function ProgressBar:new(x, y, width, height, stroke, fill, progress)
  local padding = math.floor(math.min(width, height) * 0.25)
  local innerX = x + padding
  local innerY = y + padding
  local innerWidth = width - padding * 2
  local innerHeight = height - padding * 2

  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["innerX"] = innerX,
    ["innerY"] = innerY,
    ["innerWidth"] = innerWidth,
    ["innerHeight"] = innerHeight,
    ["stroke"] = stroke,
    ["fill"] = fill,
    ["progress"] = progress
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function ProgressBar:render()
  love.graphics.setColor(self.fill.r, self.fill.g, self.fill.b)
  love.graphics.rectangle("fill", self.innerX, self.innerY, self.innerWidth * self.progress, self.innerHeight)

  if self.progress == 1 then
    love.graphics.setColor(self.fill.r, self.fill.g, self.fill.b)
  else
    love.graphics.setColor(self.stroke.r, self.stroke.g, self.stroke.b)
  end
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
