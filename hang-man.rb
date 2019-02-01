# initialize
# display rules
# generate word
# draw board
# accept user input
# validate user input [a-z].upcase
# check for matches
# score input
# record and display incorect entries
# track turns
# game end?

require "./colorize.rb"


def initialize_variables
  $incorrect_guesses = 0
  $wrong_letters = []
  read_file
  $hidden_word = ""
  generate_word
  $win = false
  $user_letters = ""
  $hidden_letters = []
end

def read_file
  $word_list = File.readlines "word_list.txt"
end

def generate_word
  while !$hidden_word.length.to_i.between?(5,12)
    $hidden_word = $word_list[rand(1..$word_list.length)].chomp("\n")
  end

  $answer = $hidden_word.split(//)
  # print $answer
  # print $answer.join
end

def draw_hangman(wrong_inputs)
  hangman = case wrong_inputs
  when 0
  '
            +---+
                |
                |
                |
                |
                |
          =========
  '
  when 1
  '
            +---+
            |   |
                |
                |
                |
                |
          =========
  '
  when 2
  '
            +---+
            |   |
            O   |
                |
                |
                |
          =========
  '
  when 3
  '
            +---+
            |   |
            O   |
            |   |
                |
                |
          =========
  '.yellow
  when 4
  '
            +---+
            |   |
            O   |
           /|   |
                |
                |
          =========
  '.yellow
  when 5
  '
            +---+
            |   |
            O   |
           /|\  |
                |
                |
          =========
  '.yellow
  when 6
  '
            +---+
            |   |
            O   |
           /|\  |
           /    |
                |
          =========
  '.red
  else
  '
            +---+
            |   |
            O   |
           /|\  |
           / \  |
                |
          =========
  GAME OVER!!! YOU HAVE BEEN HANGED'.red
  end
  puts hangman
end

def welcome_message
  puts "\nWELCOME TO HANGMAN \n\n".cyan
  puts "The object of the game is to guess letters to a "+"hidden word".cyan
  puts "The " + "hidden word".cyan + " is represented by a series of dashes indiacting it's length."
  puts "If you guess a letter correctly then that letter is filled out in all locations of the " + "hidden word".cyan + "\n\n"
  puts "eg. Lets say that the " + "hidden word".cyan + " is:\n\n"
  puts " _ _ _ _ _ _"
  puts "\nand you guess the letter:"+"   a".cyan
  puts "then parts of the word are revealed if the guess was " + "correct".green + "."
  puts "If the word was 'banana' then the result of the guess would be:\n\n"
  puts "_ a _ a _ a"
  puts "\nIf the guess was " + "wrong".red + ", then your incorrect guess is recorded and you get closer to being hanged.\n\n"
  puts "The game is over when you guess all the correct letters to the hidden word or when u run out of guesses and are hanged.\n\n"

  puts "You are allowed a total of 7 incorect guesses."
  puts "GOOD LUCK!".cyan
end

def display_hidden_letters
  length = $answer.length
  print "Hidden word:  ".cyan
  (length).times do
    $hidden_letters << "_ "
  end
  print $hidden_letters.join
  puts ""

end

def user_input
  puts "\nWhat letter do you guess?\n"
  invalid_input = true

  while invalid_input
    $user_guess = gets.chomp
    length = $user_guess.length
    $user_guess = $user_guess.upcase.split(//).first
    if $wrong_letters.include? $user_guess
      invalid_input = true
      puts "You have already guessed that.".yellow
      puts "\nWhat letter do you guess?\n"
    elsif $user_guess =~ /^[A-Z]$/
      if length > 1
        puts "Your input was longer than expected.".yellow
        puts "Only #{$user_guess} was accepted.".yellow
        invalid_input = false
      else
        invalid_input = false
      end
    else
      invalid_input = true
      puts "Please enter a single letter.".yellow
      puts "\nWhat letter do you guess?\n"
    end
  end
  $user_guess
end


def anaylise_guess
  $locations = $answer.each_index.select{|i| $answer[i] == $user_guess.downcase}

  if $locations.empty?
    $wrong_letters.push($user_guess)
    $incorrect_guesses += 1
    draw_hangman($incorrect_guesses)
    display_hidden_word
    puts "You tried: #{$wrong_letters}".red
  else
    draw_hangman($incorrect_guesses)
    reveal_letters
    if !$wrong_letters.empty?
      puts "You tried: #{$wrong_letters}".red
    end
  end

end


def display_hidden_word
  print "Hidden word:  ".cyan
  print $hidden_letters.join
  puts "\n\n"
end


def reveal_letters
  $locations.each do |value|
   $hidden_letters[value] = $user_guess + " "
  end
  display_hidden_word
end

def win
  if $hidden_letters.join.gsub(/\s+/, "") == $answer.join.upcase
    $win = true
    puts "Congratulations you won!".green
    puts ""
    exit
  end
end

def start_game
  initialize_variables
  welcome_message
  draw_hangman(0)
  display_hidden_letters
  while $incorrect_guesses < 7 && !$win
    user_input
    anaylise_guess
    win
  end
  puts "You lose!"
  puts "The word was : #{$answer.join.upcase}".red
  puts ""
end

print "loading..."
sleep(0.3)
print "..."
sleep(0.3)
print "..."
start_game
