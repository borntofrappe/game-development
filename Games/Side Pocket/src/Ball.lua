Ball = {}
Ball.__index = Ball

function Ball:new(def)
  local body = love.physics.newBody(def.world, def.cx, def.cy, "dynamic")
  local shape = love.physics.newCircleShape(def.r)
  local fixture = love.physics.newFixture(body, shape)

  this = {
    ["body"] = body,
    ["shape"] = shape,
    ["fixture"] = fixture,
    ["number"] = def.number or 0,
    ["color"] = def.color or
      {
        ["r"] = 0.9,
        ["g"] = 0.9,
        ["b"] = 0.9
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
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  if self.showNumber then
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
    love.graphics.setFont(gFonts["small"])
    love.graphics.print(
      self.number,
      self.body:getX() - gFonts["small"]:getWidth(tostring(self.number)) / 2,
      self.body:getY() - gFonts["small"]:getHeight() / 2
    )
  else
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius(), SEGMENTS)
  end
end
