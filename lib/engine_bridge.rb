# e:\code\reflections\salas\ajedrez\Chessgame_ruby\lib\engine_bridge.rb
require 'json'
require_relative 'board'
require_relative 'logic'
require_relative 'pieces_moves'
require_relative 'mcp_command_broker'

game_path = ARGV[0] || File.expand_path('../..', __dir__)
broker = McpCommandBroker.new(game_path)
board, turns = broker.send(:current_state)

if board.nil? || turns.empty?
  # Partida inicial
  board = Board.new
  board.setup_board
  player = 'white'
  turn_count = 0
else
  player = broker.send(:black_to_move?, turns) ? 'black' : 'white'
  turn_count = turns.length
end

white_pieces = broker.send(:white_pieces)
black_pieces = broker.send(:black_pieces)
target_pieces = (player == 'white') ? white_pieces : black_pieces

legal_moves = []
board.grid.each_with_index do |row, r|
  row.each_with_index do |piece, c|
    if target_pieces.include?(piece)
      from_pos = [r, c]
      from_not = broker.send(:notation_for, from_pos)
      moves = broker.send(:legal_moves, board, from_pos)
      moves.each do |dst|
        to_not = broker.send(:notation_for, dst)
        legal_moves << {
          from: from_not,
          to: to_not,
          move: "#{from_not}#{to_not}",
          piece: piece,
          captured: board[dst] == ' ' ? nil : board[dst]
        }
      end
    end
  end
end

in_check = broker.send(:check?, board.grid, player)

puts JSON.generate({
  player: player,
  turn_count: turn_count,
  fen: board.to_fen,
  in_check: in_check,
  legal_moves: legal_moves
})
