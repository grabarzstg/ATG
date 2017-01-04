#!/usr/local/ruby/bin/ruby
# encoding: utf-8
#RUBY_VERSION# 1.9.3

DEBUG = true
def putsd(string)
  puts string.to_s if DEBUG
end

def EdmonsKarp(c, t, source, target)
  flow = 0
  f = Hash.new(0)
  while true
    result = BFS(c, t, source, target, f)
    puts result.to_s
    m = result[0]
    p = result[1]
    if m == 0
      break
    end
    flow += m
    v = target
    while v != source
      u = p[v]
      puts "u: #{u} v: #{v}"
      f["#{u}#{v}"] = f["#{u}#{v}"] + m
      f["#{v}#{u}"] = f["#{v}#{u}"] - m
      t["#{u}#{v}"] = t["#{u}#{v}"] - m
      t["#{v}#{u}"] = t["#{v}#{u}"] + m
      v = u
    end
  end
  return [flow, f]
end

def BFS(c, t, source, target, f)
  p = Hash.new(-1) #parent table
  p[source] = -2
  m = Hash.new(0)
  m[source] = Float::INFINITY
  q = Queue.new
  q.push source
  while q.size > 0
    u = q.pop
    c.each do |key, val|
      v = key.scan(/./)[1]
      puts key; puts "next"; next if t["#{u}#{v}"].nil?
      if t["#{u}#{v}"] > 0 and p[v] == -1
        p[v] = u
        m[v] = [m[u], c["#{u}#{v}"] - f["#{u}#{v}"]].min
        if v != target
          q.push(v)
        else
          return [m[target], p]
        end
      end
    end
  end
  return [0, p]
end

#INPUT
c = Hash.new(0)   #capacity matrix
source = ""
target = ""
File.readlines("input.csv").each_with_index do |line, index|
  if index == 0
    next
  end
  tmp = line.split(",")
  c["#{tmp[0]}#{tmp[1]}"] = tmp[2].to_i
  source = tmp[0] if tmp[3] == "true"
  target = tmp[1] if tmp[4] == "true\n"
end
t = Hash.new(0)
t = t.merge(c)   #residual matrix
putsd "source: #{source}\ttarget: #{target}"
puts c.to_s
result = EdmonsKarp(c, t, source, target)

puts "Maksymalny przeplyw: #{result[0]}"
puts "Minimalny przekroj:  #{result[1]}"
