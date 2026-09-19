# e:\code\reflections\salas\ajedrez\Chessgame_ruby\lib\legal_moves_probe.rb
require_relative 'mcp_command_broker'

game_path = File.expand_path('../..', __dir__)
broker = McpCommandBroker.new(game_path)
board, turns = broker.send(:current_state)

unless board
  puts "No game"
  exit 0
end

black_pieces = broker.send(:black_pieces)
white_pieces = broker.send(:white_pieces)
player = broker.send(:black_to_move?, turns) ? 'black' : 'white'
target_pieces = (player == 'black') ? black_pieces : white_pieces

legal_moves = []
board.grid.each_with_index do |row, r|
  row.each_with_index do |p, c|
    if target_pieces.include?(p)
      from_pos = [r, c]
      from_not = broker.send(:notation_for, from_pos)
      moves = broker.send(:legal_moves, board, from_pos)
      moves.each do |dst|
        to_not = broker.send(:notation_for, dst)
        legal_moves << {
          from: from_not,
          to: to_not,
          move: "#{from_not}#{to_not}",
          piece: p,
          captured: board[dst] == ' ' ? nil : board[dst]
        }
      end
    end
  end
end

puts JSON.generate({
  player: player,
  turn_count: turns.length,
  fen: board.to_fen,
  legal_moves: legal_moves
})
