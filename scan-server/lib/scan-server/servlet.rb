module ScanServer
  class Servlet
    class << self
      def food_summary(user, foods)
        pattern = "| %-20s| %-15s|\n"
        response = pattern % %w(Item Scanned)
        response << '=' * 40
        response << "\n"
        foods.each do |food|
          scan = Scan.filter(:food_id => food.id, :user_id => user.id).reverse_order(:scan_time).limit(1).first
          response << (pattern % [food.to_lcd_str, ScanServer.time_ago_in_words(scan.scan_time.to_i)])
        end
        return response
      end
    end
  end
end
