Add callback functions to the different GUIs.

## callback

The idea is to delegate to the GUIs the logic previously described in the individual states. For instance and for the selection, discussed later in detail, the idea is to pass not only a table of options, but a table of options _and_ associated callback functions. In the GUI then, you execute of the code of the function when a selection is actually made.

## TextBox

The idea is to avoid having to include multiple text boxes, and instead pass a table of strings through which the GUI iterates.

```lua
function TextBox:init(def)
  self.text = def.text or {"MISSING TEXT"}
  self.chunk = def.chunk or 1
end
```

The iteration is enabled with a separate function.

```lua
function TextBox:next()
  self.chunk = self.chunk + 1
end
```

When the `next()` function then reaches the end of the `text` table, the GUI executes the code received in the callback function.

```lua
function TextBox:next()
  if self.chunk == #self.text then
    self.callback()
  else
    self.chunk = self.chunk + 1
  end
end
```

Remember to initialize said function in the `init` method as well.

```lua
function TextBox:init(def)
  self.callback = def.callback or function() end
end
```

### Height

The height of the component is updated to have the panel as tall as specified through the `def` table, or as tall as required by the string with the most `\n` characters.

```lua
self.height = def.height

if not self.height then
  local maxLines = 1
  for i, t in ipairs(self.text) do
    local lines = 1
    for n in string.gmatch(t, "\n") do
      lines = lines + 1
    end
    if lines > maxLines then
      maxLines = lines
    end
  end
  self.height = 16 * maxLines + 8
end
```

### In practice

Looking at the dialogue state, in the moment the text box is allowed to have multiple pages, it is insufficient to dismiss the dialogue at the first press of the enter key. `Dialogue:upadte()` is therefore updated to have the text box continue to the next chunk.

```lua
function DialogueState:update(dt)
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    self.textBox:next()
  end
end
```

When defining the text box then, the callback specifies to dismiss the actual message.

```lua
function DialogueState:init(...)
  self.textBox =
    TextBox(
    {
      -- previous attributes,
      ["callback"] = function()
        gStateStack:pop()
      end
    }
  )
end
```

The text box iterates through the chunks, and when it reaches the end calls the function to pop the dialogue state from the stack.

## Selection

As mentioned in the preface, the GUI for the selection is modified to receive a table of options and associated callback function.

```lua
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
```

The `init` function iterates through this table to add the `x` and `y` coordinates.

```lua
for i, option in ipairs(self.options) do
  self.options[i].x = self.x + 24
  self.options[i].y = self.y + 10 + 24 * (i - 1)
end
```

The render function then loops through the options to print out the actual text.

```lua
for i, option in ipairs(self.options) do
  love.graphics.print(option.text, option.x, option.y)
end
```

### Update

It is in a separate functon, defined as `update` out of convenience, then the GUI considers user interaction. A key press on the up or down key allows to modify the selection between the available options.

```lua
if love.keyboard.wasPressed("up") then
  self.option = self.option == 1 and #self.options or self.option - 1
elseif love.keyboard.wasPressed("down") then
  self.option = self.option == #self.options and 1 or self.option + 1
end
```

A press on the enter key executes the code described by the callback function of the selected option.

```lua
if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
  self.options[self.option].callback()
end
```

### In practice

This will be likely refined in future updates, but here the selection is initialized in the battle state with two options:

- fight, which iterates through a textbox describing two arbitrary strings

  ```lua
  {
    ["text"] = "Fight",
    ["callback"] = function()
      self.textBox:next()
    end
  }
  ```

- run, which moves from the battle state back to the play state

  ```lua
  {
    ["text"] = "Run",
    ["callback"] = function()
      gStateStack:pop()
    end
  }
  ```

Just remember to update the selection GUI in the body of the battle state's update function

```lua
function BattleState:update(dt)
  self.selection:update(dt)
end
```

## Variadic functions

This is a convenience introduced in the dialogue state. Starting from the idea that the dialogue state receives multiple strings, it is possible to use three dots `...` to make the function a _variadic_ function. Used in between parenthesis, these dots provide a way to collect a variable number of inputs in a table.

```lua
function DialogueState:init(...)
  self.textBox =
  TextBox(
  {
    ["text"] = {...},
    -- other attributes
  }
  )
end
```
