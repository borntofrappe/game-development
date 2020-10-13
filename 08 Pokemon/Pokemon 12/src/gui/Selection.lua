Selection = Class {}

function Selection:init(def)
  local def = def or {}
  self.x = def.x or VIRTUAL_WIDTH - 8 - 72
  self.y = def.y or VIRTUAL_HEIGHT - 56 - 4
  self.width = def.width or 72 + 4
  self.height = def.height or 56

  self.options =
    def.options or
    {
      {
        ["text"] = "if",
        ["callback"] = function()
        end
      },
      {
        ["text"] = "else",
        ["callback"] = function()
        end
      }
    }

  for i, option in ipairs(self.options) do
    self.options[i].x = self.x + 24
    self.options[i].y = self.y + 10 + 24 * (i - 1)
  end

  self.option = def.option or 1

  self.font = def.font or gFonts["small"]
  self.color =
    def.color or
    {
      ["r"] = 1,
      ["g"] = 1,
      ["b"] = 1
    }

  self.panel =
    Panel(
    {
      ["x"] = self.x,
      ["y"] = self.y,
      ["width"] = self.width,
      ["height"] = self.height
    }
  )
end

function Selection:update(dt)
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    self.options[self.option].callback()
  elseif love.keyboard.wasPressed("up") then
    self.option = self.option == 1 and #self.options or self.option - 1
  elseif love.keyboard.wasPressed("down") then
    self.option = self.option == #self.options and 1 or self.option + 1
  end
end

function Selection:render()
  self.panel:render()

  love.graphics.setFont(self.font)
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  for i, option in ipairs(self.options) do
    love.graphics.print(option.text, option.x, option.y)
    if i == self.option then
      love.graphics.draw(gTextures["cursor"], option.x - 4 - CURSOR_WIDTH, option.y + 8 - CURSOR_HEIGHT / 2)
    end
  end
end
