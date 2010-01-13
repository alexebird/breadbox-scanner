require FoodDB[:root] + '/lib/food_locations'

# TODO Times for how long a food lasts are stored as days in the database.
#
class Food < Sequel::Model
  Food.plugin :timestamps
  one_to_many :scans
  many_to_many :users

  def last_scan_for(scanner)
    self.scans_dataset.filter(:scanner_id => scanner.id).reverse_order(:timestamp).limit(1).first
  end

  # Time in words until the food exprires for the user belonging to the given scanner.
  # Also returns the location string for the food. (Saves db queries)
  #
  def time_and_location_for(scanner)
    last_scan = last_scan_for(scanner)
    expires_in = nil 
    location_s = ''
    case last_scan.location
      when FoodLocations::ROOM
        expires_in = self.room
        location_s = 'room'
      when FoodLocations::FRIDGE
        expires_in = self.fridge
        location_s = 'fridge'
      when FoodLocations::FREEZER
        expires_in = self.freezer
        location_s = 'freezer'
      else raise "Unknown food location."
    end
    return "never", location_s unless expires_in
    expires_in *= 24 * 60 * 60
    return ScanServer.time_diff_in_words(Time.now, last_scan.timestamp + expires_in), location_s
  end

  def to_lcd_str
    "%s" % [@values[:name]]
  end
end
