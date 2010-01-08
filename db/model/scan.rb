class Scan < Sequel::Model
  many_to_one :food
  many_to_one :scanner

  def initialize(values={}, from_db=false)
    super(values, from_db)
    self.timestamp = Time.now
  end
end
