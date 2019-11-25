# frozen_string_literal: true

#This class provides us with a very general implementation of a graph. The vertices are the Nodes themselves, and edges are defined by the 'child' relationship. We can use this class to construct both directed and undirected graphs. We currently use a Boolean @terminator variable to arbitrarily decide which point in the graph constitutes an 'endpoint', as this is useful to know for several problem types.

class Node
  attr_accessor :value, :terminator, :location

  def initialize(value = nil)
    @value = value
    @children = {}
    @terminator = false
  end

  def clone(node=self, discovered=nil)
    raise "not a node" unless node.is_a?(Node)
    discovered ||= Hash.new { |h,k| h[k] = false }
#debugger
    new_node = Node.new(Marshal.load(Marshal.dump(node.value)))
    new_node.terminator = node.terminator
    new_node.location = node.location

    node.children.each { |child|
      unless discovered[child]
        child.clone(child, discovered)
        discovered[child] = true
      end
      new_node.connect(child)
    }

    return new_node
  end

  def connect(node)
    unless node.is_a?(Node) || node.is_a?(Array)
      raise TypeError.new("#{node} is not a node")
    end

    @children[node] = node
  end

  def children
    @children.keys
  end

  def [](node)
    raise TypeError, 'value is not a node' unless node.is_a?(Node)
    raise ArgumentError, "node not found" unless @children.has_key?(node)
    @children[node]
  end
end