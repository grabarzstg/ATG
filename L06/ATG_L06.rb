#!/usr/local/ruby/bin/ruby
# encoding: utf-8
#RUBY_VERSION# 1.9.3

DEBUG = false

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
    edg = ""
    @edges.each {|e| edg += (e).to_s + " "}
    return "=====\nid: #{@id}\nvisited? #{@visited}\nedges:\n#{edg}\n====="
  end
end

def resetGraph (graph)
  graph.each_with_index do |el, i|
    graph[i].visited = false
  end
  return graph
end

def deleteVertex(graph, v)
  graph.each_with_index do |el|
    el.edges.delete_if{|e| e == v}  # edges removal
  end
  graph.delete_if {|el| el.id == v} # vertex removal
end

def dfs(graph)
  graph = resetGraph(graph)
  graph.each_with_index do |e, j|
    visit_node(j, graph) if !graph[j].visited?
  end
end

def visit_node(i, graph)
  putsd "VN: #{i}"
  graph.each do |el|
    if el.id == i
      el.visited = true
      el.edges.each do |j|
        graph.each do |elem|
          if elem.id == j
            visit_node(j, graph) if !elem.visited?
          end
        end
      end
      $tmp << el.id
    end
  end
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

def kosaraj(graph, stack)
  graph = resetGraph(graph)
  result = Array.new
  while stack.size > 0 do
    $tmp = Array.new
    visit_node(stack.pop, graph)
    result << $tmp
    $tmp.each do |i|
      putsd "\n\nUSUWAM #{i}\n\n"
      graph = deleteVertex(graph, i)
      #graph.each {|e| putsd e}
      stack.delete_if{|e| e == i}
      putsd "Stack: #{stack}"
    end
  end
  return result
end

# ===== MAIN =====
$tmp = Array.new
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

#transpose(d).each {|e| putsd e}
dfs(d)
#visit_node(2, d)
#visit_node(1, d)
#visit_node(0, d)

stack = $tmp
putsd "Stack: #{stack}"
d_prim = transpose(d)
components = kosaraj(d_prim, stack)

puts "=== RESULTS ===="
1.upto(components.length) do |i|
  puts "S#{i} => #{components[i-1]}"
end
