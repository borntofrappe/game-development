Menu = {}
Menu.__index = Menu

function Menu:create(level)
  local cannon = level.cannon

  local paddingLabel = 26
  local paddingButton = 18

  local widthButtonSmall = 30
  local heightButtonSmall = 30

  local widthButtonLarge =
    gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton +
    gFonts["normal"]:getWidth(cannon.angle) +
    paddingButton +
    widthButtonSmall
  local heightButtonLarge = 36

  local xLabel = 16
  local yLabelAngle = 18
  local yLabelVelocity = 60

  local xFireButton = 16
  local yFireButton = 100

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
    end,
    OFFSET_LABEL
  )

  local increaseAngleButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton +
      gFonts["normal"]:getWidth(cannon.angle) +
      paddingButton,
    yLabelAngle + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "+",
    function()
      cannon.angle = math.min(ANGLE_MAX, cannon.angle + INCREMENT)
      angleDataLabel.text = cannon.angle
    end,
    OFFSET_LABEL
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
    end,
    OFFSET_LABEL
  )

  local increaseVelocityButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton +
      gFonts["normal"]:getWidth(cannon.velocity) +
      paddingButton,
    yLabelVelocity + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "+",
    function()
      cannon.velocity = math.min(VELOCITY_MAX, cannon.velocity + INCREMENT)
      velocityDataLabel.text = cannon.velocity
    end,
    OFFSET_LABEL
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

  this = {
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
  for i, button in pairs(self.buttons) do
    button:render()
  end

  for i, label in pairs(self.labels) do
    label:render()
  end
end
