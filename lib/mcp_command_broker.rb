require 'json'
require_relative 'board'
require_relative 'logic'
require_relative 'pieces_moves'

class McpCommandBroker
  include Pieces
  include Logic
  include PiecesMoves

  def initialize(game_path)
    @game_path = game_path
    @command_path = File.join(game_path, 'mcp_command.txt')
    @response_path = File.join(game_path, 'mcp_response.txt')
    @move_path = File.join(game_path, 'mcp_move.txt')
    @log_path = File.join(game_path, 'mcp_game.jsonl')
    @selected = nil
  end

  def process(command)
    action, argument = command.to_s.strip.downcase.split(/\s+/, 2)
    board, turns = current_state
    return respond('No hay una partida MCP registrada todavia.') unless board

    case action
    when 'elegir' then choose(board, turns, argument)
    when 'mover' then move(board, turns, argument)
    when 'soltar' then drop
    when 'tablero' then respond(board_view(board, turns))
    when 'render' then respond(render(board, turns))
    else
      respond('Comando invalido. Usa: elegir <casilla>, mover <casilla>, soltar, tablero o render.')
    end
  end

  def process_file
    return false unless File.exist?(@command_path)

    command = File.read(@command_path)
    File.delete(@command_path)
    write_response(process(command))
    true
  end

  def daemon
    loop do
      process_file
      sleep 0.2
    end
  end

  private

  def choose(board, turns, notation)
    position = parse_square(notation)
    return respond('Casilla invalida. Usa una coordenada como e7.') unless position
    return respond('Aun no es el turno de Lyra (black).') unless black_to_move?(turns)

    piece = board[position]
    return respond("No hay pieza en #{notation}.") if piece == ' '
    return respond("La pieza en #{notation} no es negra.") unless black_pieces.include?(piece)

    moves = legal_moves(board, position)
    return respond("#{notation} no tiene movimientos legales.") if moves.empty?

    @selected = position
    respond("Seleccionada #{piece} en #{notation}.\n\n#{render(board, turns, moves)}\n\nDestinos: #{moves.map { |move| notation_for(move) }.join(', ')}")
  end

  def move(board, turns, notation)
    return respond('Primero usa elegir <casilla>.') unless @selected
    destination = parse_square(notation)
    return respond('Casilla invalida. Usa una coordenada como e5.') unless destination
    return respond('Aun no es el turno de Lyra (black).') unless black_to_move?(turns)

    moves = legal_moves(board, @selected)
    unless moves.include?(destination)
      return respond("Movimiento invalido: #{notation_for(@selected)} no puede ir a #{notation}.")
    end

    move_notation = "#{notation_for(@selected)}#{notation_for(destination)}"
    File.write(@move_path, move_notation)
    @selected = nil
    respond("Movimiento enviado: #{move_notation}. Esperando confirmacion del tablero.")
  end

  def drop
    return respond('No habia una pieza seleccionada.') unless @selected

    @selected = nil
    respond('Pieza soltada.')
  end

  def current_state
    return [nil, []] unless File.exist?(@log_path)

    turns = File.readlines(@log_path, chomp: true).filter_map do |line|
      JSON.parse(line) unless line.empty?
    rescue JSON::ParserError
      nil
    end
    return [nil, []] if turns.empty?

    board = Board.new(board_from_fen(turns.last.fetch('board_fen')))
    previous = turns.last
    board.history << history_entry(previous)
    [board, turns]
  end

  def board_from_fen(fen)
    fen.split('/').map do |rank|
      rank.each_char.flat_map do |character|
        character.match?(/\d/) ? Array.new(character.to_i, ' ') : [fen_piece(character)]
      end
    end
  end

  def fen_piece(character)
    {
      'K' => king_white, 'Q' => queen_white, 'R' => rook_white, 'B' => bishop_white, 'N' => knight_white, 'P' => pawn_white,
      'k' => king_black, 'q' => queen_black, 'r' => rook_black, 'b' => bishop_black, 'n' => knight_black, 'p' => pawn_black
    }.fetch(character)
  end

  def history_entry(turn)
    [turn['piece_unicode'], parse_square(turn['from_algebraic']), turn['captured'] || ' ', parse_square(turn['to_algebraic']), turn['captured'] || ' ']
  end

  def legal_moves(board, position)
    moves = piece_moves(board.grid, position, board.history.last) || []
    moves.select { |destination| check_move(position, destination, board, 'black') }
  end

  def black_to_move?(turns)
    turns.last['player'] == 'white'
  end

  def parse_square(notation)
    return unless notation&.match?(/\A[a-h][1-8]\z/)

    [8 - notation[1].to_i, notation[0].ord - 'a'.ord]
  end

  def notation_for(position)
    "#{(position[1] + 'a'.ord).chr}#{8 - position[0]}"
  end

  def render(board, turns, highlighted = [])
    lines = ['    a b c d e f g h']
    board.grid.each_with_index do |row, row_index|
      rank = 8 - row_index
      cells = row.each_with_index.map do |piece, column_index|
        highlighted.include?([row_index, column_index]) ? 'X' : (piece == ' ' ? '.' : piece)
      end
      lines << "#{rank} | #{cells.join(' ')} | #{rank}"
    end
    lines << '    a b c d e f g h'
    lines << "Turno: #{black_to_move?(turns) ? 'Lyra (black)' : 'Sly (white)'}"
    lines.join("\n")
  end

  def board_view(board, turns)
    recent = turns.last(8).map do |turn|
      "#{turn['turn_number']}. #{turn['player']}: #{turn['from_algebraic']}-#{turn['to_algebraic']}"
    end
    "#{render(board, turns)}\n\nUltimos movimientos:\n#{recent.join("\n")}"
  end

  def respond(message)
    message
  end

  def write_response(message)
    File.write(@response_path, "#{message}\n")
  end
end