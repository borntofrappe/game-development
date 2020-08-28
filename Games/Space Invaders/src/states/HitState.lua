HitState = Class({__includes = BaseState})

function HitState:init()
  self.types = {4, 5}
end

function HitState:enter(params)
  self.player = params.player
  self.bullet = params.bullet
  self.aliens = params.aliens
  self.bullets = params.bullets

  self.round = params.round
  self.score = params.score
  self.health = params.health
  self.hits = params.hits
  self.speed = params.speed

  self.particles = params.particles

  self.particle = {
    x = self.player.x + self.player.width / 2 - PLAYER_PARTICLES_WIDTH / 2,
    y = self.player.y + self.player.height / 2 - PLAYER_PARTICLES_HEIGHT / 2,
    type = self.types[1]
  }
  gSounds["explosion"]:play()

  self.interval =
    Timer.every(
    0.5,
    function()
      self.particle.type = self.particle.type == self.types[1] and self.types[2] or self.types[1]
    end
  )
  self.delay =
    Timer.after(
    2.5,
    function()
      self.interval:remove()
      self.delay:remove()
      if self.health == 0 then
        gStateMachine:change(
          "gameover",
          {
            score = self.score
          }
        )
      else
        gStateMachine:change(
          "round",
          {
            player = self.player,
            bullet = self.bullet,
            aliens = self.aliens,
            bullets = self.bullets,
            round = self.round,
            score = self.score,
            health = self.health - 1,
            hits = self.hits,
            speed = self.speed
          }
        )
      end
    end
  )
end

function HitState:update(dt)
  Timer.update(dt)
end

function HitState:render()
  showInfo(
    {
      score = self.score,
      health = self.health
    }
  )

  love.graphics.setColor(1, 1, 1, 1)
  if self.bullet then
    self.bullet:render()
  end

  for i, row in ipairs(self.aliens) do
    for j, alien in ipairs(row) do
      alien:render()
    end
  end

  for i, bullet in ipairs(self.bullets) do
    bullet:render()
  end

  for i, particle in ipairs(self.particles) do
    love.graphics.draw(gTextures["space-invaders"], gFrames["particles"][particle.type], particle.x, particle.y)
  end

  love.graphics.draw(
    gTextures["space-invaders"],
    gFrames["particles"][self.particle.type],
    self.particle.x,
    self.particle.y
  )
end
