#!/usr/local/ruby/bin/ruby
# encoding: utf-8
#RUBY_VERSION# 1.9.3

require 'matrix'

DEBUG = false

class Matrix
  def []=(row, column, value)
    @rows[row][column] = value
  end
end

def putsd(string)
  puts string if DEBUG
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

def showStats(matrix)
  # wyznaczenie stopnia wierzcholka oraz minimalnego i maksymalnego stopnia grafu, wyznaczenie, ile jest wierzcholkow stopnia parzystego i nieparzystego
  ranks = Array.new
  matrix.to_a.each do |row|
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
def c3naive?(matrix)
  arr = Array.new(matrix.row_size){ |index| index + 1}
  arr.permutation(3).each do |e|
    return true if matrix.element(e[0],e[1]) == 1 && matrix.element(e[0],e[2]) == 1 && matrix.element(e[1],e[2]) == 1
  end
  return false
end

def c3multiply?(matrix)
  a3 = matrix * matrix * matrix
  return true if (a3.trace > 0)
  return false
end

# 1.3a Zaimplementuj procedure sprawdzajaca, czy dany (nierosnacy) ciag liczb naturalnych jest ciagiem grafowym.
def graphSequence(sequence)
  sequence.sort! {|x,y| y <=> x }
  return true if sequence[0] <= 0
  1.upto(sequence[0]) do |i|
    sequence[i] = sequence[i] - 1
  end
  sequence.delete_at(0)
  sequence.each do |e|
    return false if e < 0
  end
  graphSequence(sequence)
end

#1.3b Zaimplementuj procedure, ktora w przypadku odpowiedzi pozytywnej na punkt (a) zwroci (jakikolwiek) graf prosty (w postaci macierzy sasiedztwa) realizujacy ten ciag.
def simpleGraphBySequence(sequence)
  if graphSequence Array.new(sequence)
    #przygotowanie pustej macierzy
    matrix = Matrix.empty(0,0)
    1.upto(sequence.length) {matrix = addVertex(matrix)}
    1.upto(sequence.length) do
      id = sequence.index(sequence.max)
      putsd "#{sequence} #{id} #{sequence.max}"
      1.upto(sequence[id]) do |mv|
        if (id + mv + 1) <= sequence.length
          putsd "#id: #{id+1}, mv: #{mv}, idmv: #{id+mv+1} ,sl: #{sequence.length}"
          matrix = addEdge(matrix, id+1, id + mv + 1)
          sequence[id] -= 1
          sequence[id+mv] -= 1
        else
          putsd "#id: #{id+1}, mv: #{mv}, idmv: #{id+mv+1} ,sl: #{sequence.length}"
          mv = sequence.length - (mv + id+1)
          putsd "AOI - new mv: #{mv}, idmv: #{id+mv+1} "
          matrix = addEdge(matrix, id+1, id + mv+1)
          sequence[id] -= 1
          sequence[id+mv] -= 1
        end
      end
    end
    puts "Podany ciag reprezentuje graf w postaci macierzy sasiedztwa:"
    printMatrix(matrix)
    return matrix
  else
    puts "Podany ciag nie jest reprezentacja grafu prostego."
    return null
  end
end

# MAIN
puts "--- 1.1 a"
matrix = Matrix.empty(0,0)
matrix = addVertex(matrix)
matrix = addVertex(matrix)
matrix = addVertex(matrix)
matrix = addVertex(matrix)
matrix = addEdge(matrix,1,2)
matrix = addEdge(matrix,2,3)
matrix = addEdge(matrix,3,4)
matrix = addEdge(matrix,1,4)
printMatrix(matrix)
puts "--- 1.1 b-d"
showStats(matrix)
puts "--- 1.2 a"
puts c3naive?(matrix)
puts "--- 1.2 b"
puts c3multiply?(matrix)
puts "--- 1.3 a-b"
simpleGraphBySequence([3,3,2,2])
