#!/usr/local/ruby/bin/ruby
# encoding: utf-8
#RUBY_VERSION# 1.9.3

require 'matrix'

class Matrix
  def []=(row, column, value)
    @rows[row][column] = value
  end
end

# matrix = Matrix.empty(0,0)
$matrix = Matrix.build(3, 3) {|row, col| 0 }

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
  # arr.delete_at usuniecie kolumny
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
  $matrix.[]=(row, col, 1)
  $matrix.[]=(col, row, 1)
end

def remEdge(row, col)
  $matrix.[]=(row, col, 0)
  $matrix.[]=(col, row, 0)
end

# tools
def checkIndex(arr)
  arr.each do |i|
    raise Matrix::ErrDimensionMismatch("blin") if i > $matrix.row_size || i < 0
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
  # TODO: wyznaczenie stopnia wierzchołka oraz minimalnego i maksymalnego stopnia grafu, wyznaczenie, ile jest wierzchołków stopnia parzystego i nieparzystego
  ranks = Array.new
  $matrix.to_a.each do |row|
    rank = 0
    row.each do |i|
      rank = rank + i
    end
    ranks << rank
  end
  puts "----- STATS -----"
  puts "Ranks: #{ranks.to_s}"
  puts "MinRank: #{ranks.min}"
  puts "MaxRank: #{ranks.max}"
end

# MAIN

addVertex
addEdge(1,2)
#remVertex 2
printMatrix
showStats
