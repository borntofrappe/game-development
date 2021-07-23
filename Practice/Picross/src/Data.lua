Data = {}

function Data:new(level)
  local timer = {
    ["time"] = 0,
    ["width"] = math.floor(gFonts.normal:getWidth("00:00:00") * 1.2),
    ["height"] = math.floor(gFonts.normal:getHeight() * 2)
  }

  timer.x = math.floor(WINDOW_WIDTH / 4 - timer.width / 2)
  timer.y = math.floor(WINDOW_HEIGHT / 4 - timer.height / 2)

  local this = {
    ["index"] = level.index,
    ["timer"] = timer
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Data:formatTime(time)
  local seconds = time
  local hours = math.floor(seconds / 3600)
  seconds = seconds - hours * 3600
  local minutes = math.floor(seconds / 60)
  seconds = seconds - minutes * 60

  local h = hours >= 10 and hours or 0 .. hours
  local m = minutes >= 10 and minutes or 0 .. minutes
  local s = seconds >= 10 and seconds or 0 .. seconds

  return h .. ":" .. m .. ":" .. s
end

function Data:render()
  love.graphics.setFont(gFonts.normal)
  love.graphics.setColor(gColors.shadow.r, gColors.shadow.g, gColors.shadow.b, gColors.shadow.a)
  love.graphics.rectangle("fill", self.timer.x + 6, self.timer.y + 4, self.timer.width, self.timer.height)

  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
  love.graphics.rectangle("fill", self.timer.x, self.timer.y, self.timer.width, self.timer.height)

  love.graphics.print("Level " .. self.index, self.timer.x, self.timer.y - gFonts.normal:getHeight() - 4)

  love.graphics.setColor(gColors.highlight.r, gColors.highlight.g, gColors.highlight.b)
  love.graphics.printf(
    self:formatTime(self.timer.time),
    self.timer.x,
    self.timer.y + self.timer.height / 2 - gFonts.normal:getHeight() / 2 + 1,
    self.timer.width,
    "center"
  )
end
