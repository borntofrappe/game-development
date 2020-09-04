FallingState = Class({__includes = BaseState})

function FallingState:init()
  self.timer = 0
  self.delay = 1.5
  self.falling = 1.25
end

function FallingState:enter(params)
  self.cameraScroll = params.cameraScroll
  self.score = params.score
  self.interactables = params.interactables
  self.player = params.player
end

function FallingState:update(dt)
  for k, interactable in pairs(self.interactables) do
    interactable:update(dt)
  end

  self.player:update(dt)

  self.timer = self.timer + dt
  if self.timer >= self.delay then
    gStateMachine:change(
      "gameover",
      {
        score = self.score
      }
    )
  end
  if self.timer <= self.falling then
    self.cameraScroll = (WINDOW_HEIGHT - self.player.y - self.player.height - self.interactables[1].height)
  end
end

function FallingState:render()
  love.graphics.translate(0, math.floor(self.cameraScroll))

  love.graphics.setColor(1, 1, 1, 1)
  for k, interactable in pairs(self.interactables) do
    interactable:render()
  end

  self.player:render()

  love.graphics.translate(0, math.floor(self.cameraScroll) * -1)

  showScore(self.score)
end
