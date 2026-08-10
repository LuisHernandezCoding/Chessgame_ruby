require 'json'

class JsonlInputReader
  def initialize(log_path, move_path)
    @log_path = log_path
    @move_path = move_path
    @coordinates = []
  end

  def gets
    return "#{@coordinates.shift}\n" unless @coordinates.empty?

    wait_for_black_move
    "#{@coordinates.shift}\n"
  end

  private

  def wait_for_black_move
    loop do
      move = File.read(@move_path).strip.downcase if File.exist?(@move_path)
      if black_to_move? && move&.match?(/\A[a-h][1-8][a-h][1-8]\z/)
        @coordinates = [move[0, 2], move[2, 2]]
        File.delete(@move_path)
        return
      end

      sleep 0.25
    end
  end

  def black_to_move?
    return true unless File.exist?(@log_path)

    last_turn = File.readlines(@log_path, chomp: true).last
    return true if last_turn.nil? || last_turn.empty?

    JSON.parse(last_turn)['player'] == 'white'
  rescue JSON::ParserError
    false
  end
end