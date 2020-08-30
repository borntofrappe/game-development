StartState = Class({__includes = BaseState})

function StartState:init()
  self.text = "Start"
  self.player = Player(WINDOW_WIDTH / 2 - PLAYER_WIDTH / 2, WINDOW_HEIGHT - 60 - PLAYER_HEIGHT)
end

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.isDown("right") then
    self.player:slide("right")
  end

  if love.keyboard.isDown("left") then
    self.player:slide("left")
  end

  if love.mouse.isDown(1) then
    x = love.mouse.getPosition()
    if x > WINDOW_WIDTH / 2 then
      self.player:slide("right")
    else
      self.player:slide("left")
    end
  end

  self.player:update(dt)
end

function StartState:render()
  love.graphics.setColor(gColors["grey"]["r"], gColors["grey"]["g"], gColors["grey"]["b"])
  love.graphics.rectangle("fill", 0, WINDOW_HEIGHT - 60, WINDOW_WIDTH, 60)

  love.graphics.setColor(gColors["background"]["r"], gColors["background"]["g"], gColors["background"]["b"])
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf(self.text:upper(), 0, WINDOW_HEIGHT - 52, WINDOW_WIDTH, "center")

  self.player:render()
end
