require_relative 'game'
require_relative 'console_printer'
require_relative 'display'
require_relative 'player_input'
require 'yaml'

class Menu
  include ConsolePrinter
  include Display
  include PlayerInput

  def start
    game = Game.new
    game.board.setup_board
    game.start
  end

  def load_game
    game = Game.new
    game.load_game
  end

  def print_menu(title, options = %w[Start Load Exit])
    menu = []
    menu = getting_menu_logo
    menu[2] = menu[2][0..76] + title.center(17) + menu[2][94..]
    options.each_with_index do |option, index|
      menu[3 + index] = menu[3 + index][0..76] + (index + 1).to_s + option.center(17) + menu[3 + index][95..]
    end
    system('clear') or system('cls')
    print_message(menu, 100, 'bg_black', 'bg_gold', use_frame: true)
    print_input_field('bg_black')
  end

  def main
    print_menu('Main Menu', %w[Start Load Exit])
    chose = menu_input(%w[1 2 3])
    case chose
    when '1' then start
    when '2' then File.exist?('./assets/save_game.yml') ? load_game : start
    when '3' then exit
    end
  end
end
