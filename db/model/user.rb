class User < Sequel::Model
  User.plugin :timestamps
  one_to_many :scanners
  many_to_many :foods

  def scan_food(food)
    if foods.include? food
      remove_food(food)
    else
      add_food(food)
    end
  end
end
