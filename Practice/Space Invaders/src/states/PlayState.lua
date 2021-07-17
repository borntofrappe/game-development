PlayState = BaseState:new()

function PlayState:enter()
  self.interval = {
    ["min"] = 0.4,
    ["max"] = 0.9,
    ["change"] = 0.1,
    ["label"] = "update"
  }

  self.interval.duration = self.interval.max

  self.player = Player:new()
  self.invaders = Invaders:new(self.interval.duration / (INVADER_TYPES + 1))

  self:setupInterval()
end

function PlayState:setupInterval()
  Timer:every(
    self.interval.duration,
    function()
      local changesDirection = self.invaders:update()
      if changesDirection then
        Timer:remove(self.interval.label)
        self.interval.duration = math.max(self.interval.min, self.interval.duration - self.interval.change)
        self.invaders.delayMultiplier = self.interval.duration / (INVADER_TYPES + 1)
        self:setupInterval()
      end
    end,
    false,
    self.interval.label
  )
end

function PlayState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:remove(self.interval.label)
    gStateMachine:change("start")
  end

  self.player:update(dt)
end

function PlayState:render()
  self.invaders:render()
  self.player:render()
end
