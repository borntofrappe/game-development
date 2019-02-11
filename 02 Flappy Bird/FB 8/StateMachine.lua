-- create a state machine class
StateMachine = Class{}

--[[
  in the init() function consider states, a table of possible states passed as argument
  initialize the class with the following fields
  - empty, a table of fields referencing empty functions (these mirror the functions later defined in the individual states)
  - states, referencing the value passed in the init function or an empty table otherwise
  - current, referencing the state currently being shown by the state machine
]]
function StateMachine:init(states)
  self.empty = {
    render = function() end,
    update = function() end,
    enter = function() end,
    exit = function() end
  }
  self.states = states or {}
  -- by default set current to reference the table of empty functions
  self.current = self.empty
end


-- in a change() function consider the name of the state as well as (optional) parameters
-- enterParams refer to those values which are passed to the :enter() class of the individual states to render something (like the score for the eventual score state)
function StateMachine:change(stateName, enterParams)
  -- make sure stateName refers to a valid state value
  assert(self.states[stateName])
  -- exit from the current state
  self.current:exit()
  -- set current to refer to the new state
  -- current is made to reference the return value of the functions making up the table of states (check main.lua, line 100)
  self.current = self.states[stateName]()
  -- introduce the state
  self.current:enter(enterParams)
end

-- in the update(dt) function update the game by delegating the update logic to the current state
function StateMachine:update(dt)
  self.current:update(dt)
end

-- like for the update function, delegate the rendering of the game to the specific state class
function StateMachine:render()
  self.current:render()
end