Menu = {}

function Menu:new(x, y, options)
  local width = WINDOW_WIDTH - x
  local height = WINDOW_HEIGHT - y

  local maxcharacters = 0
  for i, option in ipairs(options) do
    if #option.text > maxcharacters then
      maxcharacters = #option.text
    end
  end

  local fontSize = math.floor((width / 2) / maxcharacters)
  local buttonWidth = fontSize * maxcharacters
  local buttonX = x + (width - buttonWidth) / 2

  local font = love.graphics.newFont("res/font.ttf", fontSize)
  love.graphics.setFont(font)
  local buttonHeight = font:getHeight() * 2

  local yGap = WINDOW_HEIGHT / (#options + 1) - fontSize / 2
  local buttonY = yGap

  local buttons = {}

  for i, option in ipairs(options) do
    local button = Button:new(buttonX, buttonY, buttonWidth, buttonHeight, option.text, option.callback)
    table.insert(buttons, button)
    buttonY = buttonY + yGap
  end

  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["buttons"] = buttons
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Menu:render()
  for k, button in pairs(self.buttons) do
    button:render()
  end
end
