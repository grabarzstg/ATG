#!/usr/local/ruby/bin/ruby
# encoding: utf-8
#RUBY_VERSION# 1.9.3
require 'csv'

$nptr = Array.new

# v - numer wierzcholka startowego
# vf - ojciec v na drzewie rozpinajacym
def DFSb(v, vf) #wyszukiwanie mostow w grafie
  $d[v] = $cv
  low = $cv
  $cv = $cv + 1
  0.upto($n-1) do |i|
    if $a[v][i] > 0 and i != vf
      if $d[i] == 0
        temp = DFSb(i, v)
        low = temp if temp < low
      else
        low = $d[i] if $d[i] < low
      end
    end
  end
  if vf > -1 and low == $d[v]
    $a[vf][v] = 2
    $a[v][vf] = 2
  end
  return low
end

def findEuler(v)
  while true
    $s[$sptr] = v
    $sptr = $sptr + 1
    u = 0
    puts $a.to_s
    puts "#{u} #{$n} #{$a[v][u]}"
    while u < $n and $a[v][u] == 0
      u = u + 1
    end

    break if u == $n

    $d = Array.new($n, 0)

    $cv = 1
    DFSb(v, -1)

    w = u + 1
    while $a[v][u] == 2 and w < $n
      u = w if $a[v][w] > 0
      w = w + 1
    end

    $a[v][u] = 0
    $a[u][v] = 0
    v = u
  end
end

# MAIN

filepath = "./input.csv"
$n = CSV.read(filepath)[0][0].to_i
$m = CSV.read(filepath)[0][1].to_i
$a = Array.new($n, Array.new($n, 0)) #tworzenie macierzy sasiedztwa
$vd = Array.new($n, 0) #tworzenie macierz stopni

$d = Array.new($n) #tablica numerow

$s = Array.new($m+1)
$sptr = 0

#definicje krawedzi
#$counter = -1
#options = {:headers => false}
#CSV.foreach(filepath, options) do |a, b|
#  puts "#{a}  - #{b}"
#  $counter = $counter + 1
#  next if $counter == 0
#  v = a.to_i ; u = b.to_i
#  $a[v][u] = 1
#  $a[u][v] = 1
#  $vd[v] = $vd[v] + 1
#  $vd[u] = $vd[u] + 1
#end




#pozycja startowa
0.upto($n-1) do |j|
  $v1 = j
  break if $vd[$v1] > 0
end

$v1.upto($n-1) do |i|
  if $vd[i] % 2 == 1
    $v1 = i
    break
  end
end

findEuler($v1)

#wypisywanie zawartosci stosu
if $vd[$v1] % 2 == 1
  puts "Sciezka Eulera"
else
  puts "Cykl Eulera"
end

puts $s
