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
    check_row_and_column(homes) || check_elephent_path(homes)
  end

  def check_elephent_path(homes) 
    homes.any? {|h| ( (h.x+h.y == @x+@y) && h.is_filled && h.x != @x) || ( (h.x-h.y == @x-@y) && h.is_filled && h.x != @x)}
  end

  def check_row_and_column(homes)
    homes.any? {|h| ((h.x == @x) && (h.y != @y) && h.is_filled) || ((h.y == @y) && (h.x != @x) && h.is_filled)}
  end
end
