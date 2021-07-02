Menu = {}

local PADDING = 4
local WHITESPACE = 8
local SPACE_BETWEEN = 14

function Menu:new()
  local this = {
    ["time"] = 0,
    ["isFlagSelected"] = false,
    ["isUpdating"] = false
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Menu:update(dt)
  self.time = self.time + dt
end

function Menu:reset()
  self.time = 0
  self.isFlagSelected = false
  self.isUpdating = false
end

function Menu:render()
  love.graphics.setColor(COLORS["background-dark"].r, COLORS["background-dark"].g, COLORS["background-dark"].b)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, MENU_HEIGHT)
  love.graphics.setColor(COLORS["text"].r, COLORS["text"].g, COLORS["text"].b)

  if self.isFlagSelected then
    love.graphics.setColor(0.2, 0.2, 0.2, 0.35)
    love.graphics.rectangle(
      "fill",
      WINDOW_WIDTH / 2 - TEXTURES["flag"]:getWidth() - FONTS["normal"]:getWidth(MINES) - SPACE_BETWEEN - WHITESPACE -
        PADDING,
      MENU_HEIGHT / 2 - TEXTURES["flag"]:getHeight() / 2 - PADDING,
      TEXTURES["flag"]:getWidth() + PADDING * 2,
      TEXTURES["flag"]:getHeight() + PADDING * 2,
      8
    )
  end
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    TEXTURES["flag"],
    WINDOW_WIDTH / 2 - TEXTURES["flag"]:getWidth() - FONTS["normal"]:getWidth(MINES) - SPACE_BETWEEN - WHITESPACE,
    MENU_HEIGHT / 2 - TEXTURES["flag"]:getHeight() / 2
  )

  love.graphics.draw(
    TEXTURES["stopwatch"],
    WINDOW_WIDTH / 2 + SPACE_BETWEEN,
    MENU_HEIGHT / 2 - TEXTURES["stopwatch"]:getHeight() / 2
  )

  love.graphics.setFont(FONTS["normal"])
  love.graphics.printf(
    MINES,
    0,
    MENU_HEIGHT / 2 - FONTS["normal"]:getHeight() / 2 + 2,
    WINDOW_WIDTH / 2 - SPACE_BETWEEN,
    "right"
  )

  love.graphics.print(
    formatTime(self.time),
    WINDOW_WIDTH / 2 + TEXTURES["stopwatch"]:getWidth() + SPACE_BETWEEN + WHITESPACE,
    MENU_HEIGHT / 2 - FONTS["normal"]:getHeight() / 2 + 2
  )
end
