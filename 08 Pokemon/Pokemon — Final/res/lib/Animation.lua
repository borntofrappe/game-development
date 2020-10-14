--[[
  Author: Colton Ogden
  cogden@cs50.harvard.edu

  -- comments of my own to try and understand the library
]]
Animation = Class {}

function Animation:init(def)
  --[[
    def.frames refers to a table of the possible frames
    def.interval refers to the time at which the frames need to be updated
  ]]
  self.frames = def.frames
  self.interval = def.interval

  -- timer to keep track of the passing of time
  self.timer = 0
  -- current frame to identify the frame per interval
  self.currentFrame = 1
end

function Animation:update(dt)
  -- update only if self.frames contains more than one frame
  if #self.frames > 1 then
    -- update the variable used as a timer
    self.timer = self.timer + dt

    --[[
      as the timer reaches the interval threshold
      1. set timer back to have it consider a new iteration
      2. update current frame to consider the following frame in the self.frames table
    ]]
    if self.timer > self.interval then
      self.timer = self.timer % self.interval
      -- ! clamp the value in the [1-last frame in the self.frames table]
      self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))
    end
  end
end

-- with getCurrentFrame return return the frame being used
function Animation:getCurrentFrame()
  return self.frames[self.currentFrame]
end
