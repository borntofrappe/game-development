Data = {}

function Data:new()
  local this = {
    ["round"] = 1,
    ["score"] = 1212,
    ["lives"] = 3
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Data:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.setFont(gFonts.normal)
  love.graphics.print(
    string.upper("Score " .. string.format("%05d", self.score)),
    WINDOW_PADDING + PLAYING_AREA_WIDTH / 6,
    WINDOW_PADDING
  )

  love.graphics.draw(
    gTextures["spritesheet"],
    gFrames["player"],
    WINDOW_WIDTH / 2 + PLAYING_AREA_WIDTH / 4 - PLAYER_WIDTH,
    WINDOW_PADDING
  )
  love.graphics.print(string.upper(" = " .. self.lives - 1), WINDOW_WIDTH / 2 + PLAYING_AREA_WIDTH / 4, WINDOW_PADDING)
end
