ProgressBar = {}

local PROGRESS_FRAGMENTS = 20

function ProgressBar:new(x, y, width, height)
  local panel = Panel:new(x, y, width, height)

  -- position n-1 fragments from the end of the progress bar and leftwards
  local xStep = 0
  local fragments = {}
  for i = 1, PROGRESS_FRAGMENTS - 1 do
    local id = i % 2 == 1 and 1 or 2
    local widthStep = PROGRESS_WIDTHS[id]
    xStep = xStep + widthStep

    table.insert(
      fragments,
      {
        ["x"] = x + width - xStep - 1, -- -1 for the outline of the panel
        ["y"] = y,
        ["width"] = widthStep,
        ["id"] = id
      }
    )
  end

  -- position the nth fragment as the last fragment
  local fragment = {
    ["x"] = x + width - PROGRESS_WIDTHS[3] - 1, -- -1 for the outline of the panel
    ["width"] = PROGRESS_WIDTHS[3],
    ["y"] = y,
    ["id"] = 3
  }

  local this = {
    ["panel"] = panel,
    ["fragments"] = fragments,
    ["fragment"] = fragment,
    ["index"] = 0,
    ["progress"] = 0
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function ProgressBar:increase(amount)
  -- round down the progress to describe the index
  local amount = amount or 1
  self.progress = self.progress + amount
  local index = math.min(math.floor(self.progress), PROGRESS_FRAGMENTS)

  -- position the last fragment to the left of the indexed fragments
  if index > self.index then
    local width = 0

    for i = 1, index - 1 do
      width = width + self.fragments[i].width
    end

    self.fragment.x = self.panel.x + self.panel.width - self.fragment.width - width - 1 -- -1 for the outline of the panel
    self.fragment.id = index % 2 == 0 and 3 or 4
    self.index = index

    return self.index == PROGRESS_FRAGMENTS
  end
end

function ProgressBar:render()
  self.panel:render()
  love.graphics.setColor(1, 1, 1)

  if self.index > 0 then
    for i = 1, self.index - 1 do
      love.graphics.draw(
        gTextures.spritesheet,
        gQuads.progressBar[self.fragments[i].id],
        self.fragments[i].x,
        self.fragments[i].y
      )
    end
    love.graphics.draw(gTextures.spritesheet, gQuads.progressBar[self.fragment.id], self.fragment.x, self.fragment.y)
  end
end
