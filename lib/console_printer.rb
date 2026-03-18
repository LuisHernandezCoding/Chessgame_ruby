module ConsolePrinter
  def print_message(messages, full_size, bg_color = 'bg_blue', inner_bg = 'bg_cyan', use_frame: false)
    frame = getting_frame('╳', use_frame, full_size, inner_bg)
    symbol = getting_symbol('╳', use_frame, inner_bg)
    margin = '    '
    puts margin + (' ' * (full_size + 8)).send(bg_color)
    puts margin + '  '.send(bg_color) + frame + '  '.send(bg_color)
    messages.each do |message|
      string = message.to_s.center(full_size - 26).bold.send(inner_bg)
      puts margin + '  '.send(bg_color) + symbol + string + symbol + '  '.send(bg_color)
    end
    puts margin + '  '.send(bg_color) + frame + '  '.send(bg_color)
    puts margin + ('_' * (full_size + 8)).send(bg_color)
  end

  def print_input_field(bg_color = 'bg_blue', symbol = '>')
    margin = '    '
    print margin + margin.send(bg_color) + (symbol * 2).send(bg_color)
  end

  private

  def getting_frame(symbol, use_frame, full_size, color = 'bg_black')
    if use_frame
      (symbol * (full_size + 4)).send(color)
    else
      (' ' * (full_size + 4)).send(color)
    end
  end

  def getting_symbol(symbol, use_frame, color = 'bg_black')
    if use_frame
      (symbol * 2).send(color)
    else
      '  '.send(color)
    end
  end
end
