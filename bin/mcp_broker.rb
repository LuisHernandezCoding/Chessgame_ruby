require_relative '../lib/mcp_command_broker'

game_path = File.expand_path('../..', __dir__)
broker = McpCommandBroker.new(game_path)

if ARGV.include?('--once')
  broker.process_file
else
  broker.daemon
end