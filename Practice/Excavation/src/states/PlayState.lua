PlayState = BaseState:new()

function PlayState:enter(params)
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateStack:pop()
    gStateStack:push(TitleState:new())
  end
end

function PlayState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Here you'd dig", 8, 8)
end
