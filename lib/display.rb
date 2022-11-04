require_relative 'colors'
require_relative 'console_printer'
require_relative 'files_manager'

module Display
  include ConsolePrinter
  include FilesManager

  def board_print(board, messages, history)
    screen = []
    screen += getting_board(board)
    screen = getting_board_header(screen)
    screen = getting_messages(screen, messages)
    screen = getting_history(screen, history)
    system 'clear' or system 'cls'
    print_message(screen, 100, 'bg_black', 'bg_cyan', use_frame: false)
    print_input_field('bg_black', '>')
  end

  def show_disponibles_moves(moves, board, messages, history)
    notation = []
    moves.map do |move|
      notation << transpose_notation(move)
    end
    messages = [messages[0], messages[1], 'Enter the coordinates of the destiny']
    if notation.length <= 4
      messages[3] = "Possible moves: #{notation.join(', ')}"
    else
      messages[3] = "Possible moves: #{notation[0..(notation.length / 2) - 1].join(', ')}"
      messages[4] = "and: #{notation[(notation.length / 2)..].join(', ')}"
    end
    print_disponibles_moves(moves, board, messages, history)
  end

  def print_disponibles_moves(moves, board, messages, history)
    mapped_board = board.grid.map.with_index do |row, index|
      row.map.with_index do |cell, index2|
        cell = getting_rotated_pieces(cell).bold.green.blink if cell != ' ' && moves.include?([index, index2])
        cell = 'X'.bold.green.blink if moves.include?([index, index2]) && cell == ' '
        cell
      end
    end
    board_print(mapped_board, messages, history)
  end

  def getting_board(board)
    output = []
    grid_white = '     '.bg_gold
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
      bg_color = are_odds || are_even ? 'bg_dark_yellow' : 'bg_gold'
      inner_line << '  '.send(bg_color)
      inner_line << cell.send(bg_color).bold
      inner_line << '  '.send(bg_color)
    end
    inner_line
  end

  def getting_messages(screen, messages)
    messages.each_with_index do |message, index|
      next if message.nil?

      msg_to_add = message.to_s.center(42)
      msg_to_add = '     '.bg_gold + message + '     '.bg_gold if index.zero? && message[0] != ' '
      output = screen[(index * 2) + 15].gsub('                                          ', msg_to_add)
      screen[(index * 2) + 15] = output
    end
    screen
  end
end
