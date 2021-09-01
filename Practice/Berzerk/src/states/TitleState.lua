TitleState = BaseState:new()

function TitleState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end
end

function TitleState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.print("Bonne chance, beserk", 2, 2)
end
