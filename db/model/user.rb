class User < Sequel::Model
  one_to_many :scans
  many_to_many :foods
end
