PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.button = {
    ["tool"] = "pencil",
    ["scale"] = {
      ["pencil"] = 1.2,
      ["eraser"] = 0.9
    }
  }
  self.timer = 0
  self.interval =
    Timer.every(
    1,
    function()
      self.timer = self.timer + 1
    end
  )
end

function PlayState:enter(params)
  self.selection = params and params.selection or math.random(#LEVELS)
  self.level =
    Level(
    {
      ["number"] = self.selection
    }
  )
end

function PlayState:update(dt)
  Timer.update(dt)
  if love.keyboard.wasPressed("escape") then
    self.interval:remove()
    gStateMachine:change(
      "select",
      {
        ["selection"] = self.selection
      }
    )
  end

  if love.keyboard.wasPressed("p") or love.keyboard.wasPressed("P") then
    if self.button.tool ~= "pencil" then
      self.button.tool = "pencil"
      Timer.tween(
        0.2,
        {
          [self.button.scale] = {
            pencil = 1.2,
            eraser = 0.9
          }
        }
      )
    end
  elseif love.keyboard.wasPressed("e") or love.keyboard.wasPressed("E") then
    if self.button.tool ~= "eraser" then
      self.button.tool = "eraser"
      Timer.tween(
        0.2,
        {
          [self.button.scale] = {
            pencil = 0.9,
            eraser = 1.2
          }
        }
      )
    end
  end
end

function PlayState:render()
  love.graphics.translate(WINDOW_WIDTH * 5 / 7, WINDOW_HEIGHT * 9 / 14)
  self.level:render()
  love.graphics.translate(-WINDOW_WIDTH * 5 / 7, -WINDOW_HEIGHT * 9 / 14)

  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.rectangle("fill", WINDOW_WIDTH / 4 - 92, WINDOW_HEIGHT / 4 - 5, 136, 8 + gFonts["medium"]:getHeight())
  love.graphics.setFont(gFonts["medium"])
  love.graphics.setColor(gColors["highlight"].r, gColors["highlight"].g, gColors["highlight"].b, gColors["highlight"].a)
  love.graphics.printf(formatTimer(self.timer), WINDOW_WIDTH / 4 - 87, WINDOW_HEIGHT / 4, 128, "right")

  love.graphics.translate(WINDOW_WIDTH / 4 + 20, WINDOW_HEIGHT / 2)
  love.graphics.scale(self.button.scale.pencil, self.button.scale.pencil)
  if self.button.tool == "pencil" then
    love.graphics.setColor(
      gColors["highlight"].r,
      gColors["highlight"].g,
      gColors["highlight"].b,
      gColors["highlight"].a
    )
    love.graphics.circle("fill", 0, 0, 20)
  end
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.circle("fill", 0, 0, 20)
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", 0, 0, 20)
  love.graphics.polygon("fill", 4, -9.5, -8, 2.5, -8, 7.5, -3, 7.5, 9, -4.5)
  love.graphics.scale(2 - self.button.scale.pencil, 2 - self.button.scale.pencil)

  love.graphics.translate(-40, 40)
  love.graphics.scale(self.button.scale.eraser, self.button.scale.eraser)
  if self.button.tool == "eraser" then
    love.graphics.setColor(
      gColors["highlight"].r,
      gColors["highlight"].g,
      gColors["highlight"].b,
      gColors["highlight"].a
    )
    love.graphics.circle("fill", 0, 0, 20)
  end
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.circle("fill", 0, 0, 20)
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", 0, 0, 20)
  love.graphics.line(-6.5, -6.5, 6.5, 6.5)
  love.graphics.line(-6.5, 6.5, 6.5, -6.5)
  love.graphics.scale(2 - self.button.scale.eraser, 2 - self.button.scale.eraser)
end
