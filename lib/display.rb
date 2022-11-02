require_relative 'colors'
require_relative 'console_printer'

module Display
  include ConsolePrinter

  def board_print(board, messages)
    left_panel = []

    # Board
    left_panel += getting_board(board)
    # getting the logo
    getting_logo.each.with_index do |line, index|
      left_panel[index] += line.bg_gold.bold if left_panel[index]
      left_panel[index] == left_panel[index] + (' ' * (line.length - 1)) unless left_panel[index]
    end

    # Adding messages
    messages.each_with_index do |message, index|
      next if message.nil?

      msg_to_add = message.to_s
      output = left_panel[(index * 2) + 15].gsub('                                          ', msg_to_add.center(42))
      left_panel[(index * 2) + 15] = output
    end

    # Print the board
    system 'clear' or system 'cls'
    print_message(left_panel, 89, 'bg_black', 'bg_cyan', use_frame: false)
    print_input_field('bg_black', '>')
  end

  def print_disponibles_moves(moves, board, messages)
    mapped_board = board.map.with_index do |row, index|
      row.map.with_index do |cell, index2|
        cell = getting_rotated_pieces(cell).bold.green.blink if cell != ' ' && moves.include?([index, index2])
        cell = 'X'.bold.green.blink if moves.include?([index, index2]) && cell == ' '
        cell
      end
    end
    board_print(mapped_board, messages)
  end

  def getting_board(board)
    output = []
    grid_white = '     '.bg_light_yellow
    grid_black = '     '.bg_dark_yellow
    line_odd = ('  '.bg_cyan + ((grid_white + grid_black) * 4) + '   '.bg_cyan)
    line_even = ('  '.bg_cyan + ((grid_black + grid_white) * 4) + '   '.bg_cyan)
    output << '    A    B    C    D    E    F    G    H     '.bg_cyan.bold
    output += board_mapping(board, line_odd, line_even)
    output << '    A    B    C    D    E    F    G    H     '.bg_cyan.bold
    output
  end

  def board_mapping(board, line_odd, line_even)
    output = []
    board.map.with_index do |row, index|
      inversed = 7 - index + 1
      line_to_use = inversed.odd? ? line_odd : line_even
      output << line_to_use
      inner_line = inner_line_mapping(row, inversed)
      pieces_line = "#{inversed.to_s.bold} ".bg_cyan + inner_line.join + " #{inversed.to_s.bold} ".bg_cyan
      output << pieces_line
      output << line_to_use
    end
    output
  end

  def inner_line_mapping(row, inversed)
    inner_line = []
    row.map.with_index do |cell, index2|
      are_odds = inversed.odd? && index2.odd?
      are_even = inversed.even? && index2.even?
      color = are_odds || are_even ? 'bg_dark_yellow' : 'bg_light_yellow'
      inner_line << '  '.send(color)
      inner_line << cell.send(color).bold
      inner_line << '  '.send(color)
    end
    inner_line
  end

  def getting_logo
    file = File.open('assets/logo.txt', 'r')
    file.readlines.map(&:chomp)
  end
end
