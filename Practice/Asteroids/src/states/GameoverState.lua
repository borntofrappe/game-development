GameoverState = Class {__includes = BaseState}

local DELAY = 5

function GameoverState:init()
  self.title = "Gameover"
  self.time = 0

  gSounds["gameover"]:play()
end

function GameoverState:enter(params)
  self.player = params.player
  self.asteroids = params.asteroids
end

function GameoverState:update(dt)
  if self.time >= DELAY or love.keyboard.wasPressed("return") then
    gStateMachine:change("title")
  else
    self.time = self.time + dt

    for k, asteroid in pairs(self.asteroids) do
      asteroid:update(dt)
    end
  end
end

function GameoverState:render()
  displayRecord(gRecord)
  displayStats(self.player.points, self.player.lives)

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end

  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title:upper(), 0, WINDOW_HEIGHT / 2 - gFonts.large:getHeight() / 2, WINDOW_WIDTH, "center")
end
