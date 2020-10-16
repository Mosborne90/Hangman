module BoardClass
  class Board

    attr_accessor :board, :hint_bar, :game_result, :attempts
    def initialize
      @board = [
        [" ", " ", " "],
        [" ", " ", " "],
        [" ", " ", " "]]
      @hint_bar = [" _ "] * $secret_word.length
      @attempts = 6
      @game_result = nil
    end
    
    def draw_board
      system "cls" || "clear"
      puts "**Thanks for playing Hangman**"
      puts "\nA man's life is at stake!"

      puts "\n----------"
      puts "    |    "
      space = " " * 3
      puts space + @board[0].join
      puts space + @board[1].join
      puts space + @board[2].join

      print "\n#{@hint_bar.join}"
    end

    def check_win
      if @hint_bar.none?(" _ ")
        @attempts = 0
        @game_result = 'win'
      end
    end

    def hang_man
      
      case @attempts
      when 5
        @board[0][1] = "O"
      when 4
        @board[1][1] = "|"
      when 3
        @board[1][0] = "/"
      when 2
        @board[1][2] = "\\"
      when 1
        @board[2][0] = "/"
      when 0
        @board[2][2] = "\\ "
      end
      
    end
  end

end