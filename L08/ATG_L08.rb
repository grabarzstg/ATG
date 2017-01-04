#!/usr/local/ruby/bin/ruby
# encoding: utf-8
#RUBY_VERSION# 1.9.3

DEBUG = true
def putsd(string)
  puts string.to_s if DEBUG
end




def EdmonsKarp(c, t, source, target)
  flow = 0        #value of maximum flow
  f = Hash.new(0)   #flow matrix
  # stworzenie sieci residualnej
  r = Hash.new
  f.each do |k, v|
    r[k] = c[k] - f[k]
  end
  path = true
  while path do
    #znalezienie ścieżki z s do t w sieci residualnej
    p = BFS(r, source, target)
    if p.nil?
      path = false
    else
      # powiekszenie przeplywu na sciezce p
      #a = min(r[u,v])
      puts "ELSE"
    end
  end
end

def BFS(r, s, t)
  r.each do |key, val|

  end

end

#INPUT
c = Hash.new   #capacity matrix
g =
source = ""
target = ""
File.readlines("input.csv").each_with_index do |line, index|
  if index == 0
    next
  end
  tmp = line.split(",")
  c["#{tmp[0]}#{tmp[1]}"] = tmp[2].to_i
  source = tmp[0] if tmp[3]
  target = tmp[1] if tmp[4]
end
t = c   #residual matrix
putsd "source: #{source}\ttarget: #{target}"
puts c.to_s
