ProgressBar = {}

local PROGRESS_STEPS = 20

function ProgressBar:new(x, y, width, height)
  local panel = Panel:new(x, y, width, height)

  local xStep = 0
  local steps = {}
  for i = 1, PROGRESS_STEPS - 1 do
    local id = i % 2 == 1 and 1 or 2
    local widthStep = PROGRESS_WIDTHS[id]
    xStep = xStep + widthStep

    table.insert(
      steps,
      {
        ["x"] = x + width - xStep - 1,
        ["y"] = y,
        ["width"] = widthStep,
        ["id"] = id
      }
    )
  end

  local step = {
    ["x"] = x + width - PROGRESS_WIDTHS[3] - 1,
    ["width"] = PROGRESS_WIDTHS[3],
    ["y"] = y,
    ["id"] = 3
  }

  local this = {
    ["panel"] = panel,
    ["steps"] = steps,
    ["step"] = step,
    ["index"] = 0
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function ProgressBar:reset()
  self.index = 0
end

function ProgressBar:increase()
  local index = math.min(self.index + 1, PROGRESS_STEPS)
  local width = 0

  for i = 1, index - 1 do
    width = width + self.steps[i].width
  end

  self.step.x = self.panel.x + self.panel.width - self.step.width - width - 1
  self.step.id = index % 2 == 0 and 3 or 4
  self.index = index

  return self.index == PROGRESS_STEPS
end

function ProgressBar:render()
  self.panel:render()
  love.graphics.setColor(1, 1, 1)

  if self.index > 0 then
    for i = 1, self.index - 1 do
      love.graphics.draw(gTextures.spritesheet, gQuads.progressBar[self.steps[i].id], self.steps[i].x, self.steps[i].y)
    end
    love.graphics.draw(gTextures.spritesheet, gQuads.progressBar[self.step.id], self.step.x, self.step.y)
  end
end
