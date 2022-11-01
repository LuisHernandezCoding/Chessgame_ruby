require_relative 'pieces'
require_relative 'pieces_moves'
require_relative 'board'
require_relative 'logic'

class Game
  include Pieces
  include PiecesMoves
  include Logic

  attr_accessor :board, :turn, :turn_count

  def initialize
    @board = Board.new
    @turn = 'white'
    @turn_count = 0
  end

  def start
    @board.setup_board
    loop do
      break if king_on_checkmate?(@board.grid, @turn)

      pick = pick_piece
      pick = pick_piece until piece_moves(@board.grid, pick) != []
      moves = piece_moves(@board.grid, pick, @board.history.last)
      show_disponibles_moves(moves)
      print_disponibles_moves(moves)
      destiny = ask_for_destiny(moves)
      do_move(pick, destiny) if check_move(pick, destiny)
    end
  end

  def king_on_checkmate?(grid, turn)
    checkmate?(grid, turn) if check?(grid, turn)
  end

  def pick_piece
    debug_print(@board.grid)
    print "#{@turn}'s turn > "
    own_pieces = @turn == 'white' ? white_pieces : black_pieces
    input = getting_user_input
    until @board.grid[input[0]][input[1]] != ' ' && own_pieces.include?(@board.grid[input[0]][input[1]])
      input = getting_user_input
    end
    [input[0], input[1]]
  end

  def print_disponibles_moves(moves)
    mapped_board = @board.grid.map.with_index do |row, index|
      row.map.with_index do |cell, index2|
        cell = getting_rotated_pieces(cell) if cell != ' ' && moves.include?([index, index2])
        cell = 'X' if moves.include?([index, index2]) && cell == ' '
        cell
      end
    end
    debug_print(mapped_board)
  end

  def show_disponibles_moves(moves)
    notation = moves.map do |move|
      letter = ('A'..'H').to_a[move[0]]
      number = move[1] + 1
      "#{letter}#{number}"
    end
    puts notation.join(', ')
  end

  def ask_for_destiny(moves)
    puts 'Enter the coordinates of the destiny'
    puts "possible moves: #{moves}"
    print '> '
    destiny = getting_user_input
    destiny = getting_user_input until moves.include?(destiny)
    destiny
  end

  def check_move(start_pos, destiny_pos)
    possible_moves = piece_moves(@board.grid, start_pos)
    return false unless possible_moves.include?(destiny_pos)

    simulated_board = @board.grid.map(&:clone)
    start_piece = @board.grid[start_pos[0]][start_pos[1]]
    simulated_board[destiny_pos[0]][destiny_pos[1]] = start_piece
    simulated_board[start_pos[0]][start_pos[1]] = ' '
    return false if check?(simulated_board, @turn)

    true
  end

  def do_move(start_pos, destiny_pos)
    return unless piece_moves(@board.grid, start_pos, @board.history.last).include?(destiny_pos)

    # Assigning variables
    start_piece = @board.grid[start_pos[0]][start_pos[1]]
    destiny_piece = @board.grid[destiny_pos[0]][destiny_pos[1]]
    eated_piece = destiny_piece == ' ' ? ' ' : destiny_piece

    # Moving the piece
    @board.remove_piece(destiny_pos) if eated_piece != ' '
    do_special_moves(start_pos, destiny_pos, start_piece)
    @board.move_piece(start_pos, destiny_pos)

    # Updating the history
    @board.history << [start_piece, start_pos, destiny_piece, destiny_pos, eated_piece]

    # Advancing logic
    next_turn
    check_for_promotion
  end

  def do_special_moves(start_pos, destiny_pos, start_piece)
    do_castling(destiny_pos) if start_piece == king_white || start_piece == king_black
    do_en_passant(start_pos, destiny_pos) if start_piece == pawn_white || start_piece == pawn_black
  end

  def do_castling(destiny_pos)
    get_castling_moves = castling_helper(@board.grid, @turn)
    return if get_castling_moves.empty?

    line = @turn == 'white' ? 7 : 0
    rook_pos_y = destiny_pos[1] == 6 ? 7 : 0
    rook_destiny = castling_rook_helper(@turn, destiny_pos)
    @board.grid[line][rook_destiny[1]] = @board.grid[line][rook_pos_y]
    @board.grid[line][rook_pos_y] = ' '
  end

  def do_en_passant(start_pos, destiny_pos)
    # return unles its a pawn
    start_piece = @board.grid[start_pos[0]][start_pos[1]]
    return unless start_piece == pawn_white || start_piece == pawn_black
    return unless en_passant?(start_pos, destiny_pos, @board.grid, @turn)

    @board.remove_piece([start_pos[0], destiny_pos[1]])
  end

  def en_passant?(start_pos, destiny_pos, grid, turn)
    line = turn == 'white' ? 4 : 3

    return false unless start_pos[0] == line || grid[destiny_pos[0]][destiny_pos[1]] == ' '
    return false if grid[start_pos[0]][destiny_pos[1]] == ' '
    return false unless destiny_pos[0] == line + 2 || destiny_pos[0] == line - 2

    true
  end

  def check_for_promotion(chose = @turn == 'black' ? queen_white : queen_black)
    p "Promotion to #{@turn} choose: (Q)ueen, (R)ook, (B)ishop, (K)night or stay (P)awn"
    chose = gets.chomp.upcase until %w[Q R B K P].include?(chose)
    do_promotion(@turn == 'black' ? convert_chose_white(chose) : convert_chose_black(chose))
  end

  def convert_chose_white(chose)
    case chose
    when 'Q' then queen_white
    when 'R' then rook_white
    when 'B' then bishop_white
    when 'K' then knight_white
    when 'P' then pawn_white
    end
  end

  def convert_chose_black(chose)
    case chose
    when 'Q' then queen_black
    when 'R' then rook_black
    when 'B' then bishop_black
    when 'K' then knight_black
    when 'P' then pawn_black
    end
  end

  def do_promotion(chose)
    @board.grid.each_with_index do |row, index|
      row.each_with_index do |cell, index2|
        @board.grid[index][index2] = chose if (cell == pawn_white && index.zero?) || (cell == pawn_black && index == 7)
      end
    end
  end

  def getting_user_input
    input = gets.chomp.upcase
    input = gets.chomp.upcase until input.length == 2 && input[0].between?('A', 'H') && input[1].between?('1', '8')
    row = 8 - input[1].to_i
    column = input[0].ord - 65
    [row, column]
  end

  def next_turn
    @turn_count += 1
    @turn = @turn == 'white' ? 'black' : 'white'
  end
end
