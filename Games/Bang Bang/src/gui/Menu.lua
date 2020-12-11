Menu = {}
Menu.__index = Menu

function Menu:create(level)
  local cannon = level.cannon

  local paddingLabel = 28
  local paddingButton = 20

  local widthButtonSmall = 34
  local heightButtonSmall = 34

  local widthButtonLarge =
    gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton +
    gFonts["normal"]:getWidth(ANGLE_MAX) +
    paddingButton +
    widthButtonSmall
  local heightButtonLarge = 38

  local xLabel = 28
  local yLabelAngle = 28
  local yLabelVelocity = yLabelAngle + heightButtonSmall + paddingButton

  local xFireButton = xLabel
  local yFireButton = yLabelVelocity + heightButtonSmall + paddingButton

  local angleLabel = Label:create(xLabel, yLabelAngle, "Angle")
  local angleDataLabel =
    Label:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton,
    yLabelAngle,
    cannon.angle
  )

  local decreaseAngleButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel,
    yLabelAngle + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "-",
    function()
      cannon.angle = math.max(ANGLE_MIN, cannon.angle - INCREMENT)
      angleDataLabel.text = cannon.angle
    end
  )

  local increaseAngleButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton +
      gFonts["normal"]:getWidth(ANGLE_MAX) +
      paddingButton,
    yLabelAngle + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "+",
    function()
      cannon.angle = math.min(ANGLE_MAX, cannon.angle + INCREMENT)
      angleDataLabel.text = cannon.angle
    end
  )

  local velocityLabel = Label:create(xLabel, yLabelVelocity, "Velocity")
  local velocityDataLabel =
    Label:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton,
    yLabelVelocity,
    cannon.velocity
  )

  local decreaseVelocityButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel,
    yLabelVelocity + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "-",
    function()
      cannon.velocity = math.max(VELOCITY_MIN, cannon.velocity - INCREMENT)
      velocityDataLabel.text = cannon.velocity
    end
  )

  local increaseVelocityButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton +
      gFonts["normal"]:getWidth(VELOCITY_MAX) +
      paddingButton,
    yLabelVelocity + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "+",
    function()
      cannon.velocity = math.min(VELOCITY_MAX, cannon.velocity + INCREMENT)
      velocityDataLabel.text = cannon.velocity
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
      level:fire()
    end
  )

  local paddingMenu = 16
  local xMenu = xLabel - paddingMenu
  local yMenu = yLabelAngle - paddingMenu
  local widthMenu = widthButtonLarge + paddingMenu * 2
  local heightMenu = yFireButton + heightButtonLarge - yLabelAngle + paddingMenu * 2

  local panel = Panel:create(xMenu, yMenu, widthMenu, heightMenu)

  this = {
    panel = panel,
    buttons = {
      ["decreaseAngleButton"] = decreaseAngleButton,
      ["increaseAngleButton"] = increaseAngleButton,
      ["decreaseVelocityButton"] = decreaseVelocityButton,
      ["increaseVelocityButton"] = increaseVelocityButton,
      ["fireButton"] = fireButton
    },
    labels = {
      ["velocityLabel"] = velocityLabel,
      ["velocityDataLabel"] = velocityDataLabel,
      ["angleLabel"] = angleLabel,
      ["angleDataLabel"] = angleDataLabel
    }
  }

  setmetatable(this, self)

  return this
end

function Menu:update(dt)
  for i, button in pairs(self.buttons) do
    button:update(dt)
  end
end

function Menu:render()
  self.panel:render()

  for i, button in pairs(self.buttons) do
    button:render()
  end

  for i, label in pairs(self.labels) do
    label:render()
  end
end
