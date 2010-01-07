class User < Sequel::Model
  one_to_many :scanners
  many_to_many :foods

  def add_inventory_food(food, scan)
    scan = Scan.new(:user => self, :food => food, :timestamp => Time.now)
    puts self.foods_dataset
    # TODO set the scan id to scan in the foods_users table
  end

  # Returns a list of foods which the user has in their inventory.  The inventory list
  # is ordered with least recently scanned items first.
  #
  def inventory
    inventory = self.foods
    inventory.each do |f|
      f[:scan] = self.scans_dataset.filter(:food_id => f.id).select(:scan_time).limit(1).reverse_order(:scan_time).first[:scan_time]
    end
    return inventory
  end

  def inventory_str
    pattern = "| %-20s| %-15s|\n"
    response = pattern % %w(Item Scanned)
    response << '=' * 40
    response << "\n"
    self.inventory.each do |food|
      response << (pattern % [food.to_lcd_str, ScanServer.time_ago_in_words(food[:scan].to_i)])
    end
    return response.chomp
  end
end
