class User < Sequel::Model
  one_to_many :scans
  many_to_many :foods

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
    return response
  end

  # Returns the scan of food made by this user.
  # [food] The food to get the last scan of.
  #
  #def last_scan(food)
    #Scan.filter(:food_id => food.id, :user_id => self.id).reverse_order(:scan_time).limit(1).first
  #end
end
