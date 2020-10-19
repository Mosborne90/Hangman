class Game
  attr_accessor :board, :hint_bar, :game_result, :attempts, :secret_word
  
  def initialize
    @board = [
      [" ", " ", " "],
      [" ", " ", " "],
      [" ", " ", " "]]
    @attempts = 6
    @secret_word = nil
    @hint_bar = nil
    @game_result = nil
  end
  
  def select_secret_word
    dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @secret_word = dictionary[rand(dictionary.length)].downcase
    @hint_bar = [" _ "] * @secret_word.length
  end

  def request_letter
    print "\nGuess a letter: "
    response = gets.chomp.downcase

    if response.length > 1
      print "Invalid Entry! Enter a single letter from a-z"
      request_letter
    elsif !response.match?(/[a-z]/)
      print "Invalid Entry! Enter a single letter from a-z"
      request_letter
    end
    response
  end

  def check_letter(guess)
    arr = @secret_word.split("")

    if !arr.include?(guess) || @hint_bar.any?(" #{guess.upcase} ")
      @attempts -= 1
      hang_man
    end

    arr.each_with_index do |c, i|
      if c == guess
        @hint_bar[i] = " #{c.upcase} "
      end
    end

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

  def game_over
    draw_board

    if @game_result == 'win'
      puts "\n\nYou did it! I owe you one!"
    else
      puts "\n\nYou failed! I'm a dead man!"
    end

    print "\nPress enter to play again or type 'exit': "
    response = gets.chomp
    if response == "exit"
      system "cls" || "clear"
      exit
    end
  end
end

loop do
  board = Game.new
  board.select_secret_word

  while board.attempts > 0 do  
    board.draw_board
    puts board.secret_word # Delete Later
    board.check_letter(board.request_letter)
    board.check_win
  end
  board.game_over
end