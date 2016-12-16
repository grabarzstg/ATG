#!/usr/local/ruby/bin/ruby
# encoding: utf-8
#RUBY_VERSION# 1.9.3

DEBUG = true
def putsd(string)
  puts string.to_s if DEBUG
end



def EdmonsKarp(c, t, source, target)
  flow = 0        #value of maximum flow
  f = Hash.new   #flow matrix




end





#INPUT
c = Hash.new   #capacity matrix
source = ""
target = ""
File.readlines("input.csv").each_with_index do |line, index|
  if index == 0
    next
  end
  tmp = line.split(",")
  c["#{tmp[0]}#{tmp[1]}"] = tmp[2]
  source = tmp[0] if tmp[3]
  target = tmp[1] if tmp[4]
end
t = c   #residual matrix
putsd "source: #{source}\ttarget: #{target}"
puts c.to_s
