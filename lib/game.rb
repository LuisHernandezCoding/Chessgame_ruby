require_relative 'pieces'
require_relative 'pieces_moves'
require_relative 'board'
require_relative 'logic'
require_relative 'display'
require_relative 'player_input'

class Game
  include Pieces
  include PiecesMoves
  include Logic
  include Display
  include PlayerInput

  attr_accessor :board, :turn, :turn_count, :messages, :game_over

  def initialize
    @board = Board.new
    @turn = 'white'
    @turn_count = 0
    @messages = []
    @game_over = false
    @check = ' '
  end

  def start
    loop do
      break if checkmate?(@board.grid, @turn) && check?(board.grid, @turn)

      @check = check?(@board.grid, @turn) ? "WARNING: #{@turn} king is in check!".red.bold.bg_gold.blink : ' '
      pick = pick_piece
      pick = pick_piece until piece_moves(@board.grid, pick, @board.history.last) != []
      moves = piece_moves(@board.grid, pick, @board.history.last)
      show_disponibles_moves(moves)
      destiny = ask_for_destiny(moves)
      next unless moves.include?(destiny)

      do_move(pick, destiny) if check_move(pick, destiny)
    end
    @messages = [@check, 'CONGRATULATIONS!', "Checkmate, #{@turn} wins"]
    board_print(@board.grid, @messages, @board.history)
    @game_over = true
  end

  def save_game
    save = { 'board' => @board, 'turn' => @turn, 'turn_count' => @turn_count, 'messages' => @messages,
             'game_over' => @game_over, 'check' => @check }
    File.write('./assets/save_game.yml', save.to_yaml)
    @messages = [@check, 'Game saved', 'Exiting the game']
    board_print(@board.grid, @messages, @board.history)
    puts
    exit
  end

  def load_game
    save = YAML.unsafe_load(File.read('./assets/save_game.yml'))
    @board = save['board']
    @turn = save['turn']
    @turn_count = save['turn_count']
    @messages = save['messages']
    @game_over = save['game_over']
    @check = save['check']
    @messages = [@check, 'Game loaded', 'Press any key to continue']
    board_print(@board.grid, @messages, @board.history)
    gets.chomp
    start
  end

  def pick_piece
    @messages = [@check, "#{@turn}'s turn".upcase, 'Enter the coordinates of the piece']
    @messages[3] = 'Enter "save" to save the game' if @turn_count.positive?
    board_print(@board.grid, @messages, @board.history)
    own_pieces = @turn == 'white' ? white_pieces : black_pieces
    input = getting_user_chose(true)
    save_game if input == 'SAVE'
    until @board.grid[input[0]][input[1]] != ' ' && own_pieces.include?(@board.grid[input[0]][input[1]])
      input = getting_user_chose
    end
    [input[0], input[1]]
  end

  def show_disponibles_moves(moves)
    notation = []
    moves.map do |move|
      notation << transpose_notation(move)
    end
    @messages = [@check, @messages[1], 'Enter the coordinates of the destiny']
    if notation.length <= 4
      @messages[3] = "Possible moves: #{notation.join(', ')}"
    else
      @messages[3] = "Possible moves: #{notation[0..(notation.length / 2) - 1].join(', ')}"
      @messages[4] = "and: #{notation[(notation.length / 2)..].join(', ')}"
    end
    print_disponibles_moves(moves, @board, @messages, @board.history)
  end

  def ask_for_destiny(moves)
    destiny = getting_user_chose
    until moves.include?(destiny)
      destiny = getting_user_chose
      @messages[2] = 'Invalid move, try again'
    end
    destiny
  end

  def check_move(start_pos, destiny_pos)
    possible_moves = piece_moves(@board.grid, start_pos, @board.history.last)
    return false unless possible_moves.include?(destiny_pos)

    simulated_board = @board.grid.map(&:clone)
    start_piece = @board.grid[start_pos[0]][start_pos[1]]
    simulated_board[destiny_pos[0]][destiny_pos[1]] = start_piece
    simulated_board[start_pos[0]][start_pos[1]] = ' '
    return false if check?(simulated_board, @turn)

    true
  end

  def do_move(start_pos, destiny_pos)
    start_piece = @board.grid[start_pos[0]][start_pos[1]]
    destiny_piece = @board.grid[destiny_pos[0]][destiny_pos[1]]
    make_the_move(start_pos, destiny_pos, start_piece, destiny_piece)
    if (destiny_pos[0].zero? && start_piece == pawn_white) || (destiny_pos[0] == 7 && start_piece == pawn_black)
      check_for_promotion
    end
    board_print(@board.grid, @messages, @board.history)
  end

  def make_the_move(start_pos, destiny_pos, start_piece, destiny_piece)
    @board.remove_piece(destiny_pos) if destiny_piece != ' '
    do_castling(destiny_pos) if start_piece == king_white || start_piece == king_black
    eated_piece = if start_piece == pawn_white || start_piece == pawn_black
                    do_en_passant(start_pos, destiny_pos, destiny_piece)
                  else
                    destiny_piece
                  end
    @board.move_piece(start_pos, destiny_pos)
    @board.history << [start_piece, start_pos, destiny_piece, destiny_pos, eated_piece]
    next_turn
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

  def do_en_passant(start_pos, destiny_pos, destiny_piece)
    start_piece = @board.grid[start_pos[0]][start_pos[1]]
    return destiny_piece unless start_piece == pawn_white || start_piece == pawn_black
    return destiny_piece if destiny_pos[1] == start_pos[1]
    return destiny_piece unless en_passant?(start_pos, destiny_pos, @board.grid, @turn)

    eated_piece = @board.grid[start_pos[0]][destiny_pos[1]]
    @board.remove_piece([start_pos[0], destiny_pos[1]])
    eated_piece
  end

  def en_passant?(start_pos, destiny_pos, grid, turn)
    line = turn == 'white' ? 4 : 3

    return false unless start_pos[0] == line || grid[destiny_pos[0]][destiny_pos[1]] == ' '
    return false if grid[start_pos[0]][destiny_pos[1]] == ' '
    return false unless destiny_pos[0] == line + 2 || destiny_pos[0] == line - 2

    true
  end

  def check_for_promotion
    @messages = [@check, 'Select the piece you want to promote to', '(Q)ueen, (R)ook, (B)ishop']
    @messages[4] = '(K)night or stay (P)awn'
    board_print(@board.grid, @messages, @board.history)
    chose = getting_input(%w[Q R B K P], @board.grid, @messages, @board.history)
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
    @messages = [' ', ' ', ' ', ' ', ' ']
    board_print(@board.grid, @messages, @board.history)
  end

  def next_turn
    @turn_count += 1
    @turn = @turn == 'white' ? 'black' : 'white'
  end
end
