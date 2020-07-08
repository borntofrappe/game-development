-- create a Ball class
Ball = Class{}

-- in the :init function detail the variables which define the class
function Ball:init(x, y, width, height)
  -- describe the coordinates and sizes of the paddle
  -- add also dy, which itself describes the vertical movement of the paddle
  -- add also dx, to move the ball horizontally as well
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-50, 50)
end

-- create a function to check for the collision between the ball and one of the paddles
-- paddle passed as argument of the function
function Ball:collides(paddle)
  -- return false if the ball and the paddle are assuredly not overlapping
  -- this considering the relationship between opposite edges
  if self.x > paddle.x + paddle.width or self.x < paddle.x - self.width then
    return false
  end
  -- ! remember y coordinates go top to bottom
  if self.y < paddle.y - self.height or self.y > paddle.y + paddle.height then
    return false
  end
  -- otherwise return true
  return true
end

-- in the :reset function set the ball back to the center of the screen
-- update also the dx and dy property to new random values
function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - self.width / 2
  self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-50, 50)
end

-- in the :update(dt) function, describe how the ball alters its horizontal and vertical position considering the dx and dy values
function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

-- in the :render function, use the love.graphics function to draw a rectangle
function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end