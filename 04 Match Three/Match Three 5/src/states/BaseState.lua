-- class created with the basic structure of the individual states
-- each state then inherits from this class
BaseState = Class{}

-- create functions (currently doing nothing) for the different stages of the state
-- initialization
function BaseState:init() end
-- entering
function BaseState:enter() end
-- exiting
function BaseState:exit() end
-- updating
function BaseState:update(dt) end
-- rendering
function BaseState:render() end

-- the idea is to take this as a template and in the individual states define the actual behaviors