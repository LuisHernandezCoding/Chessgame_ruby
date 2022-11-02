require_relative 'colors'
require_relative 'console_printer'

module Display
  include ConsolePrinter

  def debug_print(board, messages)
    left_panel = []
    grid_white = '     '.bg_light_yellow
    grid_black = '     '.bg_dark_yellow
    line_odd = ('  '.bg_cyan + ((grid_white + grid_black) * 4) + '   '.bg_cyan)
    line_even = ('  '.bg_cyan + ((grid_black + grid_white) * 4) + '   '.bg_cyan)
    left_panel << '    A    B    C    D    E    F    G    H     '.bg_cyan.bold
    board.map.with_index do |row, index|
      inversed_index = 7 - index + 1
      line_to_use = inversed_index.odd? ? line_odd : line_even
      left_panel << line_to_use
      inner_line = []
      row.map.with_index do |cell, index2|
        square_color = (inversed_index.odd? && index2.odd?) || (inversed_index.even? && index2.even?) ? 'bg_dark_yellow' : 'bg_light_yellow'
        inner_line << '  '.send(square_color)
        inner_line << cell.send(square_color).bold
        inner_line << '  '.send(square_color)
      end
      pieces_line = "#{inversed_index.to_s.bold} ".bg_cyan + inner_line.join + " #{inversed_index.to_s.bold} ".bg_cyan
      left_panel << pieces_line
      left_panel << line_to_use
    end


    left_panel << '    A    B    C    D    E    F    G    H     '.bg_cyan.bold
    getting_logo.each.with_index do |line, index|
      left_panel[index] += line.bg_gold.bold if left_panel[index]
      left_panel[index] == left_panel[index] + (' ' * (line.length - 1)) unless left_panel[index]
    end
    messages.each_with_index do |message, index|
      next if message.nil?

      msg_to_add = message.to_s
      output = left_panel[(index * 2) + 15].gsub('                                          ', msg_to_add.center(42))
      left_panel[(index * 2) + 15] = output
    end
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
    debug_print(mapped_board, messages)
  end

  def getting_logo
    file = File.open('assets/logo.txt', 'r')
    file.readlines.map(&:chomp)
  end
end
