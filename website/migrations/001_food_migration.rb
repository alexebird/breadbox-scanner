class CreateFoodsTable < Sequel::Migration
  def up
    create_table :foods do
      primary_key :id, :auto_increment => true, :null => false
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
  end

  def down
    drop_table :foods
  end
end
