require_relative 'home.rb'

class Board

  attr_accessor :board_length, :filled_char
  def initialize(board_length, filled_char = "0")
    @board_length = board_length
    @homes = generate_homes()
    @filled_char = filled_char
  end

  def generate_homes 
    homes = []
    (1..@board_length).each do |y|
      (1..@board_length).each do |x|
        homes << Home.new(x, y)
      end
    end
    homes
  end

  def find(x, y)
    @homes.select {|h| h.x==x and h.y==y} .first
  end

  def print_homes
    i = 0
    length = (2+@filled_char.length)*@board_length+@board_length+1
    puts "-"*length
    while i < @homes.length 
      print @homes[i].is_filled ? "| #{@filled_char} " : "| #{" "*@filled_char.length} "
      i+=1
      if i % @board_length == 0 
        print "|"
        puts
        puts "-"*length
      end
    end
  end

  def solve(x, y) 
    home = find(x, y)
    if x > @board_length
      previous_home = @homes.select {|h| h.is_filled && h.y == y-1} .last
      previous_home.clean
      solve(previous_home.x+1, y-1)
    elsif x == @board_length && home.can_capture?(@homes)
      previous_home = @homes.select {|h| h.is_filled && h.y == y-1} .last
      previous_home.clean
      solve(previous_home.x+1, y-1)
    elsif home.can_capture?(@homes)
      solve(x+1, y)
    elsif y == @board_length
      home.fill
      print_homes
    else
      home.fill
      solve(1, y+1)
    end
  end
end
