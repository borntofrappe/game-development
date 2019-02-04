# Pong with Lua

## Preface

The [first video](https://youtu.be/jZqYXSmgDuM) in the playlist behind this repository tackles the lua programming language and the love2d environment with the video game Pong in mind.

<!-- convention -->
<!-- each section is prefaced by an h2 heading and structured as follows
Index: according to the h3, h4 headings which explain the section
Snippets: referencing the actual code produced alongside the section
Each snippet ought to be pushed in the repo for reference
-->

## Getting Started

Index:

- [Installing Love2D](#installing-love2d)

- [Running a silly program](#running-a-silly-program)

Snippets:

- 01 getting_started.lua

### Installing Love2D

It is first necessary to install the Love2D framework. From [the homepage itself](https://love2d.org/) the installer provides the quickest solution. Once installed, the main reference is [the wiki](https://love2d.org/wiki/Main_Page).

### Running a silly program

In the [getting started](https://love2d.org/wiki/Getting_Started) section, the wiki provides a few ways to run a love2d program. For proof of concept, here's how to print `Hello world` through the framework.

1. create a `main.lua` file. I placed this file in a `Pong` folder, just for context.

1. write the following three lines of code:

    ```lua
    function love.draw()
      love.graphics.print('Hello world', 400, 300)
    end
    ```
    
    I am not acquainted with the Lua programming language, but it seems to be based on indentation and it seems to shy away from semicolons. VSCode was nice enough to indent each line without need to adjust the line position.
    
1. drag the folder containing the `main.lua` file on top of the `Love2D` program, or a shortcut to said program. Personally, I created a shortcut and placed it in the root folder, right beside the `Pong` folder.

    This should fire up Love2D and present the hello world string. The two integers seem to be referencing the coordinates of the string. The coordinate system, as explained in the video, works like the coordinate system in SVG land: from the top left corner.
    
## Introductory concepts

Index:

- [Game Loop](#game-loop)

- [2D Coordinate System](#2d-coordinate-system)

### Game Loop

Infinite loop which continuously:

- listens for input

- updates the game according to the input

- renders whatever has updated <!-- react?! -->.

### 2D Coordinate System

Exactly like with SVG syntax, the coordinate system works top to bottom, left to right.

If you think of a 1x1 square, the following representation highlights this coordinate system

```text
(0, 0) (1, 0)
(0, 1) (1, 1)
```

## Pong 0

<!-- for each branch explained in the video include
- a section devoted to lessons learned while reading the codebase
- a section devoted to lessons learned while watching the video, itself commenting the codebase
-->

Index:

- [Pong 0 Code](#pong-0-code)

- [Pong 0 Notes](#pong-0-notes)

Snippets:

- 02 love_setup.lua

### Pong 0 Code

- resolutions is set in the form of screen width and height. Two constant variables are declared in the global scope:

    ```lua
    WINDOW_WIDTH = 1280
    WINDOW_HEIGHT = 720
    ```

Notice again the lack of semicolons. Notice also the lack of a type or any identifier for the variable.

- love works <!-- in mysterious ways --> through two main functions: `love.load()` and `love.draw()`.

    `love.load()` runs once, as the game starts out. It is here that you ought to set those variables and options which initialize the games.

    `love.draw()` runs after a love2d update, to literally draw something on th screen.

- in the load function, the size of the screen is modified through the `setMode()` method. This alters the size of the window as follows:

      ```lua
      love.window.setMode(width, height, options)
      ```

     `options` relates to an object detailing additional settings on the window.

- in the draw function, text is printed on the screen through the `printf` method. It works as follows:

      ```lua
      love.graphics.printf(text, x, y, centerScope, centerKeyword)
      ``` 
    
    `x` and `y` dictacte where the text ought to be positioned. `centerScope` relates to the scope in which the text ought to be centered (in the snippet the text is centered in relation to the width if the screen). Finally `centerKeyword` is exactly that, a keyword like `center` to deetermine the actual position.

- last, but perhaps most importantly, comments are included following two dashes: `--`. Multi line comments follow up the two dashes with two sets of square brackets `--[[ ]]`.

## Pong 0 Notes

The three main functions are:

- `love.load()`. Love2d will look in a main.lua file and run love.load(). This is akin to a startup function, where you ought to initialize the project.

- `love.update(dt)`. `dt` being delta time. Love2D calls this function on each frame, and you can use the argument to update the application according to the passage of time.

- `love.draw()`. Drawing and rendering behavior is encapsulated in this function.

Also important functions, but nested within the big three are:

- `love.graphics.printf()`. Drawing physically to the screen.

- `love.window.setMode()`. Setting up the window and a few parameters.

Beside these elements from the love2D framework, and regarding more the programming language, tables in lua are the equivalent of objects in JavaScript, and follow the syntax:

```lua
{
  property = value,
  property = value,
  property = value,
}
```
