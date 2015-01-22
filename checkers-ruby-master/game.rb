require "colorize"
require "yaml"
require_relative "board.rb"
require_relative "piece.rb"
require_relative "animation.rb"

module Checkers

  INITIAL_BOARD = [ # 0 == empty space
    [1,0,1,0,1,0,1,0,1,0],
    [0,1,0,1,0,1,0,1,0,1],
    [1,0,1,0,1,0,1,0,1,0],
    [0,1,0,1,0,1,0,1,0,1]
  ]

  COLORS = [:black, :red]

  class Game

    attr_reader :board

    def initialize(board = nil)
      @players = [HumanPlayer.new(COLORS.first), HumanPlayer.new(COLORS.last)]
      @turn = 0
      if board.nil?
        @board = Board.new
        fill_board
      else
        @board = board
      end
    end

    def run
      until game_over?
        current_player = @players[@turn % 2]
        start_pos, end_pos = current_player.get_action(@board)

        piece = @board[start_pos]
        piece.reset_animation
        puts @board.render
        pieces_actions = piece.get_actions

        if pieces_actions[:jumps].include?(end_pos)
          @board.execute_jump(piece.pos, end_pos)

          until piece.get_actions[:jumps].empty?
            puts @board.render
            sleep(0.3)

            chain_jump_pos = current_player.get_chain_jump(@board,piece)
            @board.execute_jump(piece.pos, chain_jump_pos)
          end

        elsif pieces_actions[:slides].include?(end_pos)
          @board.execute_slide(piece.pos, end_pos)
        end

        piece.reset_animation
        @board.check_for_promotions

        @turn += 1
      end
      puts "Game Over"
      if @board.pieces_of_color(@players.first.color).size == 0
        puts "#{@players.last.name} wins."
      elsif @board.pieces_of_color(@players.last.color).size == 0
        puts "#{@players.first.name} wins."
      else
        puts "Draw."
      end
    end

    def game_over?
      @board.pieces_of_color(@players.first.color).size == 0 ||
      @board.pieces_of_color(@players.last.color).size == 0 ||
      @board.pieces.size <= 2
    end

    private

    def fill_board
      offset = SIZE - INITIAL_BOARD.size
      INITIAL_BOARD.each_with_index do |row, i|
        row.each_with_index do |col, j|
          next if col == 0
          Piece.new(@board,[i,j],@players.first)
          Piece.new(@board,[i+offset,j],@players.last)
        end
      end
      nil
    end

  end


  class InvalidInputError < StandardError
  end


  class HumanPlayer

    attr_reader :color

    def initialize(color)
      @color = color
    end

    def name
      @color.to_s.capitalize
    end

    def base_prompt_user(input_code)
      string_arr = ["a location to move it",
                    "a piece" ]
      print "Please enter "
      print string_arr[0..(1 - input_code.size)].reverse.join(" and ")
      print ": "
    end

    CONVERSION = {
      'a' =>  0, 'b' =>  1, 'c' =>  2,
      'd' =>  3, 'e' =>  4, 'f' =>  5,
      'g' =>  6, 'h' =>  7, 'i' =>  8,
      'j' =>  9, 'k' => 10, 'l' => 11,
      'm' => 12, 'n' => 13, 'o' => 14,
      'p' => 15, 'q' => 16, 'r' => 17
    }

    def convert_to_yx(arr)
      begin
        arr.map do |coord|
          letter, number = coord[0], coord[1...coord.length]
          if CONVERSION.include?(letter) == false || number.to_i == 0
            raise InvalidInputError.new "Please use the numbers and letters on the board."
          end
          [Integer(number) - 1, CONVERSION[letter]]
        end
      rescue ArgumentError
        raise InvalidInputError.new "Please use the numbers and letters on the board."
      end
    end


    def get_action(board)
      begin
        input_code = []
        until input_code.size == 2
          puts board.render
          puts "#{name}'s Action:"

          base_prompt_user(input_code)
          user_input = gets.chomp.strip
          if user_input == "" && input_code.length == 1 &&
            !board[input_code.first].nil? &&
            board[input_code.first].moves.size == 1
            input_code += board[input_code.first].moves
          else
            input_code += convert_to_yx(user_input.downcase.split(' '))
          end

          next if input_code.size == 0

          if input_code.size > 2
            raise InvalidInputError.new "Too much input!"
          elsif board[input_code.first].nil?
            raise InvalidInputError.new "Thats an empty space you are trying to move."
          elsif board[input_code.first].color != @color
            raise InvalidInputError.new "Thats not your piece!"
          elsif input_code.size == 1
            board[input_code.first].selected
          elsif board[input_code.first].moves.include?(input_code[1]) == false
            raise InvalidInputError.new "That move is impossible."
          end

        end
      rescue InvalidInputError => e
        board.reset_all_animations
        puts board.render

        puts "Invalid Input: #{e.message}"
        sleep(2)
        retry
      end

      input_code
    end

    def get_chain_jump(board,piece)
      possible_jumps = piece.get_actions[:jumps]
      return possible_jumps.first if possible_jumps.size == 1
      begin
        puts "#{name} is chainjumping."
        print "-- There is a two jumps possible, choose a spot: "

        input = convert_to_yx([gets.chomp.downcase]).first
        if possible_jumps.include?(input)
          return input
        end
        raise InvalidInputError.new "Not an available jump."
      rescue InvalidInputError => e
        puts "Invalid Input: #{e.message}"
        sleep(0.1)
        retry
      end
    end

  end

end

if __FILE__ == $PROGRAM_NAME
  Checkers::Game.new.run
end
