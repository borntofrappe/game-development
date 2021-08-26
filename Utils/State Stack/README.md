# State Stack

The concept of a state stack is introduced in the context of the game <i>Pokemon</i>, as an approach to manage state different from the one allowed by a state machine. The difference boils down to how the states are managed:

- in a state machine there exist only one state at a time. The machine is responsible for updating the state's logic and rendering the necessary visuals

- in a state stack it is possible to maintain multiple states. You push and pop states to the stack, which renders the visual of every state, but updates the logic of only the topmost level

With this folder I replicate the example highlighted in `07 Pokemon/State Stack`, without relying on a class library. The notes are adapted to this change.
