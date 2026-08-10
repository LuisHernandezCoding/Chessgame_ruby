require 'json'
require 'stringio'
require 'tempfile'
require_relative '../lib/board'
require_relative '../lib/jsonl_logger'
require_relative '../lib/jsonl_input_reader'
require_relative '../lib/game'

describe 'MCP mode support' do
  it 'serializes the initial board as FEN' do
    board = Board.new
    board.setup_board

    expect(board.to_fen).to eq('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR')
  end

  it 'appends a move record with an ISO-8601 timestamp' do
    file = Tempfile.new('mcp_game')
    logger = JsonlLogger.new(file.path)

    logger.log_move(turn_number: 1, player: 'white', board_fen: '8/8/8/8/8/8/8/8')

    record = JSON.parse(File.read(file.path))
    expect(record).to include('turn_number' => 1, 'player' => 'white', 'board_fen' => '8/8/8/8/8/8/8/8')
    expect(record['timestamp']).to match(/\A\d{4}-\d{2}-\d{2}T/)
  ensure
    file.close!
  end

  it 'splits Lyra move-file notation into source and destination coordinates' do
    log_file = Tempfile.new('mcp_game')
    move_file = Tempfile.new('mcp_move')
    log_file.write(JSON.generate(player: 'white'))
    log_file.flush
    move_file.write('e7e5')
    move_file.close

    reader = JsonlInputReader.new(log_file.path, move_file.path)

    expect(reader.gets).to eq("e7\n")
    expect(reader.gets).to eq("e5\n")
    expect(File).not_to exist(move_file.path)
  ensure
    log_file.close!
  end

  it 'uses terminal input for White and MCP input for Black' do
    game = Game.new(mcp_mode: true)
    terminal_input = StringIO.new("e2\n")
    mcp_input = StringIO.new("e7\n")
    game.mcp_input_source = mcp_input
    allow($stdin).to receive(:gets).and_return(terminal_input.gets)

    expect(game.send(:read_input)).to eq("e2\n")
    game.turn = 'black'
    expect(game.send(:read_input)).to eq("e7\n")
  end
end