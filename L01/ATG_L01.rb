#!/usr/local/ruby/bin/ruby 
# encoding: utf-8
#RUBY_VERSION# 1.9.3

require 'matrix'

class Matrix
  def []=(row, column, value)
    @rows[row][column] = value
  end
end

$matrix = Matrix.empty(0,0) 

# zarzadzanie wierzcholkami
def addVertex
  row = Array.new
  (1..$matrix.row_size).each do
    row << 0
  end
  col = Array.new
  (0..$matrix.column_size).each do
    col << 0
  end
  $matrix = Matrix.rows($matrix.transpose.to_a << row)
  $matrix = Matrix.columns($matrix.transpose.to_a << col)
  $matrix.normal? #sprawdzenie czy macierz jest poprawnego rozmiaru
end

def remVertex(index)
  arr = $matrix.transpose.to_a
  arr.each do |row|
    row.delete_at index
  end
  arr.delete_at index
  $matrix = Matrix.rows(arr)
  $matrix.normal? #sprawdzenie czy macierz jest poprawnego rozmiaru
end

# zarzadzanie krawedziami
def addEdge(row, col)
  checkIndex([row,col])
  $matrix.[]=(row-1, col-1, 1)
  $matrix.[]=(col-1, row-1, 1)
end

def remEdge(row, col)
  $matrix.[]=(row, col, 0)
  $matrix.[]=(col, row, 0)
end

# tools
def checkIndex(arr)
  arr.each do |i|
    raise IndexError if i > $matrix.row_size || i < 0
  end
end

def nextIndex
  return $matrix.row_size + 1
end

def printMatrix
  i = $matrix.row_size
  j = $matrix.column_size
  puts "i = #{i.to_s}"

  puts "j = #{j.to_s}"
  puts $matrix.to_s
end

def showStats
  # TODO: wyznaczenie stopnia wierzcholka oraz minimalnego i maksymalnego stopnia grafu, wyznaczenie, ile jest wierzcholkow stopnia parzystego i nieparzystego
  ranks = Array.new
  $matrix.to_a.each do |row|
    rank = 0
    row.each do |i|
      rank += i
    end
    ranks << rank
  end
  even = 0
  odd = 0
  ranks.each do |e|
    if e.even?
      even += 1
    else
      odd += 1
    end
  end

  puts "----- STATS -----"
  puts "Ranks: #{ranks.to_s}"
  puts "Ranks (sorted): #{ranks.sort {|x,y| y <=> x }}"
  puts "Min rank: #{ranks.min}"
  puts "Max rank: #{ranks.max}"
  puts "Odd ranks: #{odd}"
  puts "Even ranks: #{even}"
end

# 1.2 W oparciu o reprezentacje grafu w postaci macierzy sasiedztwa zaimplementuj procedure, ktora sprawdza, czy graf zawiera podgraf izomorficzny do cyklu C3.
$c3graph = Matrix.rows([[0,1,1,0],[1,0,1,0],[1,1,0,0],[0,0,0,0]])
puts "c3" + $c3graph.to_s
def c3naive
  # TODO: sprawdzamy wszystkie trojki
end

def c3multiply
  # TODO: A^3 jezeli Matrix.trace() >0 to C3 = true
end

# 1.3a Zaimplementuj procedure sprawdzajaca, czy dany (nierosnacy) ciag liczb naturalnych jest ciagiem grafowym.
def graphSequence
  sequence = [3,3,2,2] # [3,3,2,1]
end

#1.3b Zaimplementuj procedure, ktora w przypadku odpowiedzi pozytywnej na punkt (a) zwroci (jakikolwiek) graf prosty (w postaci macierzy sasiedztwa) realizujacy ten ciag.
def simpleGraphBySequence

end



# MAIN

addVertex
addVertex
addVertex
addVertex
addEdge(1,2)
addEdge(1,3)
addEdge(2,3)
addEdge(2,4)
addEdge(3,4)

printMatrix
showStats
puts "------ tst -------"
puts $matrix * $matrix
