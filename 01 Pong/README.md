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
