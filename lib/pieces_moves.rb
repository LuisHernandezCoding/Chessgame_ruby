require_relative 'pieces'

module PiecesMoves
  extend Pieces
  # gets board and position of the piece & returns an array of possible moves
  # it should have in consideration the pieces in the board and the color of the piece
  # for example, if the piece is a white pawn, it should not be able to move to a black piece
  # if it is in front of it, but in the diagonal it should be able to move there
  def pawn_moves(board, from, color)
    return [] if from[0] == 7 && color == 'white'
    return [] if from[0].zero? && color == 'black'

    pos_x, pos_y = from
    possible_moves = []
    if color == 'white'
      possible_moves += pawn_white_towards_helper(board, pos_x, pos_y)
      possible_moves += pawn_white_diagonal_helper(board, pos_x, pos_y)
    else
      possible_moves += pawn_black_towards_helper(board, pos_x, pos_y)
      possible_moves += pawn_black_diagonal_helper(board, pos_x, pos_y)
    end
    possible_moves
  end

  def rook_moves(board, from, color)
    pos_x, pos_y = from
    possible_moves = []
    possible_moves += rook_horizontal_helper(board, pos_x, pos_y, color)
    possible_moves += rook_vertical_helper(board, pos_x, pos_y, color)
    possible_moves
  end

  private

  def pawn_white_towards_helper(board, pos_x, pos_y)
    possible_moves = []
    possible_moves << [pos_x + 1, pos_y] if board[pos_x + 1][pos_y] == ' '
    possible_moves << [pos_x + 2, pos_y] if pos_x == 1 && board[pos_x + 2][pos_y] == ' '
    possible_moves
  end

  def pawn_black_towards_helper(board, pos_x, pos_y)
    possible_moves = []
    possible_moves << [pos_x - 1, pos_y] if board[pos_x - 1][pos_y] == ' '
    possible_moves << [pos_x - 2, pos_y] if pos_x == 6 && board[pos_x - 2][pos_y] == ' '
    possible_moves
  end

  def pawn_white_diagonal_helper(board, pos_x, pos_y)
    possible_moves = []
    possible_moves << [pos_x + 1, pos_y - 1] if pos_y != 0 && black_pieces.include?(board[pos_x + 1][pos_y - 1])
    possible_moves << [pos_x + 1, pos_y + 1] if pos_y != 7 && black_pieces.include?(board[pos_x + 1][pos_y + 1])
    possible_moves
  end

  def pawn_black_diagonal_helper(board, pos_x, pos_y)
    possible_moves = []
    possible_moves << [pos_x - 1, pos_y - 1] if pos_y != 0 && white_pieces.include?(board[pos_x - 1][pos_y - 1])
    possible_moves << [pos_x - 1, pos_y + 1] if pos_y != 7 && white_pieces.include?(board[pos_x - 1][pos_y + 1])
    possible_moves
  end

  def rook_horizontal_helper(board, pos_x, pos_y, color)
    moves = []
    moves += rook_east_helper(board, pos_x, pos_y, color)
    moves += rook_west_helper(board, pos_x, pos_y, color)
    moves
  end

  def rook_vertical_helper(board, pos_x, pos_y, color)
    moves = []
    moves += rook_north_helper(board, pos_x, pos_y, color)
    moves += rook_south_helper(board, pos_x, pos_y, color)
    moves
  end

  def rook_north_helper(board, pos_x, pos_y, color)
    moves = []
    (pos_x + 1).upto(7) do |i|
      moves << [i, pos_y] if board[i][pos_y] == ' '
      if white_pieces.include?(board[i][pos_y])
        moves << [i, pos_y] if color == 'black'
        break
      end
      if black_pieces.include?(board[i][pos_y])
        moves << [i, pos_y] if color == 'white'
        break
      end
    end
    moves
  end

  def rook_south_helper(board, pos_x, pos_y, color)
    moves = []
    (pos_x - 1).downto(0) do |i|
      moves << [i, pos_y] if board[i][pos_y] == ' '
      if white_pieces.include?(board[i][pos_y])
        moves << [i, pos_y] if color == 'black'
        break
      end
      if black_pieces.include?(board[i][pos_y])
        moves << [i, pos_y] if color == 'white'
        break
      end
    end
    moves
  end

  def rook_east_helper(board, pos_x, pos_y, color)
    moves = []
    (pos_y + 1).upto(7) do |i|
      moves << [pos_x, i] if board[pos_x][i] == ' '
      if white_pieces.include?(board[pos_x][i])
        moves << [pos_x, i] if color == 'black'
        break
      end
      if black_pieces.include?(board[pos_x][i])
        moves << [pos_x, i] if color == 'white'
        break
      end
    end
    moves
  end

  def rook_west_helper(board, pos_x, pos_y, color)
    moves = []
    (pos_y - 1).downto(0) do |i|
      moves << [pos_x, i] if board[pos_x][i] == ' '
      if white_pieces.include?(board[pos_x][i])
        moves << [pos_x, i] if color == 'black'
        break
      end
      if black_pieces.include?(board[pos_x][i])
        moves << [pos_x, i] if color == 'white'
        break
      end
    end
    moves
  end
end
