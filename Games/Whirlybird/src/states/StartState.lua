StartState = Class({__includes = BaseState})

function StartState:init()
  self.text = "Start"
  self.y = WINDOW_HEIGHT - 60
end

function StartState:enter(params)
  self.player = params.player or Player(WINDOW_WIDTH / 2 - PLAYER_WIDTH / 2, self.y - PLAYER_HEIGHT)
end

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
      {
        player = self.player
      }
    )
  end

  if love.keyboard.isDown("right") then
    self.player:slide("right")
  end

  if love.keyboard.isDown("left") then
    self.player:slide("left")
  end

  if love.mouse.isDown(1) then
    x, y = love.mouse.getPosition()
    if y >= self.y then
      gStateMachine:change(
        "play",
        {
          player = self.player
        }
      )
    else
      if x > WINDOW_WIDTH / 2 then
        self.player:slide("right")
      else
        self.player:slide("left")
      end
    end
  end

  if self.player.y >= self.y - PLAYER_HEIGHT then
    self.player:bounce(self.y - PLAYER_HEIGHT)
  end

  self.player:update(dt)
end

function StartState:render()
  love.graphics.setColor(gColors["grey"]["r"], gColors["grey"]["g"], gColors["grey"]["b"])
  love.graphics.rectangle("fill", 0, self.y, WINDOW_WIDTH, WINDOW_HEIGHT - self.y)

  love.graphics.setColor(gColors["background"]["r"], gColors["background"]["g"], gColors["background"]["b"])
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf(self.text:upper(), 0, WINDOW_HEIGHT - 52, WINDOW_WIDTH, "center")

  self.player:render()
end
