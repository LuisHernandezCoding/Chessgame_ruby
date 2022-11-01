require_relative 'pieces'

module PiecesMoves
  extend Pieces
  def pawn_moves(board, from, color)
    return [] if from[0].zero? && color == 'white'
    return [] if from[0] == 7 && color == 'black'

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

  def bishop_moves(board, from, color)
    pos_x, pos_y = from
    possible_moves = []
    possible_moves += bishop_north_east_helper(board, pos_x, pos_y, color)
    possible_moves += bishop_south_west_helper(board, pos_x, pos_y, color)
    possible_moves += bishop_north_west_helper(board, pos_x, pos_y, color)
    possible_moves += bishop_south_east_helper(board, pos_x, pos_y, color)
    possible_moves
  end

  def knight_moves(board, from, color)
    pos_x, pos_y = from
    possible_moves = []
    possible_moves += knight_north_helper(board, pos_x, pos_y, color)
    possible_moves += knight_west_helper(board, pos_x, pos_y, color)
    possible_moves += knight_south_helper(board, pos_x, pos_y, color)
    possible_moves += knight_east_helper(board, pos_x, pos_y, color)
    possible_moves
  end

  def queen_moves(board, from, color)
    pos_x, pos_y = from
    possible_moves = []
    possible_moves += rook_horizontal_helper(board, pos_x, pos_y, color)
    possible_moves += rook_vertical_helper(board, pos_x, pos_y, color)
    possible_moves += bishop_north_east_helper(board, pos_x, pos_y, color)
    possible_moves += bishop_south_west_helper(board, pos_x, pos_y, color)
    possible_moves += bishop_north_west_helper(board, pos_x, pos_y, color)
    possible_moves += bishop_south_east_helper(board, pos_x, pos_y, color)
    possible_moves.uniq
  end

  def king_moves(board, from, color)
    pos_x, pos_y = from
    possible_moves = []
    possible_moves += king_helper(board, pos_x, pos_y, color)
    possible_moves
  end

  def castling_helper(board, color)
    if color == 'white'
      actual_line = 7
      actual_king = king_white
      actual_rook = rook_white
    else
      actual_line = 0
      actual_king = king_black
      actual_rook = rook_black
    end
    moves = []
    pos1, pos2, pos3, pos4, pos5, pos6, pos7, pos8 = board[actual_line]
    moves << [actual_line, 6] if board[actual_line] == [pos1, pos2, pos3, pos4, actual_king, ' ', ' ', actual_rook]
    moves << [actual_line, 5] if board[actual_line] == [pos1, pos2, pos3, actual_king, ' ', ' ', ' ', actual_rook]
    moves << [actual_line, 1] if board[actual_line] == [actual_rook, ' ', ' ', actual_king, pos5, pos6, pos7, pos8]
    moves << [actual_line, 2] if board[actual_line] == [actual_rook, ' ', ' ', ' ', actual_king, pos6, pos7, pos8]
    moves
  end

  def castling_rook_helper(color, destiny_pos)
    actual_line = color == 'white' ? 7 : 0
    case destiny_pos[1]
    when 6 then [actual_line, 5]
    when 5 then [actual_line, 6]
    when 2 then [actual_line, 3]
    when 1 then [actual_line, 2]
    end
  end

  private

  def pawn_black_towards_helper(board, pos_x, pos_y)
    possible_moves = []
    possible_moves << [pos_x + 1, pos_y] if board[pos_x + 1][pos_y] == ' '
    possible_moves << [pos_x + 2, pos_y] if pos_x == 1 && board[pos_x + 2][pos_y] == ' '
    possible_moves
  end

  def pawn_white_towards_helper(board, pos_x, pos_y)
    possible_moves = []
    possible_moves << [pos_x - 1, pos_y] if board[pos_x - 1][pos_y] == ' '
    possible_moves << [pos_x - 2, pos_y] if pos_x == 6 && board[pos_x - 2][pos_y] == ' '
    possible_moves
  end

  def pawn_black_diagonal_helper(board, pos_x, pos_y)
    possible_moves = []
    possible_moves << [pos_x + 1, pos_y - 1] if pos_y != 0 && white_pieces.include?(board[pos_x + 1][pos_y - 1])
    possible_moves << [pos_x + 1, pos_y + 1] if pos_y != 7 && white_pieces.include?(board[pos_x + 1][pos_y + 1])
    possible_moves
  end

  def pawn_white_diagonal_helper(board, pos_x, pos_y)
    possible_moves = []
    possible_moves << [pos_x - 1, pos_y - 1] if pos_y != 0 && black_pieces.include?(board[pos_x - 1][pos_y - 1])
    possible_moves << [pos_x - 1, pos_y + 1] if pos_y != 7 && black_pieces.include?(board[pos_x - 1][pos_y + 1])
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

  def bishop_north_east_helper(board, pos_x, pos_y, color)
    moves = []
    (pos_x + 1).upto(7) do |i|
      break if pos_y == 7

      pos_y += 1
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

  def bishop_south_west_helper(board, pos_x, pos_y, color)
    moves = []
    (pos_x - 1).downto(0) do |i|
      break if pos_y.zero?

      pos_y -= 1
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

  def bishop_north_west_helper(board, pos_x, pos_y, color)
    moves = []
    (pos_x + 1).upto(7) do |i|
      break if pos_y.zero?

      pos_y -= 1
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

  def bishop_south_east_helper(board, pos_x, pos_y, color)
    moves = []
    (pos_x - 1).downto(0) do |i|
      break if pos_y == 7

      pos_y += 1
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

  def valid_moves(moves, board, color)
    valid_moves = []
    moves.each do |move|
      next unless inside_board?(move)

      valid_moves << move if board[move[0]][move[1]] == ' '
      if color == 'white'
        valid_moves << move if black_pieces.include?(board[move[0]][move[1]])
      elsif white_pieces.include?(board[move[0]][move[1]])
        valid_moves << move
      end
    end
    valid_moves
  end

  def inside_board?(move)
    return true if move[0].between?(0, 7) && move[1].between?(0, 7)
  end
end
