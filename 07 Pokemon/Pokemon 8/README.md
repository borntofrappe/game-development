# Pokemon 8

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Pokemon — Final`.

## GUI

Graphical user interfaces are useful to provide a reusable interface, a reusable component for the game's world. Consider for instance, a textbox describing multiple pages of text, above a solid background. Or again a selection, providing a way to pick between different options.

With this update, the goal is to build such interfaces.

_Please note_: the way the interfaces are incorporated in the game, in the game dynamics and the different states, is the subject of the next update. Here the goal is to build GUIs and show their reason for being.

## Default values

Every GUI is initialized with a set of fields. Consider for instance the coordinates and dimensions of a panel, or again the text for a textbox. These fields are populated with an input table.

```lua
function GUI:init(def)
  self.x = def.x
  -- other attributes
end
```

I've also decided to provide fallback values for a situation in which the table doesn't provide the full set of values. Or even when the GUIs are created without describing a table at all.

```lua
function GUI:init(def)
  local def = def or {}

  self.x = def.x or 4
end
```

## Panel

The panel's goal is to show a rectangle with an outline and a solid background. The `init` function is careful to describe different values, and provide a set of fallbacks especially in terms of style.

```lua
self.lineWidth = def.lineWidth or 4
self.lineColor =
  def.lineColor or
  {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1
  }

self.fillColor =
  def.fillColor or
  {
    ["r"] = 0.1,
    ["g"] = 0.1,
    ["b"] = 0.1
  }
```

The class also creates a function to toggle's the panel visibility.

```lua
function Panel:init(def)
  self.showPanel = true
end

function Panel:render()
  if self.showPanel then
    -- render panel
  end
end

function Panel:toggle()
  self.showPanel = not self.showPanel
end
```

## TextBox

The text box creates an instance of a panel, in order to print the input text above a solid background.

Text is provided in a table, describing the different pages, or chunks, of text.

```lua
function TextBox:init(def)
  local def = def or {}

  self.chunks = def.chunks or {"MISSING CHUNK"}
  self.chunk = def.chunk or 1
end
```

`TextBox:next()` updates the counter variable, and executes the code of a callback function when reaching the end.

```lua
function TextBox:next()
  if self.chunk == #self.chunks then
    self.callback()
  else
    self.chunk = self.chunk + 1
  end
end
```

This is where the GUI overlaps with the logic of the individual states. The callback function is initialized to have the component hide itself.

```lua
function TextBox:init(def)
  self.callback = def.callback or function()
      self:hide()
    end
end

function TextBox:render()
  if self.showTextBox then
    -- render textbox
  end
end

function TextBox:hide()
  self.showTextBox = false
end
```

The game can however override this value to have a different dynamic taking place. This by passing a callback in the input table.

## Progress bar

The progress bar shows the outline of a rectangle above the fill of another rectangle, with a different color. The idea is to have this structure show the health of a pokemon, or again its experience, by considering a maximum value and a current value.

```lua
function ProgressBar:init(def)
  self.max = def.max or 100
  self.value = def.value or 100
end
```

These values are used to compute the width of the colored background.

```lua
function ProgressBar:init(def)
  self.fillWidth = self.width / self.max * self.value
end

function ProgressBar:render()
  -- color fill
  love.graphics.rectangle("fill", self.x + 1, self.y + 1, self.fillWidth - 2, self.height - 2)

  -- color outline
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.rx)
end
```

The arbitrary numbers reducing the rectangle's space are necessary to avoid that the rectangle without rounded corners doesn't exceed the outline of the rectangle, itself with rounded corners.

The class is mostly visual, but does define two additional functions: `setValue` and `setMax`.

```lua
function ProgressBar:setValue(value)
  self.value = value
end

function ProgressBar:setMax(max)
  self.max = max
