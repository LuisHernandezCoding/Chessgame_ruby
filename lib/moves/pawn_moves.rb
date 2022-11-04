module PawnMoves
  def pawn_helper(board, pos_x, pos_y, color, last_move)
    possible_moves = []
    if color == 'white'
      possible_moves += pawn_white_towards_helper(board, pos_x, pos_y)
      possible_moves += pawn_white_diagonal_helper(board, pos_x, pos_y, last_move)
    else
      possible_moves += pawn_black_towards_helper(board, pos_x, pos_y)
      possible_moves += pawn_black_diagonal_helper(board, pos_x, pos_y, last_move)
    end
    possible_moves
  end

  private

  def pawn_black_towards_helper(board, pos_x, pos_y)
    possible_moves = []
    possible_moves << [pos_x + 1, pos_y] if board[pos_x + 1][pos_y] == ' '
    if pos_x == 1 && board[pos_x + 2][pos_y] == ' ' && board[pos_x + 1][pos_y] == ' '
      possible_moves << [pos_x + 2, pos_y]
    end
    possible_moves
  end

  def pawn_white_towards_helper(board, pos_x, pos_y)
    possible_moves = []
    possible_moves << [pos_x - 1, pos_y] if board[pos_x - 1][pos_y] == ' '
    if pos_x == 6 && board[pos_x - 2][pos_y] == ' ' && board[pos_x - 1][pos_y] == ' '
      possible_moves << [pos_x - 2, pos_y]
    end
    possible_moves
  end

  def pawn_black_diagonal_helper(board, pos_x, pos_y, last_move)
    possible_moves = []
    possible_moves << [pos_x + 1, pos_y - 1] if pos_y != 0 && white_pieces.include?(board[pos_x + 1][pos_y - 1])
    possible_moves << [pos_x + 1, pos_y + 1] if pos_y != 7 && white_pieces.include?(board[pos_x + 1][pos_y + 1])
    possible_moves += en_passant_helper(pos_x, pos_y, last_move, 'black') if last_move
    possible_moves
  end

  def pawn_white_diagonal_helper(board, pos_x, pos_y, last_move)
    possible_moves = []
    possible_moves << [pos_x - 1, pos_y - 1] if pos_y != 0 && black_pieces.include?(board[pos_x - 1][pos_y - 1])
    possible_moves << [pos_x - 1, pos_y + 1] if pos_y != 7 && black_pieces.include?(board[pos_x - 1][pos_y + 1])
    possible_moves += en_passant_helper(pos_x, pos_y, last_move, 'white') if last_move
    possible_moves
  end

  def en_passant_helper(pos_x, pos_y, last_move, color)
    possible_moves = []
    possible_moves = white_en_passant_helper(pos_x, pos_y, last_move) if color == 'white'
    possible_moves = black_en_passant_helper(pos_x, pos_y, last_move) if color == 'black'
    possible_moves
  end

  def white_en_passant_helper(pos_x, pos_y, last_move)
    possible_moves = []
    return possible_moves if pos_x != 3

    possible_moves << [pos_x - 1, pos_y - 1] if last_move[0] == pawn_black && last_move[3] == [pos_x, pos_y - 1]
    possible_moves << [pos_x - 1, pos_y + 1] if last_move[0] == pawn_black && last_move[3] == [pos_x, pos_y + 1]
    possible_moves
  end

  def black_en_passant_helper(pos_x, pos_y, last_move)
    possible_moves = []
    return possible_moves if pos_x != 4

    possible_moves << [pos_x + 1, pos_y - 1] if last_move[0] == pawn_white && last_move[3] == [pos_x, pos_y - 1]
    possible_moves << [pos_x + 1, pos_y + 1] if last_move[0] == pawn_white && last_move[3] == [pos_x, pos_y + 1]
    possible_moves
  end
end
