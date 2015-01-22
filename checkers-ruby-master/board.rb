module Checkers

  SIZE = 10

  class Board

    def initialize(grid = fresh_grid)
      @grid = grid
    end

    def [](pos)
      y, x = pos
      @grid[y][x]
    end

    def []=(pos, spot)
      y, x = pos
      @grid[y][x] = spot
    end

    def pieces
      @grid.flatten.select { |tile| tile.is_a?(Piece) }
    end

    def pieces_of_color(color)
      pieces.select { |piece| piece.color == color}
    end

    def reset_all_animations
      pieces.each { |piece| piece.reset_animation}
    end

    def check_for_promotions
      pieces.each { |piece| piece.check_is_king}
    end

    def execute_jump(start_pos, end_pos)
      execute_slide(start_pos, end_pos)
      middle_pos = start_pos.middle_spot(end_pos)
      #--------- Animation Fluff
      self[middle_pos].dying
      puts render
      sleep(0.3)
      #---------
      self[middle_pos] = EmptySpace
    end

    def execute_slide(start_pos, end_pos)
      self[end_pos], self[start_pos] = self[start_pos], EmptySpace
      self[end_pos].pos = end_pos
    end

    def render
      system('clear')
      string = "    " + ('A'..'Z').to_a[0...SIZE].join("  ") +"\n"
      @grid.each_with_index do |row, r_index|
        string += "#{r_index+1}   "[0,3]
        j = -1
        string += row.map do |col|
          j += 1
          [r_index,j].inject(:+) % 2 == 1 ?
          " #{col} ".on_light_black : " #{col} ".on_light_white
        end.join + "\n"
      end
      string
    end

    def dup
      dup_board = Board.new(@grid.map.map(&:dup))
      dup_board.pieces.each { |piece| piece.board = dup_board}
    end

    def inspect
    end

    private

    def fresh_grid
      Array.new(SIZE) { Array.new(SIZE) {EmptySpace} }
    end

  end

end
