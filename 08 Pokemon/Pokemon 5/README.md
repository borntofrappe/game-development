Generalize the dialogue state.

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

One issue with the dialogue state accepting text is that the height of the rectangle making up the backdrop depends on the length of the message. In actuality, there is no concept of a line break, and the text needs new line characters `\n` to have the text on multiple lines. Consider the text passed from the start state.

```lua
DialogueState(
  "Welcome to a wonderful world populated by\n" ..
    #POKEDEX .. " feisty creatures.\nCan you find them all?"
)
```

It is therefore possible to change the height of the box knowing the number of `\n` escape sequences. Knowing that each line requires roughly `16` pixels, plus `8` pixels of padding (`4` on the top and the bottom), the height is therfore computed in the `init` function.

```lua
self.height = 16 * lines + 8
```

To find the number of times the sequence `\n` appears, the string library provides the `gmatch` function. This one returns a function which iterates over all the occurrences of the input string.

```lua
for match in string.gmatch(input, pattern) do

end
```

It is used in the dialogue state to increment the counter describing the lines.

```lua
local lines = 1
for n in string.gmatch(self.text, "\n") do
  lines = lines + 1
end
```
