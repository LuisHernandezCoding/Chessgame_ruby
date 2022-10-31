require_relative 'pieces'
require_relative 'pieces_moves'
require_relative 'board'
require_relative 'logic'

class Game
  include Pieces
  include PiecesMoves
  include Logic

  attr_accessor :board, :turn, :turn_count, :history

  def initialize
    @board = Board.new
    @turn = 'white'
    @turn_count = 0
    @history = []
  end

  def start
    create_board
    loop do
      break if king_on_checkmate?(@board.grid, @turn)

      pick = ask_for_pick
      moves = piece_moves(@board.grid, pick)
      show_disponibles_moves(moves)
      print_disponibles_moves(moves)
      destiny = ask_for_destiny(moves)
      do_move(pick, destiny) if check_move(pick, destiny)
    end
  end

  def king_on_checkmate?(grid, turn)
    checkmate?(grid, turn) if check?(grid, turn)
  end

  def ask_for_pick
    debug_print(@board.grid)
    puts "#{@turn}'s turn"
    pick_piece
  end

  def pick_piece
    puts 'Enter the coordinates of the piece you want to select'
    puts 'For example: A2'
    print '> '
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
    if piece_moves(@board.grid, start_pos).include?(destiny_pos)
      start_piece = @board.grid[start_pos[0]][start_pos[1]]
      destiny_piece = @board.grid[destiny_pos[0]][destiny_pos[1]]
      eated_piece = destiny_piece == ' ' ? ' ' : destiny_piece
      @board.remove_piece(destiny_pos) if eated_piece != ' '
      @board.move_piece(start_pos, destiny_pos)
      @turn_count += 1
      @history << [start_piece, start_pos, destiny_piece, destiny_pos, eated_piece]
      next_turn
    else
      puts 'Invalid move'
    end
  end

  def getting_user_input
    input = gets.chomp.upcase
    input = gets.chomp.upcase until input.length == 2 && input[0].between?('A', 'H') && input[1].between?('1', '8')
    row = input[0].ord - 65
    column = input[1].to_i - 1
    [row, column]
  end

  def debug_print(board)
    system 'clear' or system 'cls'
    puts '    1     2     3     4     5     6     7     8  '
    puts '  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁ '
    board.map.with_index do |row, index|
      letter = ('A'..'H').to_a[index]
      puts ' ▕     ▕     ▕     ▕     ▕     ▕     ▕     ▕     ▕'
      puts "#{letter}▕  #{row.join('  ▕  ')}  ▕ #{letter}"
      puts ' ▕▁▁▁▁▁▕▁▁▁▁▁▕▁▁▁▁▁▕▁▁▁▁▁▕▁▁▁▁▁▕▁▁▁▁▁▕▁▁▁▁▁▕▁▁▁▁▁▕' unless index == 7
    end
    puts ' ▕▁▁▁▁▁▕▁▁▁▁▁▕▁▁▁▁▁▕▁▁▁▁▁▕▁▁▁▁▁▕▁▁▁▁▁▕▁▁▁▁▁▕▁▁▁▁▁▕'
    puts '    1     2     3     4     5     6     7     8  '
  end

  def next_turn
    @turn = @turn == 'white' ? 'black' : 'white'
  end

  def create_board
    @board = Board.new
    @board.grid[0] = [rook_black, knight_black, bishop_black, queen_black,
                      king_black, bishop_black, knight_black, rook_black]
    @board.grid[1] = [pawn_black, pawn_black, pawn_black, pawn_black,
                      pawn_black, pawn_black, pawn_black, pawn_black]
    @board.grid[6] = [pawn_white, pawn_white, pawn_white, pawn_white,
                      pawn_white, pawn_white, pawn_white, pawn_white]
    @board.grid[7] = [rook_white, knight_white, bishop_white, queen_white,
                      king_white, bishop_white, knight_white, rook_white]
  end
end
