Ball = {}
Ball.__index = Ball

function Ball:new(world, cx, cy, r, number, color)
  local body = love.physics.newBody(world, cx, cy, "dynamic")
  local shape = love.physics.newCircleShape(r)
  local fixture = love.physics.newFixture(body, shape)
  this = {
    ["body"] = body,
    ["shape"] = shape,
    ["fixture"] = fixture,
    ["number"] = number or 0,
    ["color"] = color or
      {
        ["r"] = 0.5,
        ["g"] = 0.5,
        ["b"] = 0.5
      },
    ["showNumber"] = false
  }

  setmetatable(this, self)
  return this
end

function Ball:toggleNumber()
  self.showNumber = not self.showNumber
end

function Ball:render()
  if self.showNumber then
    love.graphics.setLineWidth(2)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.setFont(gFonts["game"])
    love.graphics.print(
      self.number,
      self.body:getX() - gFonts["game"]:getWidth(tostring(self.number)) / 2,
      self.body:getY() - gFonts["game"]:getHeight() / 2
    )
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
  else
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
  end
end
