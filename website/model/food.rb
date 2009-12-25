class Food < Sequel::Model
  set_schema do
    primary_key :id
    String :name
    String :rfid
    String :major
    String :minor
    Fixnum :room_start 
    Fixnum :room_end
    Fixnum :fridge_start 
    Fixnum :fridge_end
    Fixnum :freezer_start 
    Fixnum :freezer_end
  end

  create_table unless table_exists?
end
