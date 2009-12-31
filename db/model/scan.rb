class Scan < Sequel::Model
  many_to_one :food
  many_to_one :user
end
