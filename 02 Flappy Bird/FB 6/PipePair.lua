-- create a pipepair class
PipePair = Class{}

-- create a variable for the GAP_HEIGHT
GAP_HEIGHT = 90

--[[
  in the init function add the following fields
  - x, for the horizontal coordinate past the VIRTUAL_WIDTH
  - y, passed in the declaration of the instance and representing the coordinate of the gap
  - pipes, a table nesting the instances of the individual pipes
  - remove, a boolean to signal the pipes to be removed
]]
function PipePair:init(y)
  self.x = VIRTUAL_WIDTH
  self.y = y
  self.pipes = {
    -- where the 'flipped' pipe ought to begin
    -- it therefore ends at self.y + PIPE_HEIGHT, where the gap begins
    ['upper'] = Pipe('top', self.y),
    -- where the 'unflipped' pipe ought to begin
    -- ending below the bottom edge of the screen, but starting exactly after the top pipe by a measure specified by the gap height
    ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
  }
  self.remove = false
end

-- in the update(dt) function update the horizontal coordinate according to the scroll variable, multiplied by dt
function PipePair:update(dt)
  -- update it as long as the horizontal coordinate doesn't already signal that the pair of pipes is off the screen
  if self.x > 0 - PIPE_WIDTH then
    -- if still on screen, update the position of the pair
    self.x = self.x - PIPE_SPEED * dt
    -- apply the coordiante to both instances of the pipe class
    self.pipes['upper'].x = self.x
    self.pipes['lower'].x = self.x
  else
    -- else set the remove flag to true
    self.remove = true
  end
end

-- in the render function, loop through the table of ppipes and render the individual pipes
function PipePair:render()
  for key, pipe in pairs(self.pipes) do
    pipe:render()
  end
end