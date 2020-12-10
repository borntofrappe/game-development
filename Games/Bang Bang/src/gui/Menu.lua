Menu = {}
Menu.__index = Menu

function Menu:create(player)
  local paddingLabel = 26
  local paddingButton = 18

  local widthButtonSmall = 30
  local heightButtonSmall = 30

  local widthButtonLarge =
    gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton +
    gFonts["normal"]:getWidth(player.angle) +
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
    player.angle
  )

  local decreaseAngleButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel,
    yLabelAngle + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "-",
    function()
      player.angle = math.max(ANGLE_MIN, player.angle - INCREMENT)
      angleDataLabel.text = player.angle
    end,
    OFFSET_LABEL
  )

  local increaseAngleButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton +
      gFonts["normal"]:getWidth(player.angle) +
      paddingButton,
    yLabelAngle + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "+",
    function()
      player.angle = math.min(ANGLE_MAX, player.angle + INCREMENT)
      angleDataLabel.text = player.angle
    end,
    OFFSET_LABEL
  )

  local velocityLabel = Label:create(xLabel, yLabelVelocity, "Velocity")
  local velocityDataLabel =
    Label:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton,
    yLabelVelocity,
    player.velocity
  )

  local decreaseVelocityButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel,
    yLabelVelocity + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "-",
    function()
      player.velocity = math.max(VELOCITY_MIN, player.velocity - INCREMENT)
      velocityDataLabel.text = player.velocity
    end,
    OFFSET_LABEL
  )

  local increaseVelocityButton =
    Button:create(
    xLabel + gFonts["normal"]:getWidth("Velocity") + paddingLabel + widthButtonSmall + paddingButton +
      gFonts["normal"]:getWidth(player.velocity) +
      paddingButton,
    yLabelVelocity + gFonts["normal"]:getHeight() / 2 - heightButtonSmall / 2,
    widthButtonSmall,
    heightButtonSmall,
    "+",
    function()
      player.velocity = math.min(VELOCITY_MAX, player.velocity + INCREMENT)
      velocityDataLabel.text = player.velocity
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
      player:fire()
    end
  )

  this = {
    player = player,
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
