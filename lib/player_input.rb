require_relative 'display'

module PlayerInput
  include Display

  def getting_input(valid_inputs, board, messages, history)
    input = gets.chomp.upcase
    return input if valid_inputs.include?(input)

    messages[1] = 'Invalid input, try again'
    board_print(board, messages, history)
    getting_input(valid_inputs, board, messages, history)
  end

  def getting_user_chose(can_save = false)
    input = gets.chomp.upcase
    return input if input == 'SAVE' && can_save

    input = gets.chomp.upcase until input.length == 2 && input[0].between?('A', 'H') && input[1].between?('1', '8')
    transpose_input(input)
  end

  def menu_input(options = %w[1 2 3 4])
    chose = gets.chomp.downcase
    chose = gets.chomp.downcase until chose.match(/[#{options.join}]/)
    chose
  end

  def transpose_input(input)
    row = 8 - input[1].to_i
    column = input[0].ord - 65
    [row, column]
  end

  def transpose_notation(move)
    letter = (move[1] + 65).chr
    number = 8 - move[0]
    "#{letter}#{number}"
  end
end
