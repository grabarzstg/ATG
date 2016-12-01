#!/usr/local/ruby/bin/ruby
# encoding: utf-8
#RUBY_VERSION# 1.9.3

DEBUG = true
def putsd(string)
  puts string.to_s if DEBUG
end

class NotDagException < StandardError
  def initialize(msg="Not DAG ")
    super
  end
end

class Arc
  attr_accessor :target
  attr_accessor :cost

  def initialize(target, cost)
    @target = target
    @cost = cost
  end
  def to_s
    return "\ntarget: #{target}\ncost:#{@cost}"
  end
end

class Node
  attr_accessor :id
  attr_accessor :arcs
  attr_accessor :temp
  attr_accessor :perm
  def initialize(id, arcs = Array.new)
    @id = id
    @arcs = arcs
    @temp = false
    @perm = false
  end

  def add(arc)
    @arcs << arc
  end
  def to_s
    arc = ""
    @arcs.each {|e| arc += (e).to_s + " "}
    return "=====\nid: #{@id}\narcs:\n#{arc}\n====="
  end
end

def dfs (graph)
  order = Array.new
  graph.each do |node|
    visit(node, graph, order) if !order.include?(node)
  end
  return order
end

def visit (node, graph, order)
  raise NotDagException if node.temp
  if !node.perm
    node.temp = true
    node.arcs.each do |arc|
      visit(graph[graph.find_index{|x| x.id == arc.target}], graph, order)
    end
    node.perm = true
    node.temp = false
    order.unshift(node)
  end
end

def shortest(order)
  distances = Array.new
  distances << 0
  (order.length-1).times {distances << Float::INFINITY}
  puts distances

  1.upto(order.length) do |i|
    #TODO: distances[i] = min()
  end

end

# ===== MAIN =====
digraph = Array.new
digraph << Node.new('s', [Arc.new('a', 1), Arc.new('c', 2)])
digraph << Node.new('a', [Arc.new('b', 6)])
digraph << Node.new('c', [Arc.new('a', -4), Arc.new('d', 3)])
digraph << Node.new('b', [Arc.new('d', 1), Arc.new('e', -2)])
digraph << Node.new('d', [Arc.new('e', 1)])
digraph << Node.new('e')

topOrder = dfs(digraph).each {|x| puts x.to_s}
shortest(topOrder)
