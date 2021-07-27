GameoverState = BaseState:new()

local ANIMATION_INTERVAL = 0.1

function GameoverState:enter()
  self.title = {
    ["text"] = string.upper("Game\nOver"),
    ["y"] = WINDOW_HEIGHT / 4 - gFonts["large"]:getHeight()
  }

  self.button = {
    ["x"] = WINDOW_WIDTH / 2 - BUTTON.width / 2,
    ["y"] = WINDOW_HEIGHT / 4 * 3,
    ["width"] = BUTTON.width,
    ["height"] = BUTTON.height
  }

  self.marks = {
    ["x"] = {WINDOW_WIDTH * 2 / 5 - MARKS.width / 2, WINDOW_WIDTH * 3 / 5 - MARKS.width / 2},
    ["y"] = WINDOW_HEIGHT / 2 - 64
  }

  self.sprites = {
    ["x"] = {WINDOW_WIDTH * 2 / 5 - SPRITES.width / 2, WINDOW_WIDTH * 3 / 5 - SPRITES.width / 2},
    ["y"] = WINDOW_HEIGHT / 2 - 12
  }

  self.frame = 1
  self.frames = SPRITES.frames
  self.timer = 0
end

function GameoverState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("play")
  end

  if love.mouse.waspressed(1) then
    local x, y = love.mouse:getPosition()
    if
      x > self.button.x and x < self.button.x + self.button.width and y > self.button.y and
        y < self.button.y + self.button.height
     then
      gStateMachine:change("play")
    end
  end

  self.timer = self.timer + dt
  if self.timer >= ANIMATION_INTERVAL then
    self.frame = self.frame == self.frames and 1 or self.frame + 1
    self.timer = self.timer % ANIMATION_INTERVAL
  end
end

function GameoverState:render()
  love.graphics.setFont(gFonts["large"])
  love.graphics.setColor(0.35, 0.37, 0.39)
  love.graphics.printf(self.title.text, 0, self.title.y, WINDOW_WIDTH, "center")

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures["spritesheet-gameover"], gFrames["marks"][1], self.marks.x[1], self.marks.y)
  love.graphics.draw(gTextures["spritesheet-gameover"], gFrames["marks"][2], self.marks.x[2], self.marks.y)

  love.graphics.draw(
    gTextures["spritesheet-gameover"],
    gFrames["sprites"][1][self.frame],
    self.sprites.x[1],
    self.sprites.y
  )
  love.graphics.draw(
    gTextures["spritesheet-gameover"],
    gFrames["sprites"][2][self.frame],
    self.sprites.x[2],
    self.sprites.y
  )

  love.graphics.draw(gTextures["spritesheet-gameover"], gFrames["button"], self.button.x, self.button.y)
end
