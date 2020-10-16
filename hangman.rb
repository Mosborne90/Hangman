require_relative "console_methods"
require_relative "board_class"
include Console
include BoardClass


loop do
  $secret_word = Console.word_select
  $board = Board.new

  while $board.attempts > 0 do  
    $board.draw_board
    Console.check_letter(Console.get_letter)
    $board.check_win
  end
  Console.game_over
end