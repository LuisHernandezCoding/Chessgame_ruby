require_relative 'pieces'
require_relative 'moves/pawn_moves'
require_relative 'moves/rook_moves'
require_relative 'moves/bishop_moves'
require_relative 'moves/knight_moves'
require_relative 'moves/king_moves'

module PiecesMoves
  extend Pieces
  include PawnMoves
  include RookMoves
  include BishopMoves
  include KnightMoves
  include KingMoves

  def pawn_moves(board, from, color, last_move = nil)
    return [] if from[0].zero? && color == 'white'
    return [] if from[0] == 7 && color == 'black'

    pos_x, pos_y = from
    possible_moves = []
    possible_moves += pawn_helper(board, pos_x, pos_y, color, last_move)
    possible_moves
  end

  def rook_moves(board, from, color)
    pos_x, pos_y = from
    possible_moves = []
    possible_moves += rook_helper(board, pos_x, pos_y, color)
    possible_moves
  end

  def bishop_moves(board, from, color)
    pos_x, pos_y = from
    possible_moves = []
    possible_moves += bishop_helper(board, pos_x, pos_y, color)
    possible_moves
  end

  def knight_moves(board, from, color)
    pos_x, pos_y = from
    possible_moves = []
    possible_moves += knight_helper(board, pos_x, pos_y, color)
    possible_moves
  end

  def queen_moves(board, from, color)
    pos_x, pos_y = from
    possible_moves = []
    possible_moves += rook_helper(board, pos_x, pos_y, color)
    possible_moves += bishop_helper(board, pos_x, pos_y, color)
    possible_moves
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

  private

  def castling_rook_helper(color, destiny_pos)
    actual_line = color == 'white' ? 7 : 0
    case destiny_pos[1]
    when 6 then [actual_line, 5]
    when 5 then [actual_line, 6]
    when 2 then [actual_line, 3]
    when 1 then [actual_line, 2]
    end
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

  def check_move(start_pos, destiny_pos, board, turn)
    possible_moves = piece_moves(board.grid, start_pos, board.history.last)
    return false unless possible_moves.include?(destiny_pos)

    simulated_board = board.grid.map(&:clone)
    start_piece = board.grid[start_pos[0]][start_pos[1]]
    simulated_board[destiny_pos[0]][destiny_pos[1]] = start_piece
    simulated_board[start_pos[0]][start_pos[1]] = ' '
    return false if check?(simulated_board, turn)

    true
  end

  def inside_board?(move)
    return true if move[0].between?(0, 7) && move[1].between?(0, 7)
  end
end
