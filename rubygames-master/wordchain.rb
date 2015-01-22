require 'set'

class WordChainer

  ALPHABET = ('a'..'z').to_a

  attr_reader :dictionary
  attr_accessor :visited_words

  def initialize
    @dictionary =  Set.new File.readlines('dictionary.txt').map(&:chomp)
    @smaller_dict = nil
    @visited_words = nil
  end

  def shrunk_dict(target)
    @smaller_dict.select! do |word|
      word.length == target.length && !self.visited_words.include?(word)
    end
  end

  def find_adj_words(word)
    adj_words = []
    shrunk_dict(word)
    word.split('').each_index do |idx|
      ALPHABET.each do |alpha|
        new_word = word.dup
        new_word[idx] = alpha
        adj_words << new_word if @smaller_dict.include?(new_word)
      end
    end
    adj_words
  end

  def validate_adj_words(word)
    adj_words = find_adj_words(word)
    self.visited_words += adj_words
    adj_words
  end

  def find_link(source,target)
    queue = [ChainerTreeNode.new(source)]
    self.visited_words = Set.new [source]
    @smaller_dict = self.dictionary.dup

    dots = 0
    until queue.empty?
      dots = (dots + 1) % 5
      display_loading(dots)

      node = queue.shift
      return node.trace_back_path if node.value == target

      validate_adj_words(node.value).each do |adj_word|
        new_node = ChainerTreeNode.new(adj_word)
        new_node.parent = node
        queue << new_node
      end
    end

    nil
  end

  def link(source,target)
    path = find_link(source,target)
    puts path.reverse.join("\n")
  end

  def display_loading(dots)
    system('clear')
    str = '. ' * dots
    puts "FINDING PATH " + str
  end

  def inspect
  end

end

class ChainerTreeNode

  attr_reader :value, :parent, :children

  def initialize(value)
    @value = value
    @parent = nil
    @children = Array.new
  end

  def parent=(parent)
    @parent = parent
    @parent.children << self
  end

  def bfs(target)
    queue = [self]

    until queue.empty?
      node = queue.shift
      return node if node.value == target
      node.children.each do |child|
        queue << child
      end
    end

    nil
  end

  def trace_back_path
    path = [self.value]
    return path if self.parent.nil?
    path += self.parent.trace_back_path
  end

end
