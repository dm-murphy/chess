# frozen_string_literal: true

# Creates tree object or "board", holds Knight class node objects, finds shortest moves from start to finish
class Tree
  attr_accessor :start, :finish

  def knight_moves(start, finish)
    @start = Knight.new(start)
    @finish = finish
    @visited = [start]
    build_tree
  end

  def build_tree(queue = [@start])
    current = queue.last
    return depth(current) if current.coord == @finish

    current.possible_moves.each do |move|
      next if @visited.include?(move)

      knight_child = Knight.new(move)
      current.children.push(knight_child)
      knight_child.parent = current
      @visited.push(knight_child.coord)
      queue.unshift(knight_child)
    end

    queue.pop
    build_tree(queue)
  end

  def depth(node, counter = 0, array = [])
    array.unshift node.coord
    return display_result(counter, array) if node == @start

    depth(node.parent, counter + 1, array)
  end

  def display_result(counter, array)
    puts "Your knight took #{counter} moves following this path: "
    array.each { |coord| p coord }
  end
end