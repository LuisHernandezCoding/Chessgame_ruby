module FilesManager
  def getting_board_header(screen)
    file = File.open('assets/logo.txt', 'r')
    file.readlines.map(&:chomp).each.with_index do |line, index|
      screen[index] += line.bg_gold.bold if screen[index]
      screen[index] == screen[index] + (' ' * (line.length - 1)) unless screen[index]
    end
    screen
  end

  def getting_history(screen, history)
    file = File.open('assets/history.txt', 'r')
    file.readlines.map(&:chomp).each.with_index do |line, index|
      screen[index] += line.bg_gold.bold if screen[index]
      screen[index] == screen[index] + (' ' * (line.length - 1)) unless screen[index]
    end
    history = history[-24..] if history.length > 24
    history.each_with_index do |move, index|
      string = "#{move[0]}#{transpose_notation(move[1])}-#{transpose_notation(move[3])}#{move[4]}"
      screen[index + 2] = screen[index + 2].gsub('▏         ▕', "▏#{string.center(9)}▕")
    end
    screen
  end

  def getting_menu_logo
    file = File.open('assets/menu.txt', 'r')
    file.readlines.map(&:chomp).map { |line| line.center(100) }
  end
end
