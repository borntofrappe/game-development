PlayState = BaseState:new()

local FALLING_DELAY = 1.5

function PlayState:enter(params)
  self.player = params and params.player or Player:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  self.scrollY = 0

  self.timer = 0
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change(
      "start",
      {
        ["player"] = self.player
      }
    )
  end

  self.player:update(dt)

  if love.keyboard.isDown("right") then
    self.player:slide("right")
  end

  if love.keyboard.isDown("left") then
    self.player:slide("left")
  end

  if love.mouse.isDown(1) then
    local x = love.mouse:getPosition()
    if x > WINDOW_WIDTH / 2 then
      self.player:slide("right")
    else
      self.player:slide("left")
    end
  end

  if love.keyboard.isDown("up") then
    self.player:bounce()
    self.timer = 0
  end

  if self.player.dy < 0 and self.player.y < UPPER_THRESHOLD - self.scrollY then
    self.scrollY = UPPER_THRESHOLD - self.player.y
  end

  if self.player.y > LOWER_THRESHOLD - self.scrollY then
    self.scrollY = LOWER_THRESHOLD - self.player.y

    self.timer = self.timer + dt
    if self.timer > FALLING_DELAY then
      gStateMachine:change(
        "falling",
        {
          ["player"] = self.player
        }
      )
    end
  end
end

function PlayState:render()
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(0.35, 0.37, 0.39)
  love.graphics.print("Scroll: " .. self.scrollY, 8, 8)
  love.graphics.print("Player y: " .. self.player.y, 8, 32)

  love.graphics.translate(0, math.floor(self.scrollY))
  self.player:render()
end
