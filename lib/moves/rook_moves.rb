module RookMoves
  def rook_helper(board, pos_x, pos_y, color)
    moves = []
    moves += rook_east_helper(board, pos_x, pos_y, color)
    moves += rook_west_helper(board, pos_x, pos_y, color)
    moves += rook_north_helper(board, pos_x, pos_y, color)
    moves += rook_south_helper(board, pos_x, pos_y, color)
    moves
  end

  private

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
