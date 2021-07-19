PauseState = BaseState:new()

function PauseState:enter(params)
  self.data = params.data
  self.interval = params.interval
  self.invaders = params.invaders

  self.collisions = params.collisions
  self.player = params.player

  local r, g, b = love.graphics.getBackgroundColor()

  self.title = {
    ["text"] = string.upper("Pause"),
    ["y"] = WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2
  }

  local width = gFonts.normal:getWidth(self.title.text)

  self.background = {
    ["x"] = WINDOW_WIDTH / 2 - width / 2,
    ["y"] = self.title.y,
    ["width"] = width,
    ["height"] = gFonts.normal:getHeight(),
    ["color"] = {
      ["r"] = r,
      ["g"] = g,
      ["b"] = b
    }
  }
end

function PauseState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
      {
        ["data"] = self.data,
        ["interval"] = self.interval,
        ["invaders"] = self.invaders,
        ["collisions"] = self.collisions,
        ["player"] = self.player
      }
    )
  end
end

function PauseState:render()
  self.data:render()

  self.collisions:render()
  self.invaders:render()
  self.player:render()

  love.graphics.setColor(self.background.color.r, self.background.color.g, self.background.color.b)
  love.graphics.rectangle("fill", self.background.x, self.background.y, self.background.width, self.background.height)

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.title.text, 0, self.title.y, WINDOW_WIDTH, "center")
end
