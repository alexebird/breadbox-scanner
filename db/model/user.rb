class User < Sequel::Model
  one_to_many :scanners
  many_to_many :foods

  def add_food(food)
    inventory = foods
    if foods.include? food
      remove_food(food)
    else
      super.add_food(food)
    end
  end
end
