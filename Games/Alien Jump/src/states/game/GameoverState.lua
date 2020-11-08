GameoverState = Class {__includes = BaseState}

function GameoverState:init()
  if gScore["current"] > gScore["hi"] then
    gScore["hi"] = gScore["current"]
    gScore["current"] = 0
  end
end

function GameoverState:update(dt)
  if love.keyboard.wasPressed("return") then
    gStateStack:pop()
    gStateStack:pop()
    gStateStack:push(ScrollState())
  end
end
