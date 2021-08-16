# Pokemon 5

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Pokemon — Final`.

_Please note_: an additional dialogue is shown when pressing `h` in the play state, but the text is purely aesthetic. With the current update, there is no feature associated with the key press.

## DialogueState

The idea is to have the state receive text in its `init` function, so to have the dialogue serve more than a single purpose.

```lua
function DialogueState:init(text)
  self.text = text
end

function DialogueState:render()
  -- backdrop

  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(self.text, 8, 8)
end
```

### height

One issue with the dialogue state accepting text is that the height of the rectangle making up the backdrop depends on the length of the message. As there is no concept of a line break, the text needs new line characters `\n` to have describe multiple lines. Consider the text passed from the start state.

```lua
DialogueState(
  "Welcome to a wonderful world populated by\n" ..
    #POKEDEX .. " feisty creatures.\nCan you find them all?"
)
```

With this setup it i possible to change the height of the box knowing the number of `\n` escape sequences. Knowing that each line requires roughly `16` pixels, plus `8` pixels of padding (`4` on the top and the bottom), the height is therfore computed in the `init` function.

```lua
self.height = 16 * lines + 8
```

One way to find the number of new line characters it through the `gsub` function. While technically useful to replace a sequence from a string, the function returns as a second value the number of times the sequence has been replaced.

```lua
local _, lines = self.text:gsub("\n", "")
```

Just be cautious to consider that the number of lines is one more than the number of characters, so to consider the first line.

```lua
self.height = 16 * (lines + 1) + 8
```

_Update:_ the hard-coded values of `16` and `8` are replaced by variables. `16` is actually and better described as the height of the small font.

```lua
gFonts["small"]:getHeight() -- 16
```

`8` is twice an arbitrary value chosen for the padding. This one is set above the script as a constant.

```lua
local PADDING = 4
```
