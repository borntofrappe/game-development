-- create a Ball class
Ball = Class {}

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
  love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end
