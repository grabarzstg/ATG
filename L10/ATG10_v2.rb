require 'csv'

def putsa
  return 0
  0.upto($n-1) do |i|
    0.upto($n-1) do |j|
      print "#{$a[[i,j]]}, "
    end
    puts ""
  end
end

def DFSb (v, vf)
    low = 0
    temp = 0
    i = 0

    $d[v] = $cv
    low = $cv
    $cv = $cv + 1

    while (i < $n)
      if (($a[[v,i]] > 0) && (i != vf))
        if ($d[i] == 0)
          temp = DFSb(i, v)
          low = temp if (temp < low)
        else
          low = $d[i] if ($d[i] < low)
        end
      end
      i = i + 1
    end
    if ((vf > -1) && (low = $d[v]))
      $a[[vf,v]] = 2
      $a[[v,vf]] = 2
    end
    return low
end

def findEuler(v)
  mlem = 0
  u = 0
  w = 0
  #i = 0
  while true
    $s[$sptr] = v
    $sptr = $sptr + 1
    #$s.push(v)
    #puts $a.to_s; #sleep(5)
    puts "u: #{u} n: #{$n} v: #{v} u: #{u} a[v][u]: #{$a[[v,u]]} sprt: #{$sptr}"
    u = 0
    while ((u < $n) && ($a[[v,u]] == 0)) #potencjalny problem
      u = u + 1
    end
    puts "u: #{u}"

    break if (u == $n)
    i = 0
    while (i < $n)
      $d[i] = 0
      i = i + 1
    end

    $cv = 1
    DFSb(v, -1)
    putsa
    w = u + 1
    while (($a[[v,u]] == 2) && (w < $n))
      u = w if ($a[[v,w]] > 0)
      w = w + 1
    end
    $a[[v,u]] = 0
    $a[[u,v]] = 0
    v = u
    mlem = mlem + 1
    exit 1 if mlem == 50
  end

end



#deklaracje
$n = 0
$m = 0
$cv = 0
$sptr = 0

$s = Array.new #stos w tablicy
$d = Array.new #tablica numerow wierzcholkow
$a = Array.new

#MAIN
#i = 0
#j = 0
v1 = 0
v2 = 0
vd = 0

filepath = "./input_trywialny.csv"
#filepath = "./input_cykl.csv"
#filepath = "./input_sciezka.csv"
#wczytanie liczby krawedzi i wierzcholkow
$n = CSV.read(filepath)[0][0].to_i
$m = CSV.read(filepath)[0][1].to_i

#tworzenie macierzy sasiedztwa i wypelnianie zerami
#$a = Array.new($n, Array.new($n, 0))
$a = Hash.new(0)
#tworzenie i zerowanie tablicy stopni
vd = Array.new($n, 0)

#tablica numerow
$d = Array.new($n)

#pusty stos
$s = Array.new #($m+1)

#puts $a.to_s
#definicje krawedzi
$counter = -1
options = {:headers => false}
CSV.foreach(filepath, options) do |a, b|

  $counter = $counter + 1
  next if $counter == 0
  v1 = a.to_i ; v2 = b.to_i
  puts "#{v1} - #{v2}"
  $a[[v1,v2]] = 1
  $a[[v2,v1]] = 1
  vd[v1] = vd[v1] + 1
  vd[v2] = vd[v2] + 1
end



v1 = 0
while (v1 < $n)
  break if (vd[v1] > 0)
  v1 = v1 + 1
end
i = v1
while (i < $n)
  if (vd[i] % 2 == 0)
    v1 = i
    break
  end
  i = i + 1
end

findEuler(v1)

#wypisywanie zawartosci stosu
if !($s.first == $s.last)
  puts "Sciezka Eulera"
else
  puts "Cykl Eulera"
end
puts $s.to_s
