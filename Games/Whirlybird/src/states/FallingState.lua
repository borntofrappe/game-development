FallingState = Class({__includes = BaseState})

function FallingState:init()
  self.timer = 0
  self.delay = 0.25
  self.isDelayed = false
  self.interval = 0.08
  self.iterations = 10
  self.varieties = {5, 6}
  self.variety = 6

  self.gameover = false
end

function FallingState:enter(params)
  self.cameraScroll = params.cameraScroll
  self.score = params.score
  self.interactables = params.interactables
  self.player = params.player
  self.player:change("falling")
end

function FallingState:update(dt)
  for k, interactable in pairs(self.interactables) do
    interactable:update(dt)
  end

  self.player:update(dt)

  self.timer = self.timer + dt
  if self.gameover then
    if self.timer >= self.delay then
      gStateMachine:change(
        "gameover",
        {
          score = self.score
        }
      )
    end
  else
    if self.timer >= self.interval then
      self.timer = self.timer % self.interval
      if self.iterations == 0 then
        self.gameover = true
      else
        self.iterations = self.iterations - 1
      end
      self.variety = self.variety == self.varieties[1] and self.varieties[2] or self.varieties[1]
      self.player.variety = self.variety
    end
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
