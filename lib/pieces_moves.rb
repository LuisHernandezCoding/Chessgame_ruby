require_relative 'pieces'

module PiecesMoves
  extend Pieces
  # gets board and position of the piece & returns an array of possible moves
  # it should have in consideration the pieces in the board and the color of the piece
  # for example, if the piece is a white pawn, it should not be able to move to a black piece
  # if it is in front of it, but in the diagonal it should be able to move there
  def pawn_moves(board, from, color)
    return [] if from[0] == 7 && color == 'white'
    return [] if from[0] == 0 && color == 'black'

    possible_moves = []
    if color == 'white'
      # it should use black_pieces to check if there is a piece in front of it
      possible_moves << [from[0] + 1, from[1]] if board[from[0] + 1][from[1]] == ' '
      possible_moves << [from[0] + 2, from[1]] if from[0] == 1 && board[from[0] + 2][from[1]] == ' '
      possible_moves << [from[0] + 1, from[1] - 1] if from[1] != 0 && black_pieces.include?(board[from[0] + 1][from[1] - 1])
      possible_moves << [from[0] + 1, from[1] + 1] if from[1] != 7 && black_pieces.include?(board[from[0] + 1][from[1] + 1])
    else
      # it should use white_pieces to check if there is a piece in front of it
      possible_moves << [from[0] - 1, from[1]] if board[from[0] - 1][from[1]] == ' '
      possible_moves << [from[0] - 2, from[1]] if from[0] == 6 && board[from[0] - 2][from[1]] == ' '
      possible_moves << [from[0] - 1, from[1] - 1] if from[1] != 0 && white_pieces.include?(board[from[0] - 1][from[1] - 1])
      possible_moves << [from[0] - 1, from[1] + 1] if from[1] != 7 && white_pieces.include?(board[from[0] - 1][from[1] + 1])
    end
    possible_moves
  end

  def rook_moves(board, from, color)
    x, y = from
    moves = []
    moves += rook_horizontal_moves(board, x, y, color)
    moves += rook_vertical_moves(board, x, y, color)
    moves
  end

  def rook_horizontal_moves(board, x, y, color)
    moves = []
    (y + 1).upto(7) do |i|
      if board[x][i] == ' '
        moves << [x, i]
      elsif white_pieces.include?(board[x][i]) && color == 'black'
        moves << [x, i]
        break
      elsif black_pieces.include?(board[x][i]) && color == 'white'
        moves << [x, i]
        break
      else
        break
      end
    end
    (y - 1).downto(0) do |i|
      if board[x][i] == ' '
        moves << [x, i]
      elsif white_pieces.include?(board[x][i]) && color == 'black'
        moves << [x, i]
        break
      elsif black_pieces.include?(board[x][i]) && color == 'white'
        moves << [x, i]
        break
      else
        break
      end
    end
    moves
  end
  def rook_vertical_moves(board, x, y, color)
    moves = []
    (x + 1).upto(7) do |i|
      if board[i][y] == ' '
        moves << [i, y]
      elsif white_pieces.include?(board[i][y]) && color == 'black'
        moves << [i, y]
        break
      elsif black_pieces.include?(board[i][y]) && color == 'white'
        moves << [i, y]
        break
      else
        break
      end
    end
    (x - 1).downto(0) do |i|
      if board[i][y] == ' '
        moves << [i, y]
      elsif white_pieces.include?(board[i][y]) && color == 'black'
        moves << [i, y]
        break
      elsif black_pieces.include?(board[i][y]) && color == 'white'
        moves << [i, y]
        break
      else
        break
      end
    end
    moves
  end
end
