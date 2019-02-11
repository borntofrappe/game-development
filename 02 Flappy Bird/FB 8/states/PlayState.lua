-- state showing the playing screen
-- animating the bird, the pipes

-- inherit from the BaseState class
PlayState = Class{__includes = BaseState}

--[[
  in the init function, inclue the following fields
  - bird, with an instance of the bird class
  - pipePairs, with a table to be filled with instances of the pipePairs class
  - timer and interval, to regulate the rate of appearance of the pipes
  - lastY, as to maintain a certain consistency between pairs of pipes
]]
function PlayState:init()
  self.bird = Bird()
  self.pipePairs = {}
  self.timer = 0
  self.interval = 3
  -- subtract the height of the pipe, as the pipe is later flipped upside down, to effectively reference the top of the screen
  -- math.random(80) + 20 then references a distance from the top
  self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

-- in the update function, update teh pipes and the bird
function PlayState:update(dt)
  -- for the pipes, increment the timer variable
  self.timer = self.timer + dt
  -- when reaching rouhgly self.interval seconds, insert a pipe and set the timer variable back to 0
  if self.timer > self.interval then
    -- define the vertical coordinate by clamping the value in a selected range
    -- ! to each value the negative - PIPE_HEIGHT is included because the asset is ultimately flipped upside down
    -- think of -PIPE_HEIGHT + 10 as 10 from the top
    -- clamp between 10 from the top and the smaller between [-20,20] around the previous coordinate and an arbitrary value from the bottom (equal to the height of the pipe and gap)
    local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT))

    -- update self.lastY with the current value
    self.lastY = y

    -- insert an instance of the pipe pair class with the specified vertical coordinate
    table.insert(self.pipePairs, PipePair(y))
    -- set the timer back to 0 to have it go through the process of adding a pair of pipes, once more
    self.timer = 0
  end

  -- loop through the table's items and update the position of each pipe
  -- the pairs() function allows to identify the key-value pairs
  for key, pair in pairs(self.pipePairs) do
    pair:update(dt)

    -- consider the individual pipes in the pair
    for l, pipe in pairs(pair.pipes) do
      -- if the self.bird collides with one of the pipes go to the title screen
      -- ! this is an interim measure just to test the stateMachine
      if self.bird:collides(pipe) then
        gStateMachine:change('title')
      end
    end

    -- check if the pair has a flag of true, and if so remove the pair from the table
    if pair.remove == true then
      table.remove(self.pipePairs, key)
    end
  end

  -- create a second losing conditio, when the bird hits the ground
  if(self.bird.y > VIRTUAL_HEIGHT - 16) then
    gStateMachine:change('title')
  end

  -- update the position of the bird
  self.bird:update(dt)

end


-- in the render function, render the pipes contained in the self.pipePairs table and the bird
function PlayState:render()
  for key, pair in pairs(self.pipePairs) do
   pair:render()
  end

  self.bird:render()
end