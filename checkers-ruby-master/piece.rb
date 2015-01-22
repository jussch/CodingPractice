module Checkers

  class Piece

    SIDE_DELTAS = [[0,1],[0,-1]]

    attr_reader :color, :king, :player
    attr_writer :board
    attr_accessor :pos

    def initialize(board, pos, player)
      @board, @player = board, player
      @king = false
      @color = @player.color
      @animation = Animation.new(@color, self)
      place_piece(pos)
    end

    def to_s
      @animation.render
    end

    def is_king?
      @king
    end

    def check_is_king
      if @color == COLORS.last
        king_row = 0
      else
        king_row = SIZE - 1
      end
      if pos[0] == king_row
        @king = true
      end
    end

    def place_piece(pos)
      @board[pos] = self
      @pos = pos
    end

    def moves
      actions = get_actions
      actions[:jumps] + actions[:slides]
    end

    def off_board?(move)
      move.all? { |el| el.between?(0,SIZE - 1) } == false
    end

    def get_actions
      jumps = []
      slides = []
      move_directions.each do |dir|
        next_pos = @pos.add_delta(dir)
        next if off_board?(next_pos)

        if @board[next_pos].nil?
          slides << next_pos

        elsif @board[next_pos].color != @color
          next_pos = next_pos.add_delta(dir)
          if (!off_board?(next_pos)) && @board[next_pos].nil?
            jumps << next_pos
          end
        end

      end
      {jumps: jumps, slides: slides}
    end

    def selected
      @animation.blink
    end

    def reset_animation
      @animation.reset
    end

    def dying
      @animation.dying
    end

    def move_directions
      forward = @color == COLORS.last ? [-1,0] : [1,0]
      dir = []
      SIDE_DELTAS.each do |delta|
        dir << delta.add_delta(forward)
        dir << delta.remove_delta(forward) if is_king?
      end
      dir
    end

  end


  class EmptySpace < NilClass

    def self.color
      nil
    end

    def self.player
      nil
    end

    def self.nil?
      true
    end

    def self.to_s
      " "
    end

    def self.pos
      [0,0]
    end

  end

end


class Array

  def add_delta(delta)
    arr = Array.new(delta.size)
    delta.size.times { |i| arr[i] = self[i] + delta[i] }
    arr
  end

  def remove_delta(delta)
    arr = Array.new(delta.size)
    delta.size.times { |i| arr[i] = self[i] - delta[i] }
    arr
  end

  def div_delta(delta)
    arr = Array.new(delta.size)
    delta.size.times { |i| arr[i] = self[i] / delta[i] }
    arr
  end

  def multiply_delta(delta)
    arr = Array.new(delta.size)
    delta.size.times { |i| arr[i] = self[i] * delta[i] }
    arr
  end

  def middle_spot(end_pos)
    delta = end_pos.remove_delta(self)
    delta.div_delta(Array.new(self.size,2)).add_delta(self)
  end

end
