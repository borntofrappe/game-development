# Bouldy

Move a little square inside of a maze to collect a few coins.

## Preface

The game has the player move inside of a maze, bound by its walls and gates. With every step of uninterrupted movement the player gains speed. When the speed reaches an arbitrary threshold, the player is then able to destroy gates and step to the other side.

The project is an excellent excuse to implement a maze structure with the recursive backtracker algorithm, create a GUI element in the form of a progress bar and rehearse Love2D particle system.

## Timer

The library is slightly modified from that introduced in `Utils/Timer`:

- it is possible to execute the callback function for the interval immediately

- it is possible to pass a callback function to the tween method, which gets executed as the animation is completed
