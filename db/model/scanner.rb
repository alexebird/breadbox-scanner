class Scanner < Sequel::Model
  plugin :timestamps
  many_to_one :user
  one_to_many :scans
end
