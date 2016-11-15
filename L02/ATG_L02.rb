#!/usr/local/ruby/bin/ruby
# encoding: utf-8
#RUBY_VERSION# 1.9.3

require 'matrix'

DEBUG = true

class Matrix
  def []=(row, column, value)
    @rows[row][column] = value
  end
end

def putsd(string)
  puts string.to_s if DEBUG
end

# zarzadzanie wierzcholkami
def addVertex(matrix)
  row = Array.new
  (1..matrix.row_size).each do
    row << 0
  end
  col = Array.new
  (0..matrix.column_size).each do
    col << 0
  end
  matrix = Matrix.rows(matrix.transpose.to_a << row)
  matrix = Matrix.columns(matrix.transpose.to_a << col)
  matrix.normal? #sprawdzenie czy macierz jest poprawnego rozmiaru
  return matrix
end

def remVertex(matrix, index)
  arr = matrix.transpose.to_a
  arr.each do |row|
    row.delete_at index
  end
  arr.delete_at index
  matrix = Matrix.rows(arr)
  matrix.normal? #sprawdzenie czy macierz jest poprawnego rozmiaru
  return matrix
end

# zarzadzanie krawedziami
def addEdge(matrix, row, col)
  raise IndexError if row > matrix.row_size || row < 0 || col > matrix.row_size || col < 0
  matrix.[]=(row-1, col-1, 1)
  matrix.[]=(col-1, row-1, 1)
  return matrix
end

def remEdge(matrix, row, col)
  matrix.[]=(row, col, 0)
  matrix.[]=(col, row, 0)
  return matrix
end

def nextIndex(matrix)
  return matrix.row_size + 1
end

def printMatrix(matrix)
  # TODO: stworzyc ladne rysowanie grafu w konsoli
  matrix.to_a.each do |row|
    puts row.to_s
  end
end

# L02
# Zaimplementuj procedure, ktora dla danego grafu prostego G = (V, E) (w postaci macierzy sąsiedztwa) o minimalnym stopniu δ(G)≥2 zwróci jakikolwiek cykl w G o długości przynajmniej δ(G) + 1.
def getCycle(graph, cycle = Array.new, i = 0)
  cycle << i
  #return cycle if graph.to_a[i].nil?
  graph.to_a[i].each_with_index do |elem, index|
    if elem == 1
      putsd "i: #{i} | index: #{index}"
      graph = remEdge(graph, i, index)
      getCycle(graph, cycle, index)
      break
    end 
  end
  return cycle
end

# prosta implementacja
def jordan(graph)
  ranks = getRanks(graph)
  puts ranks.to_s
  ranks.each_with_index  do |rank, index|
    graph = remVertex(graph, index) if rank == 1
    puts index if rank == 1
  end
  ranks = getRanks(graph)
  puts ranks.to_s
  #jordan(graph) if graph.to_a.size > 2
end

def getRanks(graph)
  ranks = Array.new
  graph.to_a.each do |row|
    rank = 0
    row.each do |i|
      rank += i
    end
    ranks << rank
  end
  return ranks
end

graph = Matrix.empty(0,0)
graph = addVertex(graph)
graph = addVertex(graph)
graph = addVertex(graph)
graph = addVertex(graph)
graph = addEdge(graph,1,2)
graph = addEdge(graph,2,3)
graph = addEdge(graph,3,4)
graph = addEdge(graph,4,1)
printMatrix(graph)
putsd getCycle(graph)

puts "======END======"

# 1-2-3-4-5
graph = Matrix.empty(0,0)
graph = addVertex(graph)
graph = addVertex(graph)
graph = addVertex(graph)
graph = addVertex(graph)
graph = addVertex(graph)


graph = addEdge(graph,1,2)
graph = addEdge(graph,2,3)
graph = addEdge(graph,3,4)
graph = addEdge(graph,4,5)
#printMatrix(graph)
putsd jordan(graph)

