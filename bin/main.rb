require_relative '../lib/menu'

menu = Menu.new(mcp_mode: ARGV.include?('--mcp'))
menu.main
