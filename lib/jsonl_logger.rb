require 'json'
require 'time'

class JsonlLogger
  def initialize(filepath)
    @filepath = filepath
  end

  def log_move(turn_data)
    File.open(@filepath, 'a') do |file|
      file.puts(JSON.generate(turn_data.merge(timestamp: Time.now.utc.iso8601)))
    end
  end
end