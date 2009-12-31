class Food < Sequel::Model
  one_to_many :scans
  many_to_many :users

  def to_lcd_str
    "%s" % [@values[:name]]
  end
end
