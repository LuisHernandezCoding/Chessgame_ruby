module BishopMoves
  def bishop_helper(board, pos_x, pos_y, color)
    possible_moves = []
    possible_moves += bishop_north_east_helper(board, pos_x, pos_y, color)
    possible_moves += bishop_south_west_helper(board, pos_x, pos_y, color)
    possible_moves += bishop_north_west_helper(board, pos_x, pos_y, color)
    possible_moves += bishop_south_east_helper(board, pos_x, pos_y, color)
    possible_moves
  end

  private

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
end