end
```

These are useful in the moment the bar need to change in how much they are filled. Consider for instance when the pokemon's health is reduced, or again when the pokemon reaches a new level. In this last instance the maximum value also changes, to have the creature need more experience to level up.

## Selection

This is perhaps the most complex of the GUIs introduced in the game, but its functionality is fully elaborated in the next update.

Here, the goal is to show an instance of the panel class, and overlay different options one above the other. Next to the option being selected, the idea is to also show a cursor as provided in the raster image `res/graphics/cursor.png`.

The options are initialized with a table of strings.

```lua
function Selection:init(def)
  local options = def.options or {"Fight", "Run"}
end
```

`self.options` is then built to consider the text alongside the coordinates and dimensions of the GUI.

```lua
for i, option in ipairs(options) do
  self.options[i] = {
    ["text"] = option,
    ["x"] = self.x + 24,
    ["y"] = self.y + 10 + 24 * (i - 1)
  }
end
```

The component finally renders the text, and the cursor conditional to the index of the option matching the current selection.

```lua
function Selection:init(def)
  local option = 1
end

function Selection:render()
  for i, option in ipairs(self.options) do
    love.graphics.print(option.text, option.x, option.y)
    if i == self.option then
      -- cursor
    end
  end
end
```

## In practice

The panel is used in the battle state, to provide a backdrop for the eventual textbox and selection.

```lua
self.panel =
  Panel(
  {
    ["x"] = 4,
    ["y"] = VIRTUAL_HEIGHT - 56 - 4,
    ["width"] = VIRTUAL_WIDTH - 8,
    ["height"] = 56
  }
)
```

It is also used in the textbox and selection GUIs, to provide a background for the text.

```lua
function TextBox:init(def)
  self.panel =
    Panel(
    {
      x = self.x,
      y = self.y,
      width = self.width,
      height = self.height
    }
  )
end

function TextBox:render()
  self.panel:render()
  -- text
end
```

The textbox is used in the dialogue state, and I've actually opted to use a convenient feature of lua in the form of variadic functions.

```lua
function DialogueState:init(...)
end
```

The idea is to use the three dots `...` to collect however many strings are passed as input, and wrap the variable number of strings in a table to provide the chunks to the textbox GUI.

```lua
function DialogueState:init(...)
self.textBox =
  TextBox(
    {
      ["chunks"] = {...},
      -- other attributes
    }
  )
end
```

It is worth noting that the state passes as a callback a function to have the dialogue popped when the textbox reaches its eventual last page.

```lua
function DialogueState:init(...)
self.textBox =
  TextBox(
    {
      -- previous attributes
      ["callback"] = function()
        gStateStack:pop()
      end
    }
  )
end
```

Finally, the progress bar and the selection are used in the battle state. The progress bar is included to show the health of the two pokemons, and also the experience of the player's creature.

```lua
self.playerPokemonHealth =
  ProgressBar(
  {
    ["x"] = VIRTUAL_WIDTH - 8 - VIRTUAL_WIDTH / 2.2,
    ["y"] = VIRTUAL_HEIGHT - 56 - 4 - 8 - 16,
    ["width"] = VIRTUAL_WIDTH / 2.2,
    ["height"] = 8
  }
)
```

Different values are used to position the bars on either side, and fill the rectangles with a different color.

The selection is finally used to give the option between fighting and running.

```lua
self.option = 1
  self.selection =
    Selection(
    {
      ["options"] = {"Fight", "Run"}
      ["option"] = self.option
    }
  )
```

The battle state is updated to explore the GUIs possibility, by way of modifying the current selection, and react to a key press on either option:

- for the first option, fight, the idea is to iterate through the text of the textbox

```lua
if self.option == 1 then
  self.textBox:next()
end
```

- for the second option, run, the idea is to pop the state to go back to the field

```lua
elseif self.option == 2 then
  gStateStack:pop()
end
```

These are not meant to accurately describe the game, but more as a way to see how the GUIs fit in the code.
