class Food < Sequel::Model
  Food.plugin :timestamps
  one_to_many :scans
  many_to_many :users

  def last_scan_for(user)
    self.scans_dataset.filter(:user => user).reverse_order.limit(1).first
  end

  def to_lcd_str
    "%s" % [@values[:name]]
  end
end
