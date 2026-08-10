require 'fileutils'
require 'json'
require 'tmpdir'
require_relative '../lib/mcp_command_broker'

describe McpCommandBroker do
  let(:game_path) { Dir.mktmpdir('chess-mcp') }
  let(:log_path) { File.join(game_path, 'mcp_game.jsonl') }
  let(:broker) { described_class.new(game_path) }

  after { FileUtils.remove_entry(game_path) }

  def write_turn(player: 'white', fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR')
    File.write(log_path, JSON.generate(turn_number: 1, player: player, board_fen: fen, piece_unicode: '♙', from_algebraic: 'e2', to_algebraic: 'e4', captured: nil))
  end

  it 'renders available destinations after selecting a black piece' do
    write_turn

    response = broker.process('elegir e7')

    expect(response).to include('Seleccionada ♟ en e7', 'X', 'Destinos: e6, e5')
  end

  it 'writes a legal selected move for the live game to consume' do
    write_turn
    broker.process('elegir e7')

    response = broker.process('mover e5')

    expect(response).to include('Movimiento enviado: e7e5')
    expect(File.read(File.join(game_path, 'mcp_move.txt'))).to eq('e7e5')
  end

  it 'reports a friendly error for an opponent piece' do
    write_turn

    expect(broker.process('elegir e2')).to eq('La pieza en e2 no es negra.')
  end
end