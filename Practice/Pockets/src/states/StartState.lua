StartState = BaseState:new()

function StartState:enter()
  local text = TITLE
  local letters = {}
  local x = TABLE_INNER_WIDTH / 2 - gFonts.large:getWidth(text) / 2
  local y = TABLE_INNER_HEIGHT / 2 - gFonts.large:getHeight() + 8
  for i = 1, #text do
    local character = text:sub(i, i)
    local letter = {
      ["character"] = character,
      ["x"] = x,
      ["y"] = y,
      ["color"] = gColors.balls[i]
    }

    table.insert(letters, letter)

    x = x + gFonts.large:getWidth(character)
  end

  self.letters = letters

  local menu = {
    ["text"] = "Play",
    ["y"] = y + gFonts.large:getHeight() + 28,
    ["hasFocus"] = false
  }

  local button = {
    ["width"] = gFonts.normal:getWidth(menu.text) * 1.75,
    ["height"] = gFonts.normal:getHeight() * 1.25,
    ["lineWidth"] = 4
  }

  button.x = TABLE_INNER_WIDTH / 2 - button.width / 2
  button.y = menu.y + gFonts.normal:getHeight() / 2 - button.height / 2

  self.menu = menu
  self.button = button

  self.hasFocus = false
end

function StartState:update(dt)
  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    -- consider love.draw() translates the coordinate system by TABLE_MARGIN and TABLE_PADDING
    x = x - (TABLE_MARGIN + TABLE_PADDING)
    y = y - (TABLE_MARGIN + TABLE_PADDING)
    if
      x > self.button.x and x < self.button.x + self.button.width and y > self.button.y and
        y < self.button.y + self.button.height
     then
      self.hasFocus = true
    else
      self.hasFocus = false
    end
  end

  if love.mouse.waspressed(1) and self.hasFocus then
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.setFont(gFonts.large)
  for _, letter in ipairs(self.letters) do
    love.graphics.setColor(letter.color.r, letter.color.g, letter.color.b)
    love.graphics.print(letter.character, letter.x, letter.y)
  end

  love.graphics.setColor(gColors.ui.r, gColors.ui.g, gColors.ui.b)
  if self.hasFocus then
    love.graphics.rectangle(
      "fill",
      self.button.x - self.button.lineWidth / 2,
      self.button.y - self.button.lineWidth / 2,
      self.button.width + self.button.lineWidth,
      self.button.height + self.button.lineWidth,
      10
    )
    love.graphics.setColor(gColors.background.r, gColors.background.g, gColors.background.b)
  else
    love.graphics.setLineWidth(self.button.lineWidth)
    love.graphics.rectangle("line", self.button.x, self.button.y, self.button.width, self.button.height, 10)
  end

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.menu.text, 0, self.menu.y, TABLE_INNER_WIDTH, "center")
end
