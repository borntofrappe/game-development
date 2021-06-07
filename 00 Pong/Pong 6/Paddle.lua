-- create a Paddle class
Paddle = Class {}

-- in the :init function detail the variables which define the class
function Paddle:init(x, y, width, height)
  -- describe the coordinates and sizes of the paddle
  -- add also dy, which itself describes the vertical movement of the paddle
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dy = 0
end

-- in the :update(dt) function, describe how the paddle alters its vertical position considering the dy value
function Paddle:update(dt)
  -- clamp the vertical position to the windows' boundaries using math.max and math.min
  -- starting with a negative dy movement (going upwards, clamping the coordinate to 0)
  if self.dy < 0 then
    self.y = math.max(0, self.y + self.dy * dt)
  else
    self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
  end
end

-- in the :render function, use the love.graphics function to draw a rectangle
function Paddle:render()
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
