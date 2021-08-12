Animation = {}

function Animation:new(frames, interval)
  local this = {
    ["frames"] = frames,
    ["interval"] = interval,
    ["timer"] = 0,
    ["currentFrame"] = 1
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Animation:update(dt)
  if #self.frames > 1 then
    self.timer = self.timer + dt
    if self.timer >= self.interval then
      self.timer = self.timer % self.interval
      if self.currentFrame == #self.frames then
        self.currentFrame = 1
      else
        self.currentFrame = self.currentFrame + 1
      end
    end
  end
end

function Animation:getCurrentFrame()
  return self.currentFrame
end
