# Animation

While I have already made a first attempt in animating the character, by rapidly changing the stance through dedicated variables, the lecturer includes animation through a custom class, `Animation`.  I therefore decided to remove my variables in favor of this solution. This doesn't mean the code was include for nothing though. The logic of how the character is updated, like a flip book, and the way the character is made to look the opposite way, by setting the `xScale` to negative values, are concepts which repeat themselves.

## Update 0 - animation.lua

I tried to comment the **Animation.lua** as much as possible, to understand the inner logic of the class, but here I'll also add a few notes jotted down while reviewing the video.

Here's the idea behind the class:

- pass in a table with the possible values through which the class needs to loop;

- pass in the interval describing how rapidly the values are modified.

In light of this it seems that `def` is an argument referring to every variable passed through the class, like `params` for the `:enter` counterpart.

Back to the class:

- using the table and set interval loop through the table and through a custom function, `getCurrentFrame`, return the frame referred to by the interval.

The idea seems to have the class update the frames and use the function in `main.lua` to actually change the appearance of the character. Rather comprehensible once the `def` argument is understood.