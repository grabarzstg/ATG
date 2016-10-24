require 'matrix'
class GraphMatrix < Matrix
  def []=(row, column, value)
    @rows[row][column] = value
  end

  #tools
  def print
    # TODO: create simple graph drawing in console
    @rows.each do |row|
      puts row.to_s
    end
  end

  # vertex management
  def addVertex
    row = Array.new
    (0..self.row_size).each do
      row << 0
    end
    @rows.each do |r|
      r << 0
    end
    @rows << row
    self.square?
  end

  def remVertex(index)
    arr = self.transpose.to_a
    arr.each do |row|
      row.delete_at index
    end
    arr.delete_at index
    @rows = arr
    self.square?
  end

  # edges management
  def addEdge(row, col)
    raise IndexError if row > self.row_size || row < 0 || col > self.row_size || col < 0
    @rows[row-1][col-1] = 1
    @rows[col-1][row-1] = 1
  end

  def remEdge(row, col)
    self.[]=(row, col, 0)
    self.[]=(col, row, 0)
  end

  def showStats
    ranks = Array.new
    self.to_a.each do |row|
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
end
