module KnightMoves
  def knight_helper(board, pos_x, pos_y, color)
    possible_moves = []
    possible_moves += knight_north_helper(board, pos_x, pos_y, color)
    possible_moves += knight_west_helper(board, pos_x, pos_y, color)
    possible_moves += knight_south_helper(board, pos_x, pos_y, color)
    possible_moves += knight_east_helper(board, pos_x, pos_y, color)
    possible_moves
  end

  private

  def knight_north_helper(board, pos_x, pos_y, color)
    moves = []
    moves << [pos_x + 2, pos_y + 1]
    moves << [pos_x + 2, pos_y - 1]
    valid_moves(moves, board, color)
  end

  def knight_south_helper(board, pos_x, pos_y, color)
    moves = []
    moves << [pos_x - 2, pos_y + 1]
    moves << [pos_x - 2, pos_y - 1]
    valid_moves(moves, board, color)
  end

  def knight_east_helper(board, pos_x, pos_y, color)
    moves = []
    moves << [pos_x + 1, pos_y + 2]
    moves << [pos_x - 1, pos_y + 2]
    valid_moves(moves, board, color)
  end

  def knight_west_helper(board, pos_x, pos_y, color)
    moves = []
    moves << [pos_x + 1, pos_y - 2]
    moves << [pos_x - 1, pos_y - 2]
    valid_moves(moves, board, color)
  end
end
