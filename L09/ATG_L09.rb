#!/usr/local/ruby/bin/ruby
# encoding: utf-8
#RUBY_VERSION# 1.9.3

class Node
  attr_accessor :data
  attr_accessor :next

  def initialize(data = nil, nex = nil)
    @data = data
    @next = nex
  end

  def to_s
    return "@data = #{@data} | @next = #{@next}"
  end
end

def isBipartite(n)
  0.upto(n-1) do |i|
    if $color[i] == 0
      $color[i] = 1
      $q.push(i)
      while !$q.empty?
        $v = $q.pop
        $pr = $graf[$v] #Array
        while !$pr.nil?
          $u = $pr.data # pobieramy z listy sasiedztwa numer sasiada
          return false if $color[$u] == $color[$v]
          if $color[$u] == 0
            $color[$u] = $color[$v] * -1
            $q.push($u)
          end
          $pr = $pr.next #nastepny sasiad
        end
      end
    end
  end
  return true
end

# MAIN

puts "Podaj n:"
STDOUT.flush
$n = gets.chomp.to_i

puts "Podaj m:"
STDOUT.flush
$m = gets.chomp.to_i


$cfp = Array.new
#$n, $m, $fmax, $cp, $v, $u, $i, $j = 0
$esc = true
#$pr, $rr

$q = Array.new
$graf = Array.new($n)
$color = Array.new($n,0)
$c = Array.new($n+2) { Array.new($n+2, 0) }
$f = Array.new($n+2) { Array.new($n+2, 0) }
$p = Array.new($n+2)
$cfp = Array.new($n+2)

1.upto($m) do |i|
  puts "Podaj v:"
  STDOUT.flush
  $v = gets.to_i
  puts "Podaj u:"
  STDOUT.flush
  $u = gets.to_i

  $pr = Node.new()
  $pr.data = $u
  $pr.next = $graf[$v]
  $graf[$v] = $pr

  $pr = Node.new()
  $pr.data = $v
  $pr.next = $graf[$u]
  $graf[$u] = $pr

  #$graf[$v] = Node.new($u, $graf[$v])
  #$graf[$u] = Node.new($v,$graf[$u])

end
if isBipartite($n)
  0.upto($n-1) do |i|
    if $color[i] == -1
      $pr = $graf[i]
      while !$pr.nil?
        $c[i][$pr.data] = 1
        $pr = $pr.next
      end
      $c[$n][i] = 1
    else
      $c[i][$n+1] = 1
    end
  end

  # Edmons-Karp
  $fmax = 0
  while true
    0.upto($n+1) do |i|
      $p[i] = -1
    end

    $p[$n] = -2
    $cfp[$n] = Float::INFINITY
    while !$q.empty?
      $q.pop
    end
    $q.push($n)

    $esc = false

    while !$q.empty?
      $v = $q.pop
      0.upto($n+1) do |u|
        $cp = $c[$v][u] - $f[$v][u]
        if $cp != 0 and $p[u] == -1
          $p[u] = $v
          if $cfp[$v] > $cp
            $cfp[u] = $cp
          else
            $cfp[u] = $cfp[$v]
          end
          if u == $n+1
            $fmax = $fmax + $cfp[$n+1]
            i = u
            while i != $n
              $v = $p[i]
              $f[$v][i] = $f[$v][i] + $cfp[$n+1]
              $f[i][$v] = $f[i][$v] - $cfp[$n+1]
              i = $v
            end
            $esc = true
            break
          end
          $q.push(u)
        end
      end
      break if $esc
    end
    break if !$esc
  end
  puts "\nILOSC SKOJARZEN: #{$fmax}\n"
  if $fmax > 0
    0.upto($n-1) do |v|
      0.upto($n-1) do |u|
        puts "#{v} - #{u}" if $c[v][u] == 1 and $f[v][u] == 1
      end
    end
  end
end
