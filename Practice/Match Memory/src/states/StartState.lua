StartState = Class({__includes = BaseState})

local DIFFICULTIES = {
  "Easy",
  "Medium",
  "Hard"
}

function StartState:init()
  self.index = 0

  local fontHeight = gFonts["normal"]:getHeight()
  local buttonHeight = fontHeight * 1.3

  local maxFontWidth = 0
  for i, difficulty in ipairs(DIFFICULTIES) do
    local width = gFonts["normal"]:getWidth(difficulty)
    if width > maxFontWidth then
      maxFontWidth = width
    end
  end

  local buttonWidth = maxFontWidth * 1.5

  local options = {}
  local startY = VIRTUAL_HEIGHT / 2 - gFonts["normal"]:getHeight() / 2

  for i = 1, #DIFFICULTIES do
    local y = startY + (i - 1) * fontHeight * 2
    local text = DIFFICULTIES[i]

    table.insert(
      options,
      {
        index = i - 1,
        y = y,
        text = text,
        buttonX = VIRTUAL_WIDTH / 2 - buttonWidth / 2,
        buttonY = y + fontHeight / 2 - buttonHeight / 2,
        buttonWidth = buttonWidth,
        buttonHeight = buttonHeight
      }
    )
  end

  self.options = options
end

function StartState:update(dt)
  if love.keyboard.waspressed("up") then
    self.index = (self.index - 1) % #self.options
  end

  if love.keyboard.waspressed("down") then
    self.index = (self.index + 1) % #self.options
  end

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
  -- play state
  end
end

function StartState:render()
  love.graphics.setColor(0.1, 0.1, 0.1)

  love.graphics.setFont(gFonts["large"])
  love.graphics.printf("Match Memory", 0, VIRTUAL_HEIGHT / 4 - gFonts["large"]:getHeight() / 2, VIRTUAL_WIDTH, "center")

  love.graphics.setLineWidth(3)
  love.graphics.setFont(gFonts["normal"])
  for i, option in ipairs(self.options) do
    if option.index == self.index then
      love.graphics.setColor(0.1, 0.1, 0.1)
      love.graphics.rectangle("line", option.buttonX, option.buttonY, option.buttonWidth, option.buttonHeight)
      love.graphics.rectangle("fill", option.buttonX, option.buttonY, option.buttonWidth, option.buttonHeight)
      love.graphics.setColor(0.98, 0.98, 0.98)
      love.graphics.printf(option.text, 0, option.y, VIRTUAL_WIDTH, "center")
    else
      love.graphics.setColor(0.1, 0.1, 0.1)
      love.graphics.rectangle("line", option.buttonX, option.buttonY, option.buttonWidth, option.buttonHeight)
      love.graphics.printf(option.text, 0, option.y, VIRTUAL_WIDTH, "center")
    end
  end
end
