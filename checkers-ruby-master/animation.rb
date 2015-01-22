module Checkers

  class Animation

    def initialize(color, piece)
      @state = :normal
      @piece = piece
      @color = color
    end

    def render
      if @piece.is_king?
        base = @state != :dying ? "◈" : "◇"
      else
        base = @state != :dying ? "◉" : "◎"
      end
      base = base.colorize(:color => @color)
      case @state
      when :normal
        return base
      when :selected
        return base.blink
      when :dying
        return base
      end
    end

    def reset
      @state = :normal
    end

    def blink
      @state = :selected
    end

    def dying
      @state = :dying
    end

  end

end
