require_relative 'home.rb'

class Board

  attr_accessor :board_length, :filled_char
  def initialize(board_length, required_answers: 1, filled_char: "0")
    @board_length = board_length
    @required_answers = required_answers
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

  def previous_home(home, y) 
    previous_home = @homes.select {|home| home.is_filled && home.y == y-1} .last
  end

  def solve(x = 1, y = 1, calculated_answers = 0) 
    unless calculated_answers == @required_answers
      home = find(x, y)
      if x > @board_length
        pre_home = previous_home(home, y)
        pre_home.clean
        solve(pre_home.x+1, y-1, calculated_answers)
      elsif x == @board_length && home.can_capture?(@homes)
        pre_home = previous_home(home, y)
        pre_home = @homes.select {|h| h.is_filled && h.y == y-1} .last
        pre_home.clean
        solve(pre_home.x+1, y-1, calculated_answers)
      elsif home.can_capture?(@homes)
        solve(x+1, y, calculated_answers)
      elsif y == @board_length
        home.fill
        puts "#{calculated_answers+1}:"
        print_homes
        unless calculated_answers+1 == @required_answers
          home.clean
          pre_home = previous_home(home, y)
          pre_home = @homes.select {|h| h.is_filled && h.y == y-1} .last
          pre_home.clean
          solve(pre_home.x+1, y-1, calculated_answers+1)
        end
      else
        home.fill
        solve(1, y+1, calculated_answers)
      end
    end
  end
end
