require 'yaml'

class Game
  attr_accessor :board, :attempts, :secret_word, :hint_bar, :game_result
  def initialize(board, attempts, secret_word, hint_bar, game_result)
    @board = board
    @attempts = attempts
    @secret_word = secret_word
    @hint_bar = hint_bar
    @game_result = game_result
  end

  def to_yaml
    YAML.dump ({
      :board => @board,
      :attempts => @attempts,
      :secret_word => @secret_word,
      :hint_bar => @hint_bar,
      :game_result => @game_result
    })
  end

  def self.from_yaml(string)
    data = YAML.load(string)
    self.new(data[:board], data[:attempts], data[:secret_word], data[:hint_bar], data[:game_result])
  end

  def select_secret_word
    dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @secret_word = dictionary[rand(dictionary.length)].downcase
    @hint_bar = [" _ "] * @secret_word.length
  end

  def request_letter
    print "\nGuess a letter or type 'save' to save the game: "
    response = gets.chomp.downcase

    if response == 'save'
      File.open("save_file.yaml", "w") {|file| file.write(self.to_yaml)}
      puts "The game has been saved!"
      request_letter
    elsif response.length > 1
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

def load_game_check
  system "cls" || "clear"
  puts "**Thanks for playing Hangman**"
  print "\nWould you like to load the previous save file?(y/n): "

  response = gets.chomp.downcase

  if !['yes', 'y', 'no', 'n'].include?(response)
    load_game_check
  end

  save_file = File.read("save_file.yaml")

  if save_file.length > 1 && response.match?(/y/)
    board = Game.from_yaml(save_file)
  else
    board = Game.new([[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]], 6, nil, nil, nil)
    board.select_secret_word
  end
  board
end

loop do
  board = load_game_check

  while board.attempts > 0 do  
    board.draw_board
    board.check_letter(board.request_letter)
    board.check_win
  end
  board.game_over
end