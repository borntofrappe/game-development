Menu = {}
Menu.__index = Menu

function Menu:create(player)
  local paddingLabel = 16
  local paddingButton = 8

  local widthButtonSmall = 28
  local heightButtonSmall = 28

  local widthButtonLarge =
    gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton +
    gFonts["normal"]:getWidth(formatData(player.angle)) +
    paddingButton +
    widthButtonSmall
  local heightButtonLarge = 32

  local xLabel = 16
  local yLabelAngle = 24
  local yLabelVelocity = 64

  local xFireButton = 16
  local yFireButton = 104

  local angleLabel = Label:create(xLabel, yLabelAngle, "Angle")
  local angleDataLabel =
    Label:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton,
    yLabelAngle,
    formatData(player.angle)
  )

  local decreaseAngleButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel,
    yLabelAngle + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "-",
    function()
      player.angle = math.max(5, player.angle - 5)
      angleDataLabel.text = formatData(player.angle)
    end
  )

  local increaseAngleButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton +
      gFonts["normal"]:getWidth(formatData(player.angle)) +
      paddingButton,
    yLabelAngle + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "+",
    function()
      player.angle = math.min(90, player.angle + 5)
      angleDataLabel.text = formatData(player.angle)
    end
  )

  local velocityLabel = Label:create(xLabel, yLabelVelocity, "Velocity")
  local velocityDataLabel =
    Label:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton,
    yLabelVelocity,
    formatData(player.velocity)
  )

  local decreaseVelocityButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel,
    yLabelVelocity + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "-",
    function()
      player.velocity = math.max(5, player.velocity - 5)
      velocityDataLabel.text = formatData(player.velocity)
    end
  )

  local increaseVelocityButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton +
      gFonts["normal"]:getWidth(formatData(player.velocity)) +
      paddingButton,
    yLabelVelocity + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "+",
    function()
      player.velocity = math.min(100, player.velocity + 5)
      velocityDataLabel.text = formatData(player.velocity)
    end
  )

  local fireButton =
    Button:create(
    xFireButton,
    yFireButton,
    widthButtonLarge,
    heightButtonLarge,
    "Fire!",
    function()
      player:fire()
    end
  )

  this = {
    player = player,
    buttons = {
      decreaseAngleButton,
      increaseAngleButton,
      decreaseVelocityButton,
      increaseVelocityButton,
      fireButton
    },
    labels = {
      velocityLabel,
      velocityDataLabel,
      angleLabel,
      angleDataLabel
    }
  }

  setmetatable(this, self)

  return this
end

function Menu:update(dt)
  for i, button in ipairs(self.buttons) do
    button:update(dt)
  end
end

function Menu:render()
  for i, button in ipairs(self.buttons) do
    button:render()
  end

  for i, label in ipairs(self.labels) do
    label:render()
  end
end
