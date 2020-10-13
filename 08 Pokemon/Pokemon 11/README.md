Update battle dynamics.

## Battle states

- `BattleState` introduces the battle, with a dialogue describing the opposing and player's pokemon

- `BattleMenuState` shows the selection, with the options to fight and run

- `BattleMessageState` shows a textbox and automatically loops through the chunks using `Timer.every`

- `BattleTurnState` is responsible for updating the pokemon stats, modifying the health points and soon managing a victory and defeat

## callbacks

After the battle state, each individual state defines a function `self.callback`. This one is used by default to pop the state from the stack, but can be optionally modified by the code invoking the state in the first place.

which is used to move back on the stack. This function pops the state, and then executes the code of an optional function passed to the state itself.

```lua
self.callback = def.callback or function()
  gStateStack:pop()
end
```

For instance and considering when the player selects the option `Run`, the default pop operation is replaced by a callback which pops two states in a row.

```lua
gStateStack:push(
  BattleMenuState(
    {
      ["callback"] = function()
        gStateStack:pop()
        gStateStack:pop()
      end,
      -- other attributes
    }
  )
)
```

Twice to have the stack remove the battle states and revert to the `PlayState`.

## TextBox

The textbox was previously updated through the `next()` function to consider multiple chunks.

```lua
function TextBox:next()
  self.chunk = self.chunk + 1
end
```

When reaching the end of the chunks, the GUI would automatically hide itself.

```lua
function TextBox:next()
  if self.chunk == #self.chunks then
    self:hide()
  else
    self.chunk = self.chunk + 1
  end
end
```

This default behavior is however not desired when for instance showing the string `You ran away safely`. In this situation, the `BattleMessageState` should stop on the string before moving back to the field. To this end, the GUI is updated to call a callback function, and have it default to `self:hide()`.

```lua
function TextBox:init(def)
  -- previous attributes

  self.callback = def.callback or function()
      self:hide()
    end
end

function TextBox:next()
  if self.chunk == #self.chunks then
    self:callback()
  else
    self.chunk = self.chunk + 1
  end
end
```

Specify the `callback` attribute and this one overrides the default operation.

## Convention and keys

Throughout the code, classes are invoked with a `def` table, but the attributes are specified without a common standard.

```lua
-- ["key"] = value
self.panel =
  Panel(
  {
    ["x"] = self.x,
    ["y"] = self.y,
    ["width"] = self.width,
    ["height"] = self.height
  }
)

-- key = value
self.panel =
  Panel(
  {
    x = self.x,
    y = self.y,
    width = self.width,
    height = self.height
  }
)
```

With this update I try to enforce the convention of having the keys nested in strings and square brackets.
