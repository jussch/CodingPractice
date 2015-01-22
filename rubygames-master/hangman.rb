module Hangman

  def self.new_game
    puts "Picker: H or C?"
    picker_txt = gets.chomp.downcase
    picker = HumanPlayer.new if picker_txt == "h"
    picker ||= ComputerPlayer.new
    puts "Guesser: H or C?"
    guesser_txt = gets.chomp.downcase
    guesser = HumanPlayer.new if guesser_txt == "h"
    guesser ||= ComputerPlayer.new
    game = Game.new(picker,guesser)
    game.run
  end


  class Game

    MAX_CHANCES = 6

    attr_reader :picker, :guesser, :word_length, :board, :used_letters

    def initialize(picker = ComputerPlayer.new, guesser = ComputerPlayer.new)
      @picker = picker
      @guesser = guesser
      @word_length = @picker.get_word_length
      @used_letters = Array.new
      @board = Array.new(@word_length)
      @chances = MAX_CHANCES
    end

    def over?
       guesser_loses? || picker_loses?
    end

    def picker_loses?
      !@board.include?(nil)
    end

    def guesser_loses?
      @chances <= 0
    end

    def run
      self.guesser.update_used_letters(self.used_letters)
      until over?
        display_board
        sleep(1)
        letter = self.guesser.get_guess(self.board)
        response = self.picker.get_response(letter)
        if response.nil?
          @chances -= 1
          puts "WRONG! [#{letter}] does not exist in the secret word."
          puts "Guesser has lost one chance!"
        else
          response.each { |pos| self.board[pos] = letter}
          plural = response.length == 1 ? "" : "'s"
          puts "Yes! There is #{response.length} [#{letter}]#{plural} in this word!"
        end
        self.used_letters << letter
        sleep(1)
      end
      display_board
      if guesser_loses?
        puts "The Guesser Loses!"
      elsif picker_loses?
        puts "The Picker Loses!"
      else
        raise "There is no winner."
      end
    end

    def display_board
      system('CLEAR')
      puts render_man

      puts "Secret Word: #{render_board}"
      position_str = ""
      word_length.times { |i| position_str += i.to_s + " "}
      puts "Position:    #{position_str}\n"
      puts "Letter Graveyard: #{used_letters.join(" ")}"

      chance_string = "X " * MAX_CHANCES
      MAX_CHANCES.times { |i| chance_string[i*2] = "-" if i >= @chances}
      puts "#{chance_string}chances left."
    end

    def render_board
      string = ""
      self.board.each do |slot|
        string += slot.nil? ? "_ " : "#{slot.upcase} "
      end
      string
    end

    MAN = ["----+  ",
           "    |  ",
           "    |  ",
           "    O  ",
           "  --|--",
           "    |  ",
           "   / \\ "]

    def render_man
      MAN.map.with_index do |string,index|
        if index <= (MAX_CHANCES-@chances)
          "|" + string
        else
          "|"
        end
      end.join("\n")
    end

    def inspect
      # -- Rewrite for Ease
    end

  end # end Game


  class HumanPlayer

    attr_reader :used_letters

    def initialize
      @used_letters = []
    end

    def update_used_letters(used_letters)
      @used_letters = used_letters
    end

    def get_guess(board)
      loop do
        print "\nGuesser: Guess a letter: "
        guess = gets.chomp[0].downcase
        return guess unless self.used_letters.include?(guess)
        puts "Invalid Guess, letter already used."
      end
    end

    def get_word_length
      puts "Picker: Think of a word, how long is it?"
      Integer(gets.chomp)
    end

    def get_response(letter)
      puts "Picker: Enter the positions of the #{letter}, else return empty."
      response = gets.chomp
      return nil if response == ""
      response.split(' ').map(&:to_i)
    end

  end # end HumanPlayer


  class ComputerPlayer


    attr_reader :dictionary, :used_letters, :secret_word

    def initialize
      @dictionary = File.readlines('dictionary.txt').map(&:chomp)
      @used_letters = Array.new
      @secret_word = @dictionary.sample
    end

    def update_used_letters(used_letters)
      @used_letters = used_letters
    end

    # - - - - - - - -
    # GUESSER METHODS

    def thin_dict_by_length(dict,board)
      dict.select! { |word| word.length == board.length }
    end

    def thin_dict_by_letters(dict,board)
      board.each_with_index do |b_ltr,b_idx|
        dict.delete_if do |word|
          if b_ltr == word[b_idx]
            false
          elsif b_ltr.nil? && self.used_letters.include?(word[b_idx])
            true
          elsif b_ltr != word[b_idx] && !b_ltr.nil?
            true
          else
            false
          end
        end
      end
    end

    def thin_dict(board)
      new_dict = self.dictionary.dup
      thin_dict_by_length(new_dict,board)
      thin_dict_by_letters(new_dict,board)
      new_dict
    end

    def count_letters(dict)
      letters = Hash.new(0)
      dict.each do |word|
        word.split('').each do |ltr|
          letters[ltr] += 1 unless self.used_letters.include?(ltr)
        end
      end
      letters
    end

    def get_guess(board)
      new_dict = thin_dict(board)
      count_letters(new_dict).max_by {|k,v| v}.first
    end

    # - - - - - - - -
    # PICKER METHODS

    def get_word_length
      self.secret_word.length
    end

    def get_response(letter)
      reponse = nil
      if self.secret_word.include?(letter)
        response = []
        self.secret_word.split('').each_with_index do |s_ltr,s_idx|
          response << s_idx if s_ltr == letter
        end
      end
      response
    end

  end # end ComputerPlayer


end

if $PROGRAM_NAME == __FILE__
  Hangman.new_game
end
