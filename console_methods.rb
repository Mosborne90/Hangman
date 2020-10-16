module Console

  def word_select
    dictionary = File.readlines("dictionary.txt").map(&:chomp)
    dictionary[rand(dictionary.length)].downcase
  end

  def get_letter
    print "\nGuess a letter: "
    response = gets.chomp.downcase

    if response.length > 1
      print "Invalid Entry! Enter a single letter from a-z"
      get_letter
    elsif !response.match?(/[a-z]/)
      print "Invalid Entry! Enter a single letter from a-z"
      get_letter
    end
    response
  end

  def check_letter(guess)
    arr = $secret_word.split("")

    if !arr.include?(guess) || $board.hint_bar.any?(" #{guess.upcase} ")
      $board.attempts -= 1
      $board.hang_man
    end

    arr.each_with_index do |c, i|
      if c == guess
        $board.hint_bar[i] = " #{c.upcase} "
      end
    end

  end
  
  def game_over
    $board.draw_board

    if $board.game_result == 'win'
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