TitleScreenState = Class({__includes = BaseState})

function TitleScreenState:init()
  self.board = Board()
  self.title = "MATCH 3"

  self.choice = 1
  self.options = {
    "Start",
    "Quit Game"
  }
end

function TitleScreenState:update(dt)
  if love.keyboard.waspressed("up") or love.keyboard.waspressed("down") then
    self.choice = self.choice == 1 and 2 or 1
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    if self.choice == 1 then
      gStateMachine:change("play")
    else
      love.event.quit()
    end
  end
end

function TitleScreenState:render()
  self.board:render()

  love.graphics.setColor(0, 0, 0, 0.4)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT / 6, 200, 64, 8)
  love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT / 2 + 5, 200, 90, 8)

  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf(self.title, 1, VIRTUAL_HEIGHT / 6 + 32 - 20 + 1, VIRTUAL_WIDTH, "center")
  love.graphics.printf(self.title, 2, VIRTUAL_HEIGHT / 6 + 32 - 20 + 2, VIRTUAL_WIDTH, "center")
  love.graphics.setColor(0.42, 0.59, 0.94, 1)
  love.graphics.printf(self.title, 0, VIRTUAL_HEIGHT / 6 + 32 - 20, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  for i, option in ipairs(self.options) do
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(option, 0.5, VIRTUAL_HEIGHT / 2 + 10 + 14 + (i - 1) * 28 + 0.5, VIRTUAL_WIDTH, "center")
    love.graphics.printf(option, 1, VIRTUAL_HEIGHT / 2 + 10 + 14 + (i - 1) * 28 + 1, VIRTUAL_WIDTH, "center")
    love.graphics.printf(option, 1.5, VIRTUAL_HEIGHT / 2 + 10 + 14 + (i - 1) * 28 + 1.5, VIRTUAL_WIDTH, "center")

    if i == self.choice then
      love.graphics.setColor(0.42, 0.59, 0.94, 1)
    else
      love.graphics.setColor(0.1, 0.17, 0.35, 1)
    end

    love.graphics.printf(option, 0, VIRTUAL_HEIGHT / 2 + 10 + 14 + (i - 1) * 28, VIRTUAL_WIDTH, "center")
  end
end
