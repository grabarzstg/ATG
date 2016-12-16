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

def shortest(order, dw = Hash.new(Float::INFINITY))
  source = order[0]
  dw["#{source.id}#{source.id}"] = 0
  if order.length > 2
    dw["#{source.id}#{order[1].id}"] = w(source, order[1])
    2.upto(order.length-1) do |i|
      puts dw
      #puts "dw[#{source.id}#{order[i].id}] = [dw[#{source.id}#{order[i-1].id}] + w(#{order[i-1].id}, #{order[i].id}) , dw[#{source.id}#{order[i-2].id}] + w(#{order[i-2].id}, #{order[i].id})].min"
      #TODO: dodac opcje dla wiecej nizeli 2 sciezek wchodzacych do wezla
      dw["#{source.id}#{order[i].id}"] = [dw["#{source.id}#{order[i-1].id}"] + w(order[i-1], order[i]), dw["#{source.id}#{order[i-2].id}"] + w(order[i-2], order[i])].min
    end
  end
  newOrder = order
  newOrder.delete_at(0)
  shortest(newOrder, dw) if newOrder.length > 1 #spodziewane 21 elementow
  return dw #dw["#{source.id}#{order[-1].id}"]
end

def longest(order)
  newOrder = invertCosts(order)
  return shortest(newOrder)["#{order[0].id}#{order[-1].id}"]*(-1)
end

def w(node1, node2)
  node1.arcs.each do |a|
    return a.cost if a.target == node2.id
  end
  node2.arcs.each do |a|
    return a.cost if a.target == node1.id
  end
  return Float::INFINITY
end

def invertCosts(order)
  newOrder = order
  newOrder.each do |node|
    node.arcs.each do |arc|
      arc.cost = arc.cost*(-1)
    end
  end
  return newOrder
end


# ===== MAIN =====
digraph = Array.new
digraph << Node.new('s', [Arc.new('a', 1), Arc.new('c', 2)])
digraph << Node.new('a', [Arc.new('b', 6)])
digraph << Node.new('c', [Arc.new('a', -4), Arc.new('d', 3)])
digraph << Node.new('b', [Arc.new('d', 1), Arc.new('e', -2)])
digraph << Node.new('d', [Arc.new('e', 1)])
digraph << Node.new('e')

topOrder = dfs(digraph).each {|x| putsd x.id}
dw = shortest(topOrder)
#minimalny czas realizacji calego przedsiewziecia rowny jest Dw(s, t);
minimal = dw["#{topOrder[0].id}#{topOrder[-1].id}"]
puts "Dw(s, t): #{minimal}"
dw.each do |key, val|
  puts "Arc(#{key}):\n\tearliest: #{val}"
  #puts "\tlatest: #{minimal - dw["#{}#{}"] - val }"
end
puts dw

longest(topOrder)
