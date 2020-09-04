HurtState = Class({__includes = BaseState})

function HurtState:init()
  self.timer = 0
  self.delay = 0.5
end

function HurtState:enter(params)
  self.cameraScroll = params.cameraScroll
  self.score = params.score
  self.interactables = params.interactables
  self.player = params.player

  self.particles =
    Particles(
    self.player.x + self.player.width / 2 - PLAYER_PARTICLES_WIDTH / 2,
    self.player.y + self.player.height / 2 - PLAYER_PARTICLES_HEIGHT / 2
  )
end

function HurtState:update(dt)
  if not self.particles.inPlay then
    self.timer = self.timer + dt
    if self.timer >= self.delay then
      gStateMachine:change(
        "gameover",
        {
          score = self.score
        }
      )
    end
  end

  self.particles:update(dt)

  for k, interactable in pairs(self.interactables) do
    interactable:update(dt)
  end
end

function HurtState:render()
  love.graphics.translate(0, math.floor(self.cameraScroll))

  love.graphics.setColor(1, 1, 1, 1)
  for k, interactable in pairs(self.interactables) do
    interactable:render()
  end

  self.particles:render()

  love.graphics.translate(0, math.floor(self.cameraScroll) * -1)

  showScore(self.score)
end
