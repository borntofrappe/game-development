Piece = {}

function Piece:new()
    local this = {}

    self.__index = self
    setmetatable(this, self)

    return this
end
