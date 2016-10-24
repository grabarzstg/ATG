#!/usr/local/ruby/bin/ruby
# encoding: utf-8
#RUBY_VERSION# 1.9.3

#require 'matrix'
require '../lib/graphmatrix'

DEBUG = false

def putsd(string)
  puts string if DEBUG
end

# 1.1 Zaimplementuj odpowiednie struktury danych i procedury pozwalajace na przechowywanie grafu w postaci macierzy sasiedztwa
# implementacja w /lib/graphmatrix.rb
# 1.2 W oparciu o reprezentacje grafu w postaci macierzy sasiedztwa zaimplementuj procedure, ktora sprawdza, czy graf zawiera podgraf izomorficzny do cyklu C3.
def c3naive?(matrix)
  arr = Array.new(matrix.row_size){ |index| index + 1}
  arr.permutation(3).each do |e|
    return true if matrix.element(e[0],e[1]) == 1 && matrix.element(e[0],e[2]) == 1 && matrix.element(e[1],e[2]) == 1
  end
  return false
end

def c3multiply?(matrix)
  puts matrix
  a3 = matrix ** 3
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
    matrix = GraphMatrix.empty(0,0)
    1.upto(sequence.length) {matrix = addVertex(matrix)}
    1.upto(sequence.length) do
      id = sequence.index(sequence.max)
      putsd "#{sequence} #{id} #{sequence.max}"
      1.upto(sequence[id]) do |mv|
        if (id + mv + 1) <= sequence.length
          putsd "#id: #{id+1}, mv: #{mv}, idmv: #{id+mv+1} ,sl: #{sequence.length}"
          matrix = addEdge(id+1, id + mv + 1)
          sequence[id] -= 1
          sequence[id+mv] -= 1
        else
          putsd "#id: #{id+1}, mv: #{mv}, idmv: #{id+mv+1} ,sl: #{sequence.length}"
          mv = sequence.length - (mv + id+1)
          putsd "AOI - new mv: #{mv}, idmv: #{id+mv+1} "
          matrix = addEdge(id+1, id + mv+1)
          sequence[id] -= 1
          sequence[id+mv] -= 1
        end
      end
    end
    puts "Podany ciag reprezentuje graf w postaci macierzy sasiedztwa:"
    matrix.print
    return matrix
  else
    puts "Podany ciag nie jest reprezentacja grafu prostego."
    return null
  end
end

# MAIN
puts "--- 1.1 a"
matrix = GraphMatrix.build(2){2}
=begin
matrix.addVertex
matrix.addVertex
matrix.addVertex
matrix.addVertex
matrix.addEdge(1,2)
matrix.addEdge(2,3)
matrix.addEdge(3,4)
matrix.addEdge(1,4)
#matrix.remEdge(2,3)
#matrix.remVertex(1)
matrix.print
=end
puts "--- 1.1 b-d"
matrix.showStats
puts "--- 1.2 a"
puts c3naive?(matrix)
puts "--- 1.2 b"
puts c3multiply?(matrix)
puts "--- 1.3 a-b"
simpleGraphBySequence([3,3,2,2])
