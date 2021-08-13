Animation = {}

function Animation:new(frames, interval)
  local this = {
    ["frames"] = frames,
    ["interval"] = interval,
    ["timer"] = 0,
    ["index"] = 1
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
      if self.index == #self.frames then
        self.index = 1
      else
        self.index = self.index + 1
      end
    end
  end
end

function Animation:getCurrentFrame()
  return self.frames[self.index]
end
