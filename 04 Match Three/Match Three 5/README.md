# Match Three 5 - State Machine

The previous updates have focused on a key feature of the game, but only a feature nonetheless. The board, allowing to swap, match and clear tiles needs to be incorporated into a larger structure, detailing the game from start to finish.

Considering the overall experience, the game can be described according to the following states:

```text
startState → playState
    ↑           |
    |           |
    |           ↓
     ----- gameoverState
```

It is not a complex structure, but the transitions introduced in between the states provide a bit of a challenge. Not to mention the transitions included in the states, like the title `Match 3` changing in color rapidly and one letter at a time.

## Goal

With this update I will forgo the time-based animations and create the different states, which can be alternated by pressing enter . Here's the goal of the update:

- introduce a start state in which the title and a menu are shown;

- when pressing enter go to the play state;

- when pressing a enter go to the gameover state;

- when pressing enter go back to the start state.

Lather, rinse, repeat.

Ultimately:

- the play state needs to incorporate a panel with the game information, not to mention the actual board;

- the gameover state ought to be shown when a timer hits 0;

- there needs to be a victory, or level state showing the level being reached.

To get started with the state machine behind the game, adding the functionality detailed above seems to be enough.

## Getting Started

Using the same assets introduced in Flappy Bird, and reiterated in breakout, the folder is restructured as to include:

- `StateMachine.lua`, in the `src` folder;

- the different states in the the `src/states` sub-folder. Starting with `BaseState.lua`, from which all following states inherit.

To include these components, `Dependencies.lua` is updated to require each one of the `.lua` files.

## main.lua

The entry point to the game is updated as to include an instance of the state machine and immediately move the game to the `StartState`. I also modified the file to remove any reference to the board, included later in the `PlayState`, and rearranged a bit the code, in the hope of making it easier to parse through.

## StartState

The state shown immediately as the game is fired up is used to introduce the game and show two options: start playing or quit the game early.

In terms of interactivity, the state doesn't differ from the counterpart created in the Breakout game. The comments included in the update function will suffice.

In terms of design however, there are a few challenges worth explaining.

Looking at the design, the state needs to:

- show the headings and options on top of a white rectangle;

- add a shadow beneath each word.

The rectangles are included through the `love.graphics.rectangle()` function.

The shadows are instead included through a copy of the words, slightly offset and placed before the actual words.

```lua
-- SHADOW
love.graphics.setColor(0, 0, 0, 1)
love.graphics.print('Word', 9, 9)

-- WORD
love.graphics.setColor(1, 1, 1, 1)
love.graphics.print('Word', 8, 8)
```

On top of these elements, the word making up the heading needs to draw the word one letter at a time, to later change the color of each letter individually.

The word is specified through a table:

```lua
self.title = { 'M', 'A', 'T', 'C', 'H', '', '3'}
```

And each letter is included using the `love.graphics.printf()` function looping through said table.

A bit of match is required to have the word centered on the screen, but the idea is to have each letter spread around the center according to its position in the table. Notice that the penultimate item is an empty string. This is include to have the number three separated from the word match, but it might cause a few issues when the change in colors is introduced. Just remember that the table is 1 letter longer than the actual word.

One last note in terms of design: the `init` function also introduces `self.colors`, describing the colors ultimately used for the headings. This feature will be implemented in a future update.

## PlayState & GameoverState

The two state classes are introduced without much consideration, simply to alternate between the different states.

Indeed the goal of this update was to introduce the state machine. While I got a bit carried away with the `StartState`, the game is now set up to include time-based events.

Such as:

- color each word of the heading at an interval;

- count down a certain number of seconds, incrementing the value and reacting to it reaching 0.
