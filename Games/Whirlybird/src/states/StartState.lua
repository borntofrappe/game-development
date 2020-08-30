StartState = Class({__includes = BaseState})

function StartState:init()
  self.text = "Start"
end

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end
end
function StartState:render()
  love.graphics.setColor(gColors["grey"]["r"], gColors["grey"]["g"], gColors["grey"]["b"])
  love.graphics.rectangle("fill", 0, WINDOW_HEIGHT - 60, WINDOW_WIDTH, 60)

  love.graphics.setColor(gColors["background"]["r"], gColors["background"]["g"], gColors["background"]["b"])
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf(self.text:upper(), 0, WINDOW_HEIGHT - 52, WINDOW_WIDTH, "center")
end
