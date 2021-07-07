TitleScreenState = Class({__includes = BaseState})

function TitleScreenState:init()
  self.board = Board()
  self.title = "MATCH3"

  self.colors = {
    [1] = {0.88, 0.34, 0.36, 1},
    [2] = {0.37, 0.8, 0.89, 1},
    [3] = {0.98, 0.94, 0.21, 1},
    [4] = {0.47, 0.25, 0.54, 1},
    [5] = {0.6, 0.89, 0.31, 1},
    [6] = {0.82, 0.48, 0.14, 1}
  }
  self.color = 1

  Timer.every(
    0.1,
    function()
      self.color = self.color % #self.colors + 1
    end
  )

  self.choice = 1
  self.options = {
    "Start",
    "Quit Game"
  }

  self.fadeout = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["a"] = 0
  }
  self.isTweening = false
end

function TitleScreenState:update(dt)
  if not self.isTweening then
    if love.keyboard.waspressed("up") or love.keyboard.waspressed("down") then
      self.choice = self.choice == 1 and 2 or 1
      gSounds["select"]:stop()
      gSounds["select"]:play()
    end

    if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
      if self.choice == 1 then
        self.isTweening = true
        Timer.tween(
          1,
          {
            [self.fadeout] = {a = 1}
          }
        ):finish(
          function()
            gStateMachine:change("play")
          end
        )
      else
        love.event.quit()
      end
    end
  end

  Timer.update(dt)
end

function TitleScreenState:render()
  self.board:render()

  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 105, VIRTUAL_HEIGHT / 6, 210, 64, 8)
  love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 105, VIRTUAL_HEIGHT / 2 + 5, 210, 90, 8)

  love.graphics.setFont(gFonts["big"])
  for i = 1, #self.title do
    letter = self.title:sub(i, i)
    offsetX = (i - (#self.title + 1) / 2) * 26
    if i == #self.title then
      offsetX = offsetX + 6
    end
    local color = math.abs(self.color - i) % #self.colors + 1

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(letter, offsetX + 2, VIRTUAL_HEIGHT / 6 + 32 - 18, VIRTUAL_WIDTH, "center")

    love.graphics.setColor(self.colors[color])
    love.graphics.printf(letter, offsetX, VIRTUAL_HEIGHT / 6 + 32 - 20, VIRTUAL_WIDTH, "center")
  end

  love.graphics.setFont(gFonts["normal"])
  for i, option in ipairs(self.options) do
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(option, 1, VIRTUAL_HEIGHT / 2 + 10 + 14 + (i - 1) * 28 + 1, VIRTUAL_WIDTH, "center")

    if i == self.choice then
      love.graphics.setColor(0.42, 0.59, 0.94, 1)
    else
      love.graphics.setColor(0.1, 0.17, 0.35, 1)
    end

    love.graphics.printf(option, 0, VIRTUAL_HEIGHT / 2 + 10 + 14 + (i - 1) * 28, VIRTUAL_WIDTH, "center")
  end

  if self.isTweening then
    love.graphics.setColor(self.fadeout["r"], self.fadeout["g"], self.fadeout["b"], self.fadeout["a"])
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  end
end
