StartState = BaseState:new()

function StartState:enter()
  local labels = {
    "Play",
    "High score"
  }

  local maxWidth = 0
  for i, label in ipairs(labels) do
    local width = gFonts.normal:getWidth(label)
    if width > maxWidth then
      maxWidth = width
    end
  end

  maxWidth = maxWidth * 1.5

  local options = {}
  local yStart = VIRTUAL_HEIGHT / 2
  local yGap = (VIRTUAL_HEIGHT - yStart) / #labels
  local y = yStart
  local height = gFonts.normal:getHeight() * 2

  for i, label in ipairs(labels) do
    table.insert(
      options,
      {
        ["label"] = label,
        ["y"] = y,
        ["width"] = maxWidth,
        ["height"] = height
      }
    )

    y = y + yGap
  end

  self.options = options
  self.option = 1
end

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("up") then
    self.option = self.option == 1 and #self.options or self.option - 1

    gSounds["select"]:stop()
    gSounds["select"]:play()
  end

  if love.keyboard.waspressed("down") then
    self.option = self.option == #self.options and 1 or self.option + 1

    gSounds["select"]:stop()
    gSounds["select"]:play()
  end

  if love.keyboard.waspressed("return") then
    gSounds["enter"]:play()

    if self.option == 1 then
      gStateMachine:change("play")
    elseif self.option == 2 then
      gStateMachine:change("record")
    end
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(TITLE:upper(), 0, VIRTUAL_HEIGHT / 4 - gFonts.large:getHeight() / 2, VIRTUAL_WIDTH, "center")

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.normal)
  for i, option in ipairs(self.options) do
    if i == self.option then
      love.graphics.setLineWidth(2)
      love.graphics.rectangle(
        "line",
        VIRTUAL_WIDTH / 2 - option.width / 2,
        option.y - option.height / 4,
        option.width,
        option.height
      )
    end
    love.graphics.printf(option.label, 0, option.y, VIRTUAL_WIDTH, "center")
  end
end
