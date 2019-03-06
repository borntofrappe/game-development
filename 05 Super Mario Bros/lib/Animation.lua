--[[
  Author: Colton Ogden
  cogden@cs50.harvard.edu

  -- comments of my own to try and understand the library
  animation class to have a value change rapidly before returning back to its original value
]]

Animation = Class{}

-- in the init function set up the variables for the quick change in value
function Animation:init(def)
  --[[
    def.frames and def.interval are included in main.lua
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

-- in the update function chage the current frame
function Animation:update(dt)
  -- update only if self.frames contains more than one frame
  if #self.frames > 1 then
    -- update the variable used as a timer
    self.timer = self.timer + dt

    -- when the timer variable reaches the interval threshold
    if self.timer > self.interval then
      -- set timer back to have it consider a new iteration
      self.timer = self.timer % self.interval
      -- update current frame to consider the following frame in the self.frames table
      -- ! clamp the value in the [1-last frame in the self.frames table]
      self.currentFrame = math.max(1, (self.currentFrame + 1 ) % (#self.frames + 1))
    end
  end
end


-- in the getCurrentFrame function return return the frame identified by the current frame value
function Animation:getCurrentFrame()
  return self.frames[self.currentFrame]
end