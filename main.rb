class Home

  attr_reader :x, :y, :is_filled
  def initialize(x, y)
    @x = x
    @y = y
    @is_filled = false
  end

  def clean
    @is_filled = false
  end

  def fill
    @is_filled = true
  end

  def can_capture?(homes)
    check_row_and_column(homes, self) || check_elephent_path(homes, self)
  end

  def self.find(homes, x, y)
    homes.select {|h| h.x==x and h.y==y} .first
  end
end

def check_elephent_path(homes, home) 
  homes.any? {|h| ( (h.x+h.y == home.x+home.y) && h.is_filled && h.x != home.x) || ( (h.x-h.y == home.x-home.y) && h.is_filled && h.x != home.x)}
end

def check_row_and_column(homes, home)
  homes.any? {|h| ((h.x == home.x) && (h.y != home.y) && h.is_filled) || ((h.y == home.y) && (h.x != home.x) && h.is_filled)}
end

def generate_homes 
  homes = []
  (1..8).each do |y|
    (1..8).each do |x|
      homes << Home.new(x, y)
    end
  end
  homes
end

def print_homes(homes)
  i = 0
  puts "-"*33
  while i < homes.length 
    print homes[i].is_filled ? "| 0 " : "|   "
    i+=1
    if i % 8 == 0 
      print "|"
      puts
      puts "-"*33
    end
  end
end

def is_valid?(homes)
  homes.all?{|h| !h.can_capture?(homes) }
end

def solve(homes, x, y) 
  home = Home.find(homes, x, y)
  if x > 8 
    previous_home = homes.select {|h| h.is_filled && h.y == y-1} .last
    previous_home.clean
    solve(homes, previous_home.x+1, y-1)
  elsif x == 8 && home.can_capture?(homes)
    previous_home = homes.select {|h| h.is_filled && h.y == y-1} .last
    previous_home.clean
    solve(homes, previous_home.x+1, y-1)
  elsif home.can_capture?(homes)
    solve(homes, x+1, y)
  elsif y == 8
    home.fill
    puts "FOUND IT!"
    print_homes homes
    homes
  else
    home.fill
    solve(homes, 1, y+1)
  end
end

homes_state = generate_homes
solve(homes_state, 1, 1)
