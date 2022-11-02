# rubocop:disable Style/SingleLineMethods
# Extention to string class to add color to
class String
  colors = { 'default' => '38', 'black' => '30', 'red' => '31', 'green' => '32', 'brown' => '33', 'blue' => '34',
             'purple' => '35', 'cyan' => '36', 'gray' => '37', 'dark_gray' => '1;30', 'light_red' => '1;31',
             'light_green' => '1;32', 'yellow' => '1;33', 'light_blue' => '1;34', 'light_purple' => '1;35',
             'light_cyan' => '1;36', 'white' => '1;37' }
  bg_colors = { 'default' => '0', 'black' => '40', 'red' => '41', 'green' => '42', 'brown' => '43', 'blue' => '44',
                'purple' => '45', 'cyan' => '46', 'gray' => '47', 'dark_gray' => '100', 'light_red' => '101',
                'light_green' => '102', 'yellow' => '103', 'light_blue' => '104', 'light_purple' => '105',
                'light_cyan' => '106', 'white' => '107'}

  colors.each do |color, value|
    define_method(color) do
      "\e[#{value}m#{self}\e[0m"
    end
  end

  bg_colors.each do |color, value|
    define_method("bg_#{color}") do
      "\e[#{value}m#{self}\e[0m"
    end
  end

  def bg_dark_yellow
    bg_rgb(181, 170, 50)
  end

  def bg_light_yellow
    bg_rgb(195, 185, 70)
  end

  def bg_gold
    bg_rgb(89, 86, 35)
  end

  def bold; "\e[1m#{self}\e[22m" end
  def italic; "\e[3m#{self}\e[23m" end
  def underline; "\e[4m#{self}\e[24m" end
  def blink; "\e[5m#{self}\e[25m" end
  def reverse_color; "\e[7m#{self}\e[27m" end

  def no_colors; gsub(/\e\[\d+m/, '') end

  def color_rgb(red, green, blue); "\e[38;2;#{red};#{green};#{blue}m#{self}\e[0m" end
  def bg_rgb(red, green, blue); "\e[48;2;#{red};#{green};#{blue}m#{self}\e[0m" end
end
# rubocop:enable Style/SingleLineMethods
