module KingMoves
  def king_helper(board, pos_x, pos_y, color)
    moves = []
    moves << [pos_x + 1, pos_y]
    moves << [pos_x - 1, pos_y]
    moves << [pos_x, pos_y + 1]
    moves << [pos_x, pos_y - 1]
    moves << [pos_x + 1, pos_y + 1]
    moves << [pos_x + 1, pos_y - 1]
    moves << [pos_x - 1, pos_y + 1]
    moves << [pos_x - 1, pos_y - 1]
    moves += castling_helper(board, color)
    valid_moves(moves, board, color)
  end
end
