HurtState = BaseState:new()

local GAMEOVER_DELAY = 1.2

function HurtState:enter(params)
  self.player = params.player
  self.particles = Particles:new(self.player.x + self.player.width / 2, self.player.y + self.player.height / 2)
  self.interactables = params.interactables
  self.scrollY = params.scrollY

  self.timer = 0
end

function HurtState:update(dt)
  self.particles:update(dt)

  self.interactables:update(dt, self.scrollY)

  if not self.particles.inPlay then
    self.timer = self.timer + dt

    if self.timer > GAMEOVER_DELAY then
      gStateMachine:change("gameover")
    end
  end
end

function HurtState:render()
  love.graphics.translate(0, math.floor(self.scrollY))
  self.interactables:render()
  self.particles:render()
end
