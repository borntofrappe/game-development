FallingState = Class({__includes = BaseState})

function FallingState:init()
  self.timer = 0
  self.delay = 0.2
  self.isDelayed = false
  self.interval = 0.08
  self.iterations = 8
  self.varieties = {5, 6}
  self.variety = math.random(2) == 1 and self.varieties[1] or self.varieties[2]
end

function FallingState:enter(params)
  self.cameraScroll = params.cameraScroll
  self.score = params.score
  self.interactables = params.interactables
  self.player = params.player
end

function FallingState:update(dt)
  self.timer = self.timer + dt

  if self.delay > 0 then
    if self.timer >= self.delay then
      self.timer = self.timer % self.delay
      self.delay = 0
    end
  else
    self.player:change("falling")
    if self.timer >= self.interval then
      self.timer = self.timer % self.interval
      if self.iterations == 0 then
        gStateMachine:change(
          "gameover",
          {
            score = self.score
          }
        )
      else
        self.iterations = self.iterations - 1
      end
      self.variety = self.variety == self.varieties[1] and self.varieties[2] or self.varieties[1]
      self.player.variety = self.variety
    end
  end

  for k, interactable in pairs(self.interactables) do
    interactable:update(dt)
  end

  self.player:update(dt)
  self.cameraScroll = (WINDOW_HEIGHT - self.player.y - self.player.height - self.interactables[1].height)
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
