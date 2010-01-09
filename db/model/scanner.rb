class Scanner < Sequel::Model
  Scanner.plugin :timestamps
  many_to_one :user
  one_to_many :scans
end
