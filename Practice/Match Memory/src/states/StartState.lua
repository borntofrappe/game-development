StartState = Class({__includes = BaseState})

local LEVELS = {
  "Easy",
  "Medium",
  "Hard"
}

function StartState:init()
  self.index = 0

  local fontHeight = gFonts["normal"]:getHeight()
  local buttonHeight = fontHeight * 1.3

  local maxFontWidth = 0
  for i, level in ipairs(LEVELS) do
    local width = gFonts["normal"]:getWidth(level)
    if width > maxFontWidth then
      maxFontWidth = width
    end
  end

  local buttonWidth = maxFontWidth * 1.5

  local options = {}
  local startY = VIRTUAL_HEIGHT / 2 - gFonts["normal"]:getHeight() / 2

  for i = 1, #LEVELS do
    local y = startY + (i - 1) * fontHeight * 2
    local text = LEVELS[i]

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

function StartState:enter(params)
  if params and params.level then
    self.index = params.level - 1
  end
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
    gStateMachine:change(
      "play",
      {
        level = self.index + 1
      }
    )
  end

  local x, y = push:toGame(love.mouse.getPosition())
  if x > 0 and x < VIRTUAL_WIDTH and y > 0 and y < VIRTUAL_HEIGHT then
    local index = -1

    for i, option in ipairs(self.options) do
      if
        x > option.buttonX and x < option.buttonX + option.buttonWidth and y > option.buttonY and
          y < option.buttonY + option.buttonHeight
       then
        index = i - 1
        break
      end
    end

    if index >= 0 then
      self.index = index
    end

    if love.mouse.waspressed(1) then
      local i = self.index + 1
      if
        x > self.options[i].buttonX and x < self.options[i].buttonX + self.options[i].buttonWidth and
          y > self.options[i].buttonY and
          y < self.options[i].buttonY + self.options[i].buttonHeight
       then
        gStateMachine:change(
          "play",
          {
            level = self.index + 1
          }
        )
      end
    end
  end

  if love.mouse.waspressed(2) then
    love.event.quit()
  end
end

function StartState:render()
  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)

  love.graphics.setFont(gFonts["large"])
  love.graphics.printf("Match Memory", 0, VIRTUAL_HEIGHT / 4 - gFonts["large"]:getHeight() / 2, VIRTUAL_WIDTH, "center")

  love.graphics.setLineWidth(3)
  love.graphics.setFont(gFonts["normal"])
  for i, option in ipairs(self.options) do
    if option.index == self.index then
      love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
      love.graphics.rectangle("line", option.buttonX, option.buttonY, option.buttonWidth, option.buttonHeight)
      love.graphics.rectangle("fill", option.buttonX, option.buttonY, option.buttonWidth, option.buttonHeight)
      love.graphics.setColor(gColors.background.r, gColors.background.g, gColors.background.b)
      love.graphics.printf(option.text, 0, option.y, VIRTUAL_WIDTH, "center")
    else
      love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
      love.graphics.rectangle("line", option.buttonX, option.buttonY, option.buttonWidth, option.buttonHeight)
      love.graphics.printf(option.text, 0, option.y, VIRTUAL_WIDTH, "center")
    end
  end
end
