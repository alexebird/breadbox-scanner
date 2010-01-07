class Scanner < Sequel::Model
  many_to_one :user
  one_to_many :scans
end
