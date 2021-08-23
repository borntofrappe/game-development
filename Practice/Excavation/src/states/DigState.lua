DigState = BaseState:new()

function DigState:enter(params)
end

function DigState:update(dt)
end

function DigState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(
    string.upper("Dig!"),
    0,
    VIRTUAL_HEIGHT / 2 - gFonts.large:getHeight() / 2,
    VIRTUAL_WIDTH,
    "center"
  )
end
