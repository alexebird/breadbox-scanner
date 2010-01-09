# TODO Times for how long a food lasts are stored as days in the database.
#
class Food < Sequel::Model
  Food.plugin :timestamps
  one_to_many :scans
  many_to_many :users

  ROOM = 10
  FRIDGE = 11
  FREEZER = 12

  def last_scan_for(scanner)
    self.scans_dataset.filter(:scanner_id => scanner.id).reverse_order.limit(1).first
  end

  # Time in words until the food exprires for the user belonging to the given scanner.
  #
  def time_til_expires_for(scanner)
    last_scan = last_scan_for(scanner)
    expires_in = nil 
    debug last_scan.location
    case last_scan.location
      when Food::ROOM then expires_in = self.room
      when Food::FRIDGE then expires_in = self.fridge
      when Food::FREEZER then expires_in = self.freezer
      else puts 'wtf'
    end
    return "never" unless expires_in
    expires_in *= 24 * 60 * 60
    ScanServer.time_diff_in_words(Time.now, last_scan.timestamp + expires_in)
  end

  def to_lcd_str
    "%s" % [@values[:name]]
  end
end
