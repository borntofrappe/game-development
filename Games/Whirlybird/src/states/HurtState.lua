HurtState = Class({__includes = BaseState})

function HurtState:init()
  self.timer = 0
  self.interval = 0.08
  self.variety = 1
  self.varieties = #gFrames["particles"]
end

function HurtState:enter(params)
  self.cameraScroll = params.cameraScroll
  self.score = params.score
  self.interactables = params.interactables
  self.player = params.player

  self.x = self.player.x + self.player.width / 2 - PLAYER_PARTICLES_WIDTH / 2
  self.y = self.player.y + self.player.height / 2 - PLAYER_PARTICLES_HEIGHT / 2
end

function HurtState:update(dt)
  self.timer = self.timer + dt
  if self.timer >= self.interval then
    self.timer = self.timer % self.interval
    if self.variety == self.varieties then
      gStateMachine:change(
        "gameover",
        {
          score = self.score
        }
      )
    else
      self.variety = self.variety + 1
    end
  end

  for k, interactable in pairs(self.interactables) do
    interactable:update(dt)
  end
end

function HurtState:render()
  love.graphics.translate(0, self.cameraScroll)

  love.graphics.setColor(1, 1, 1, 1)
  for k, interactable in pairs(self.interactables) do
    interactable:render()
  end

  love.graphics.draw(
    gTextures["spritesheet"],
    gFrames["particles"][self.variety],
    math.floor(self.x),
    math.floor(self.y)
  )

  love.graphics.translate(0, -self.cameraScroll)

  showScore(self.score)
end
