--[[
  start state

  showing:

  - game title
  - menu with two options

  allowing to:
  - select an option and alternatively
    - go to the play state
    - quit the game early
]]

-- inherit from the BaseState class
StartState = Class{__includes = BaseState}

-- in the init() function set up the values used for the heading and menu
function StartState:init()
  -- table describing the letters of the heading
  -- ! remember the penultimate item is still an item when applying colors
  self.title = { 'M', 'A', 'T', 'C', 'H', '', '3'}

  -- table describing the colors through which each letter loops
  self.colors = {
    [1] = {0.85, 0.34, 0.38, 1},
    [2] = {0.37, 0.8, 0.89, 1},
    [3] = {0.98, 0.94, 0.21, 1},
    [4] = {0.47, 0.25, 0.54, 1},
    [5] = {0.6, 0.89, 0.31, 1},
    [6] = {0.87, 0.44, 0.14, 1}
  }
  -- variable continuously updated to refer to a different color
  self.color = 1

  -- timer set up to increment self.color at an interval
  Timer.every(0.07, function()
    self.color = self.color + 1
    -- have self.color always refer to a value in the [1-6] range
    if self.color == #self.colors then
      self.color = 1
    end
  end)

  --[[
    integer describing the current selection
    1 - start
    2 - quit
  ]]
  self.highlight = 1
end

-- in the update(dt) function listen for a key press on a selection of keys
function StartState:update(dt)
  -- when registering a click on the up or down key, toggle between 1 and 2 for the value for highlight
  if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
    --[[
      ternary operator
      condition and ifTrue or ifFalse
    ]]
    self.highlight = self.highlight == 1 and 2 or 1
  end

  -- when registering a click on the enter key, consider the highlight and either go to the play state or quit the game early
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- option 1, go to play state
    if self.highlight == 1 then
      gStateMachine:change('play')

    -- option 2, quit the game early
    else
      love.event.quit()
    end

  end

  -- update the timer
  Timer.update(dt)
end

-- in the render() function, display a heading with the title of the game atop two string values describing the menu
-- the heading and options are included on top of a white rectangle
function StartState:render()
  -- ! set the font and color being used before every graphic

  -- HEADING
  -- include an overlay on the background, stretching around the text
  love.graphics.setColor(1, 1, 1, 0.9)
  -- create a rectangle horizontally centered and vertically wrapping around the letters which follow
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 62, VIRTUAL_HEIGHT / 2 - 50 - 6, 124, 30 , 5)

  -- include each letter side by side
  love.graphics.setFont(gFonts['big'])
  for i = 1, #self.title do
    -- considering the center of the screen, have the letters placed around the center according to their index vis a vis the center of the table
    -- the idea is to have the letters before the halfway point of the table before the center of the screen,
    -- the letters after this threshold after the center
    -- the letter (if the table is odd) in the middle of the table perfectly centered
    -- ! the loop starts with i = 1
    local halfwayPoint = (#self.title + 1) / 2
    local distanceFromCenter = i - halfwayPoint


    -- include a shadow in the form of the same letter, slightly offset
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(
      tostring(self.title[i]),
      2, -- offset by 2
      VIRTUAL_HEIGHT / 2 - 50 + 1, -- offset by 1
      VIRTUAL_WIDTH + distanceFromCenter * 32,
      'center'
    )

    -- include the letters according to their index in the table
    -- change the color of each letter using the `self.colors` table and the color found through `self.color`
    -- to have each letter refer to a different color, consider the index of each letter
    -- ! i - 1 since self.color already begins at 1
    local color = self.color + (i - 1)
    -- ! in case self.color and the index compound to exceed the length of the table, reduce by an equal amount the color value
    if color > #self.colors then
      color = color - #self.colors
    end
    -- color refers to values in the [1-6] range, with each successive letter referring to greater values
    love.graphics.setColor(self.colors[color])
    love.graphics.printf(
      tostring(self.title[i]),
      0,
      VIRTUAL_HEIGHT / 2 - 50,
      VIRTUAL_WIDTH + distanceFromCenter * 32,
      'center'
    )
  end


  -- MAKESHIFT MENU
  -- include an overlay on the background, stretching around the text
  love.graphics.setColor(1, 1, 1, 0.9)
  -- create a rectangle horizontally centered and vertically wrapping the options which follow
  -- use the same width of the headings' rectangle and separate them vertically
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 62, VIRTUAL_HEIGHT / 2, 124, 80, 5)


  -- include the options specifying a different color according to the value of self.highlight
  -- ! for each string include a shadow before the actual text
  love.graphics.setFont(gFonts['normal'])

  -- shadow, slightly offset
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf(
    'Start',
    1.2,
    VIRTUAL_HEIGHT / 2 + 30 - 12 + 0.7,
    VIRTUAL_WIDTH,
    'center'
  )

  -- default color
  love.graphics.setColor(0.1, 0.17, 0.35, 1)
  -- color if highlighted
  if self.highlight == 1 then
    love.graphics.setColor(0.42, 0.59, 0.94, 1)
  end
  -- actual word
  love.graphics.printf(
    'Start',
    0,
    VIRTUAL_HEIGHT / 2 + 30 - 12,
    VIRTUAL_WIDTH,
    'center'
  )

  -- shadow, slightly offset
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf(
    'Quit Game',
    1.2,
    VIRTUAL_HEIGHT / 2 + 60 - 12 + 0.7,
    VIRTUAL_WIDTH,
    'center'
  )

  -- default color
  love.graphics.setColor(0.1, 0.17, 0.35, 1)
  -- color if highlighted
  if self.highlight == 2 then
    love.graphics.setColor(0.42, 0.59, 0.94, 1)
  end

  -- actual word
  love.graphics.printf(
    'Quit Game',
    0,
    VIRTUAL_HEIGHT / 2 + 60 - 12,
    VIRTUAL_WIDTH,
    'center'
  )
end