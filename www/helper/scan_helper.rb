module Ramaze
  module Helper
    module ScanHelper
      def food_name(scan)
        scan.food ? scan.food.name : "Deleted food"
      end
    end
  end
end
