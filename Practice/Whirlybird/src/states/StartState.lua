StartState = BaseState:new()

function StartState:enter()
  local height = math.floor(gFonts["large"]:getHeight() * 1.5)
  self.menu = {
    ["text"] = string.upper("Start"),
    ["width"] = WINDOW_WIDTH,
    ["height"] = height,
    ["y"] = WINDOW_HEIGHT - height
  }

  self.player = Player:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
end

function StartState:update(dt)
  if love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
      {
        ["player"] = self.player
      }
    )
  end

  self.player:update(dt)

  if self.player.y + self.player.height >= self.menu.y then
    self.player.y = self.menu.y - self.player.height
    self.player:bounce()
  end

  if love.keyboard.isDown("right") then
    self.player.dx = SLIDE
    self.player.direction = 1
  end

  if love.keyboard.isDown("left") then
    self.player.dx = SLIDE
    self.player.direction = -1
  end
end

function StartState:render()
  love.graphics.setColor(0.35, 0.37, 0.39)
  love.graphics.rectangle("fill", 0, self.menu.y, self.menu.width, self.menu.height)

  love.graphics.setFont(gFonts["large"])
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(
    self.menu.text,
    0,
    self.menu.y + self.menu.height / 2 - gFonts["large"]:getHeight() / 2,
    self.menu.width,
    "center"
  )

  self.player:render()
end
