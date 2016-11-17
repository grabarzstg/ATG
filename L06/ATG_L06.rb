#!/usr/local/ruby/bin/ruby
# encoding: utf-8
#RUBY_VERSION# 1.9.3

DEBUG = true

def putsd(string)
  puts string.to_s if DEBUG
end

class Vertex
  attr_accessor :id
  attr_accessor :edges
  attr_accessor :visited
  @edges = Array.new
  def initialize(id, visited, edges = Array.new)
    @id = id
    @edges =  edges.sort
    @visited = visited
  end

  def visited?
    return @visited
  end

  def addEdge(vertex)
    @edges << vertex
    @edges.sort!
  end

  def to_s
    return "=====\nid: #{@id+1}\nvisited? #{@visited}\nedges:\n#{@edges}\n====="
  end
end

def dfs(graph)
  graph.each_with_index do |el, i|
    graph[i].visited = false
  end
  graph.each_with_index do |e, j|
    visit_node(j, graph) if !graph[j].visited?
  end
end

def visit_node(i, graph)
  graph[i].visited = true
  graph[i].edges.each do |j|
    visit_node(j, graph) if !graph[j].visited?
  end
  putsd graph[i].id+1
end

def transpose(graph)
  t = Array.new
  0.upto(graph.length-1) do |j|
    t << Vertex.new(j, false)
  end
  graph.each_with_index do |el, i|
    el.edges.each do |e|
      t[e].addEdge(i)
    end
  end
  return t
end
# ===== MAIN =====
d = Array.new


d << Vertex.new(0, false, [1,2,3])
d << Vertex.new(1, false)
d << Vertex.new(2, false, [4])
d << Vertex.new(3, false)
d << Vertex.new(4, false, [5])
d << Vertex.new(5, false, [6,2,7])
d << Vertex.new(6, false, [2])
d << Vertex.new(7, false, [8])
d << Vertex.new(8, false, [7])
putsd transpose(d)
#dfs(d)

#symulacja zgodnie z
#visit_node(2, d)
#visit_node(1, d)
#visit_node(0, d)
