ProgressBar = {}

function ProgressBar:new(x, y, width, height)
  local panel = Panel:new(x, y, width, height)

  local this = {
    ["panel"] = panel
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function ProgressBar:render()
  self.panel:render()
end
