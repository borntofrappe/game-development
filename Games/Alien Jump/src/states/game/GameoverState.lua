GameoverState = Class {__includes = BaseState}

function GameoverState:init()
  if gScore["current"] > gScore["hi"] then
    gScore["hi"] = gScore["current"]
  end
end

function GameoverState:update(dt)
  if love.keyboard.wasPressed("return") then
    gScore["current"] = 0
    gAlienVariant = gAlienVariant == "blue" and "pink" or "blue"
    gBackgroundVariant = math.random(#gQuads["backgrounds"])
    gStateStack:pop()
    gStateStack:pop()
    gStateStack:push(ScrollState())
  end
end
