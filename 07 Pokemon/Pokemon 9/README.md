# Pokemon 9

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Pokemon — Final`.

When it comes to presenting different dialogues and menus in the game, it is important to consider how the GUIs are updated. For instance and for the selection, it is important to have the choice between the options affect the game.

## Textbox and dialogues

Especially in the context of the battle, it is important to have the textbox and its contents to block the normal flow of the game. Consider for instance the beginning of the battle, where you loop through some introductory text, and then show the selection. In the logic of the update function, it is possible to condition the GUIs with a series of booleans.

```lua
function BattleState:init(player)
  self.battleStart = false
  self.selectionStart = false
end
```

In the moment the game displays a more complex flow, however, this proves to be rather unsustainable. The idea is to here take advantage of the dialogue state, and update the textbox through this state's logic:

- animate the pokemon to slide in

  ```lua
  Timer.tween(
    1,
    {
      [self.playerPokemon] = {x = 8 + POKEMON_WIDTH / 2},
      [self.wildPokemon] = {x = VIRTUAL_WIDTH - POKEMON_WIDTH * 3 / 2 - 8}
    }
  )
  ```

- toggle `self.battleStart` to show the progress bars

  ```lua
  Timer.tween():finish(function()
    self.battleStart = true
  end)
  ```

  The one boolean is necessary to condition the render logic of the helper visuals

- push the dialogue state to introduce the encounter

  ```lua
  gStateStack:push(
    DialogueState()
  )
  ```

This allows the game to have a textbox effectively overlaid on the battle state. A textbox which can also introduce a selection through the `callback` passed to the dialogue state.

```lua
gStateStack:push(
  DialogueState({
    ["callback"] = function()
      gStateStack:pop()
      -- add selection
    end
  })
)
```

## Selection and menus

To mirror the idea introduced for the textbox, the game includes an additional state dedicated to render and update a selection.

`BattleMenuState` is first initialized with a callback function.

```lua
function BattleMenuState:init(def)
  self.callback = def.callback or function()
      gStateStack:pop()
    end
end
```

This is helpful to dismiss the menu, as described with the fallback value above, or again have the game go back two states, as detailed from the battle state.

```lua
BattleMenuState(
  {
    ["callback"] = function()
      gStateStack:pop()
      gStateStack:pop()
    end
  }
)
```

Popping the stack twice allows the game to move back to the field, to the play state.

For the selection then, the state adds the GUI describing the options and associated functionality.

```lua
Selection(
  {
    ["options"] = {
      {
        ["text"] = "Fight",
        ["callback"] = function() end
      },
      {
        ["text"] = "Run",
        ["callback"] = function() end
      }
    }
  }
```

The idea is to essentially delegate the functionality to the selection. It is then the selection which updates the current option in its `update()` function.

```lua
function Selection:update(dt)
  if love.keyboard.wasPressed("up") then
    self.option = self.option == 1 and #self.options or self.option - 1
  elseif love.keyboard.wasPressed("down") then
    self.option = self.option == #self.options and 1 or self.option + 1
  end
end
```

It is always the selection which executes the code through the associated callback function.

```lua
function Selection:update(dt)
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    self.options[self.option].callback()
  end
end
```

_Please note_: the selection GUI is updated to have `self.options` consider a table which describes the options through text and callback functions alike.

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

## Flow

The battle state introduces a considerable change from `Pokemon 8`. To sum up, logic of the battle goes through the following:

- introduce a dialogue for the game's introduction

- introduce a menu when the first dialogue is dismissed

- according to the selection

  - introduce an additional dialogue (a future update will consider the battle mechanics)

  - go back to the play state
