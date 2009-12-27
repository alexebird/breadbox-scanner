class Food < Sequel::Model
  many_to_one :user
end
