# e:\code\reflections\salas\ajedrez\Chessgame_ruby\lib\apply_move.rb
require 'json'
require 'time'
require_relative 'board'
require_relative 'logic'
require_relative 'pieces_moves'
require_relative 'mcp_command_broker'
require_relative 'game'

game_path = ARGV[0] || File.expand_path('../..', __dir__)
from_notation = ARGV[1]&.downcase
to_notation = ARGV[2]&.downcase

if from_notation.nil? || to_notation.nil?
  puts JSON.generate({ error: "Missing coordinates" })
  exit 1
end

broker = McpCommandBroker.new(game_path)
board, turns = broker.send(:current_state)

if board.nil? || turns.empty?
  board = Board.new
  board.setup_board
  player = 'white'
  turn_count = 0
  turns = []
else
  player = broker.send(:black_to_move?, turns) ? 'black' : 'white'
  turn_count = turns.length
end

from_pos = broker.send(:parse_square, from_notation)
to_pos = broker.send(:parse_square, to_notation)

if from_pos.nil? || to_pos.nil?
  puts JSON.generate({ error: "Invalid coordinate format" })
  exit 1
end

piece = board[from_pos]
white_pieces = broker.send(:white_pieces)
black_pieces = broker.send(:black_pieces)
own_pieces = (player == 'white') ? white_pieces : black_pieces

unless own_pieces.include?(piece)
  puts JSON.generate({ error: "Piece at #{from_notation} does not belong to #{player}" })
  exit 1
end

legal = broker.send(:legal_moves, board, from_pos)
unless legal.include?(to_pos)
  puts JSON.generate({ error: "Move #{from_notation} to #{to_notation} is illegal" })
  exit 1
end

# Ejecutar el movimiento y actualizar estado
game = Game.new(mcp_mode: false)
game.board = board
game.turn = player
game.turn_count = turn_count

destiny_piece = board[to_pos]
captured_piece = destiny_piece == ' ' ? nil : destiny_piece

game.start_move(from_pos, to_pos)

# Registrar en mcp_game.jsonl
log_path = File.join(game_path, 'mcp_game.jsonl')
turn_record = {
  turn_number: turn_count + 1,
  player: player,
  piece_unicode: piece,
  from_algebraic: from_notation,
  to_algebraic: to_notation,
  captured: captured_piece,
  board_fen: game.board.to_fen,
  in_check: broker.send(:check?, game.board.grid, game.turn),
  timestamp: Time.now.utc.iso8601
}

File.open(log_path, 'a') do |f|
  f.puts(JSON.generate(turn_record))
end

puts JSON.generate(turn_record)
