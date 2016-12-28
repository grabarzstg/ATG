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
  attr_accessor :source
  attr_accessor :target
  attr_accessor :cost

  def initialize(source, target, cost)
    @source = source
    @target = target
    @cost = cost
  end
  def to_s
    return "[#{@source}#{@target}]:#{@cost}"
  end
end

class Node
  attr_accessor :id
  attr_accessor :targets
  attr_accessor :temp
  attr_accessor :perm
  def initialize(id, targets = Array.new)
    @id = id
    @targets = targets
    @temp = false
    @perm = false
  end

  def add(target)
    @targets << target
  end
  def to_s
    targets = ""
    @targets.each {|e| targets += "->" + (e).to_s }
    return "#{@id}#{targets}"
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
    node.targets.each do |t|
      visit(graph[graph.find_index{|x| x.id == t}], graph, order)
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

def w(node1, node2)
  $arcs.each do |key, val|
    return val.cost if val.source == node1.id && val.target == node2.id
    return val.cost if val.source == node2.id && val.target == node1.id
  end
  return Float::INFINITY
end



#MAIN
$arcs = Hash.new("NIL")
$arcs["sa"] = Arc.new("s", "a", 1)
$arcs['sc'] = Arc.new("s", "c", 2)
$arcs["ca"] = Arc.new("c", "a", -4)
$arcs["ab"] = Arc.new("a", 'b', 6)
$arcs["cd"] = Arc.new("c", "d", 3)
$arcs["bd"] = Arc.new("b", "d", 1)
$arcs["be"] = Arc.new("b", "e", -2)
$arcs["de"] = Arc.new("d", "e", 1)
#$arcs["ee"] = Arc.new("e", "e", 0)

nodes = Array.new
nodes << Node.new("s", ["a", "c"])
nodes << Node.new("a", ["b"])
nodes << Node.new("c", ["a", "d"])
nodes << Node.new("b", ["d", "e"])
nodes << Node.new("d", ["e"])
nodes << Node.new("e", [])

topOrder = dfs(nodes)#.each {|x| putsd x.id}
dw = shortest(topOrder.clone)
topOrder.each {|x| putsd x.id}
puts dw.to_s

t = topOrder[-1].id
s = topOrder[0].id
minimal = dw["#{s}#{t}"]
puts "Dw(#{topOrder[0].id}#{topOrder[-1].id}): #{minimal}"
dw.each do |key, val|
  k = key.scan(/\w/)
  v = k[0].to_s
  u = k[1].to_s
  #tylko dla lukow!
  earliest = dw[s+v]
  wvu = w(topOrder[topOrder.index{|x| x.id == v}], topOrder[topOrder.index{|x| x.id == u}])
  latest = minimal - dw["#{u}#{t}"] - wvu
  puts "Arc(#{v}#{u}):\tearliest: #{earliest}\tlatest: #{latest}"
end
