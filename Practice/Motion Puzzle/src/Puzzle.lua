Puzzle = {}

function Puzzle:new(level)
    local pieces = {}

    for column = 1, PUZZLE_DIMENSIONS do
        pieces[column] = {}
        for row = 1, PUZZLE_DIMENSIONS do
            pieces[column][row] = {
                ["column"] = column,
                ["row"] = row
            }
        end
    end

    local this = {
        ["level"] = level,
        ["frame"] = 1,
        ["pieces"] = pieces
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Puzzle:render()
    for i, column in ipairs(self.pieces) do
        for j, piece in ipairs(column) do
            love.graphics.draw(
                gTexture,
                gQuads.levels[self.level][self.frame][piece.column][piece.row],
                (piece.column - 1) * PIECE_SIZE,
                (piece.row - 1) * PIECE_SIZE
            )
        end
    end
end
