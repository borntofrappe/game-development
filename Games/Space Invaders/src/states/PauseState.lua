PauseState = Class({__includes = BaseState})

function PauseState:init()
  self.text = "Pause"
end

function PauseState:enter(params)
  self.player = params.player
  self.bullet = params.bullet
  self.aliens = params.aliens
  self.bullets = params.bullets
  self.bonus = params.bonus

  self.round = params.round
  self.score = params.score
  self.hasRecord = params.hasRecord
  self.health = params.health
  self.hits = params.hits
  self.speed = params.speed

  self.particles = params.particles
end

function PauseState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
      {
        player = self.player,
        bullet = self.bullet,
        aliens = self.aliens,
        bullets = self.bullets,
        bonus = self.bonus,
        round = self.round,
        score = self.score,
        hasRecord = self.hasRecord,
        health = self.health,
        hits = self.hits,
        speed = self.speed
      }
    )
  end
end

function PauseState:render()
  showGameInfo(
    {
      score = self.score,
      health = self.health
    }
  )

  love.graphics.setColor(1, 1, 1, 1)
  if self.bullet then
    self.bullet:render()
  end
  self.player:render()

  for i, bullet in ipairs(self.bullets) do
    bullet:render()
  end

  for i, row in ipairs(self.aliens) do
    for j, alien in ipairs(row) do
      alien:render()
    end
  end

  for i, particle in ipairs(self.particles) do
    love.graphics.draw(gTextures["spritesheet"], gFrames["particles"][particle.type], particle.x, particle.y)
  end

  if self.bonus then
    self.bonus:render()
  end

  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 39, WINDOW_HEIGHT / 2 - 13, 76, 25)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(self.text:upper(), 0, WINDOW_HEIGHT / 2 - 12, WINDOW_WIDTH, "center")
end
