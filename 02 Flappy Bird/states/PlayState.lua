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
  self.interval = math.random(2, 4)
  -- subtract the height of the pipe, as the pipe is later flipped upside down, to effectively reference the top of the screen
  -- math.random(80) + 20 then references a distance from the top
  self.lastY = -PIPE_HEIGHT + math.random(80) + 20
  -- include a variable to keep track of the score
  self.score = 0
  -- include a variable referencing the star icon
  self.image = love.graphics.newImage('Resources/graphics/medal.png')
end

-- in the update function, update teh pipes and the bird
function PlayState:update(dt)
  -- for the pipes, increment the timer variable
  self.timer = self.timer + dt
  -- when reaching rouhgly self.interval seconds, insert a pipe and set the timer variable back to 0
  if self.timer > self.interval then
    -- set gap to be a random value
    local gap = math.random(90, 150)
    -- define the vertical coordinate by clamping the value in a selected range
    -- ! to each value the negative - PIPE_HEIGHT is included because the asset is ultimately flipped upside down
    -- think of -PIPE_HEIGHT + 10 as 10 from the top
    -- clamp between 10 from the top and the smaller between [-20,20] around the previous coordinate and an arbitrary value from the bottom (equal to the height of the pipe and gap)
    local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - gap - PIPE_HEIGHT))

    -- update self.lastY with the current value
    self.lastY = y

    -- insert an instance of the pipe pair class with the specified vertical coordinate and the random gap value
    table.insert(self.pipePairs, PipePair(y, gap))
    -- set the timer back to 0 to have it go through the process of adding a pair of pipes, once more
    self.timer = 0
    -- set the interval to represent a new random value between 2 and 4 seconds
    self.interval = math.random(2, 4)
  end

  -- loop through the table's items and update the position of each pipe
  -- the pairs() function allows to identify the key-value pairs
  for key, pair in pairs(self.pipePairs) do
    pair:update(dt)

    -- consider the individual pipes in the pair
    for l, pipe in pairs(pair.pipes) do
      -- if the self.bird collides with one of the pipes go to the score screen
      if self.bird:collides(pipe) then
        -- pass the score and the image to the scoring state
        gStateMachine:change('score', {
          score = self.score,
          image = self.image
        })
      end
    end

    -- check if the pair has the boolean of remove set to true, and if so remove the pair from the table
    if pair.remove == true then
      table.remove(self.pipePairs, key)
    end

    -- check if the pair has the boolean of scored set to false **and** is to the left of the bird
    -- in this instance increment the score
    if not pair.scored then
      if self.bird.x > pair.x + PIPE_WIDTH then
        -- play the matching audio
        sounds['score']:play()
        self.score = self.score + 1
        -- ! set scored to true as to avoid counting the same pair twice
        pair.scored = true
      end
    end


  end

  -- create a second losing condition, when the bird hits the ground
  if(self.bird.y > VIRTUAL_HEIGHT - 16) then
    -- play the matching audio
    sounds['lose']:play()
    gStateMachine:change('score', {
      score = self.score,
      image = self.image
    })
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

  -- in the top left corner highlight the score
  love.graphics.setFont(normalFont)
  love.graphics.print(
    'Score: ' .. tostring(self.score),
    8,
    8
  )

  -- include as many star icons as there are 5 points
  -- math.floor(self.score / 5) returns 0, 1
  if self.score >= 5 then
    for i = 0, math.floor(self.score / 5) - 1 do
      love.graphics.draw(self.image, (15 * i) + (self.image:getWidth() / 2), 25)
    end
  end
end