StartState = BaseState:new()

function StartState:enter(params)
  local height = math.floor(gFonts["large"]:getHeight() * 1.5)

  self.menu = {
    ["text"] = string.upper("Start"),
    ["y"] = WINDOW_HEIGHT - height,
    ["width"] = WINDOW_WIDTH,
    ["height"] = height,
    ["padding"] = (height - gFonts["large"]:getHeight()) / 2
  }

  self.player = params and params.player or Player:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
end

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
      {
        ["player"] = self.player
      }
    )
  end

  self.player:update(dt)

  if self.player.y + self.player.height >= self.menu.y then
    gSounds["bounce"]:play()
    self.player.y = self.menu.y - self.player.height
    self.player:bounce()
  end

  if love.mouse.waspressed(1) then
    local x, y = love.mouse:getPosition()

    if y > self.menu.y and y < self.menu.y + self.menu.height then
      gStateMachine:change(
        "play",
        {
          ["player"] = self.player
        }
      )
    end
  end
end

function StartState:render()
  love.graphics.setColor(0.35, 0.37, 0.39)
  love.graphics.rectangle("fill", 0, self.menu.y, self.menu.width, self.menu.height)

  love.graphics.setFont(gFonts["large"])
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(self.menu.text, 0, self.menu.y + self.menu.padding, self.menu.width, "center")

  self.player:render()
end
