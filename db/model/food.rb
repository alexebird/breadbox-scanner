class Food < Sequel::Model
  Food.plugin :timestamps
  one_to_many :scans
  many_to_many :users

  def to_lcd_str
    "%s" % [@values[:name]]
  end
end
