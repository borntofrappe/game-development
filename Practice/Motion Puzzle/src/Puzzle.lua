Puzzle = {}

function Puzzle:new(level)
    local piecesPositions = {}
    for column = 1, PUZZLE_DIMENSIONS do
        for row = 1, PUZZLE_DIMENSIONS do
            table.insert(
                piecesPositions,
                {
                    ["column"] = column,
                    ["row"] = row
                }
            )
        end
    end

    local pieces = {}

    for column = 1, PUZZLE_DIMENSIONS do
        for row = 1, PUZZLE_DIMENSIONS do
            local piecePosition = table.remove(piecesPositions, love.math.random(#piecesPositions))
            local key = GenerateKey(piecePosition.column, piecePosition.row)

            pieces[key] = {
                ["column"] = column,
                ["row"] = row,
                ["position"] = {
                    ["column"] = piecePosition.column,
                    ["row"] = piecePosition.row
                }
            }
        end
    end

    local level = level or love.math.random(#gQuads.levels)
    local frames = #gQuads.levels[level]

    local this = {
        ["dimensions"] = PUZZLE_DIMENSIONS,
        ["level"] = level,
        ["frame"] = 1,
        ["frames"] = frames,
        ["pieces"] = pieces
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Puzzle:render()
    for k, piece in pairs(self.pieces) do
        love.graphics.draw(
            gTexture,
            gQuads.levels[self.level][self.frame][piece.column][piece.row],
            (piece.position.column - 1) * PIECE_SIZE,
            (piece.position.row - 1) * PIECE_SIZE
        )
    end
end
