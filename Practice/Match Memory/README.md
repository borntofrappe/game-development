# Match Memory

Ask the player to match cards in pairs.

![A few frames from the demo "Match Memory"](https://github.com/borntofrappe/game-development/blob/master/Practice/Match%20Memory/match-memory.gif)

## Resources

In the `res` folder you find a spritesheet describing the different types of pokemon. The visual is inspired by the symbols highlighted [on bulbapedia](https://bulbapedia.bulbagarden.net/wiki/Type#Symbol_icons) for the pokemon ranger series, and includes eighteen tiles `24` pixel wide and tall.

## Quads

In `Utils.lua` the `GenerateQuads` function creates a table of quads from an input image, tile width and tile height.

[`love.graphics.newQuad`](http://love2d.org/wiki/love.graphics.newQuad) sections the image on the basis of `x` and `y` coordinates, the dimensions of the tile and an additional argument for the dimensions of the image itself.

```lua
love.graphics.newQuad(x, y, width, height, texture)
```

`texture` is retrieved with the `:getDimensions()` method, available on the image itself.

## Menu

In the start state, and below the title of the game, the idea is to include options to select a level with more cards and types of cards to match. `self.index` is an integer to shuffle through the option, and is used to style the selected option.

```lua
if option.index == self.index then
  -- selection
else
  -- default appearance
end
```

Moreover, the value is passed to the play state when the player selects an option.

```lua
gStateMachine:change(
  "play",
  {
    level = self.index + 1
  }
)
```

## Gameplay

The `Card` class defines an object with three booleans, describing whether the card is being focused on, has been revealed or was matched.

```lua
function Card:init(x, y, symbol)
  -- other attributes

  self.isFocused = false
  self.isRevealed = false
  self.isPaired = false
end
```

There are also several utility functions to set the different booleans to `true` or `false`, instead of operating on the variables directly.

```lua
function Card:match()
  self.isPaired = true
end

function Card:focus()
  self.isFocused = true
end

-- other functions
```

In the play state, the idea is to consider the boolean variables through two additional variables: `firstRevealed` and `secondRevealed`.

```lua
function PlayState:init()
  self.firstRevealed = nil
  self.secondRevealed = nil
end
```

The variables eventually eventually store a unique key which describe the first and second card being selected. The key refers to the column and row of the card in the grid of cards.

```lua
function PlayState:getKey(column, row)
  return "c" .. self.column .. "r" .. self.row
end
```

When pressing the enter key, the idea is to consider the state of the selected card on top of the cards behind the two keys:

- if the selected card has already been paired, do nothing past hiding the first card being revealed, if revealed at all

- if `firstRevealed` and `secondRevealed` both describe a card, a non `nil` value, proceed to reset both values. In case the symbols of the two cards don't match, be sure to also hide both cards

- if `firstRevealed` describes a card, consider its value against the selected option. If the two are one and the same, hide the card back. Otherwise, consider a match between `firstRevealed` and the now chosen `secondRevealed`

- if `firstRevealed` doesn't describe a card, store a reference to the card being selected

## Grid

The way the cards are laid in a grid is perhaps deserving of its own section, but the solution is the result of trial and error more than a conscious decision.

Starting from a fixed number of columns, the play state computes the rows considering the number of cards (this value changes according to the input level).

With the number of columns and rows, then, the idea is to position the cards at specific coordinates. This is achieved by computing the size of the columns and rows themselves.

To populate the grid, finally, the idea is to add two cards for each chosen symbol. To guarantee that:

1. the symbols are unique

2. the cards are not included in order

I lean on the construct of a `repeat .. until` loop. Two loops actually.

The idea is to have a table describe the chosen symbols and positions.

```lua
local symbols = {}
local positions = {}
```

For each pair of cards, `symbol` then picks a random value between the desired symbols. If the value is already included in the table, however, the operation is repeated.

```lua
local symbol

repeat
  symbol = math.random(numberSymbols)
until not symbols[symbol]
symbols[symbol] = true
```

The table is updated once a symbol is picked, to avoid choosing the value again.

The same logic is repeated for the positions, but this time considering twice the number of cards. This is because, for each symbol, it is necessary to include two copies.

```lua
repeat
  position = math.random(numberCards * 2)
until not positions[position]
positions[position] = true
```

## Mouse controls

The game is updated to consider mouse input, and the following logic:

- press the left button to move forward, between states and playing the game

- press the right button to move backwards and eventually quit the game altogether

Considering the way the game is created, the play state needs to know about the column and row of the selected card. `column` and `row` are passed to each instance of the `Card` class so that, when the mouse hovers on one of the cards, it is possible to retrieve the matching coordinates. Previously, and with keyboard input, the values was computed on the basis of the arrow key being pressed. With a mouse cursor, however, the selection can vary across multiple columns and rows.

When playing and pressing the left key on one of the cards, the functionality mirrors that of a press on the enter, or return key. In light of this, the logic is extracted to a function `PlayState:handleSelection`, which is then called as necessary.

```lua
if love.keyboard.waspressed("return") then
  self:handleSelection()
end
```

For the mouse press, note, the execution of the function depends on one of the card being hovered on.

```lua
if cardOverlap then
  -- ... handle focus

  if love.mouse.waspressed(1) then
    self:handleSelection()
  end
end
```

## Suggestions

Pokemon types have a hierarchy, with some overpowering others. In light of this, the game could be updated to consider not matching the cards in pairs, but relative to this hierarchy. Picking fire, for instance, would require you to look for grass, or again ice.
